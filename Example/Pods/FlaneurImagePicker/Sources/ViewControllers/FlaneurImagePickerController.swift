//
//  FlaneurImagePickerController.swift
//  FlaneurImagePickerController
//
//  Created by Frenchapp on 11/07/2017.
//  Copyright © 2017 Frenchapp. All rights reserved.
//

import UIKit
import IGListKit
import ActionKit

/// Implement this protocol and set delegate property to self in order to be notified when
/// the user has picked images or has cancelled the picking
public protocol FlaneurImagePickerControllerDelegate {
    
    /// Called whenever the user end picking images, aka: whenever the user touches the button done
    ///
    /// - Parameters:
    ///   - images: An array of picked images of type FlaneurImageDescription
    ///   - userInfo:  Arbitrary data
    func didPickImages(images: [FlaneurImageDescription], userInfo: Any?)
    
    /// Called whenever the user cancels the picking, aka: whenever the user touches the button cancel
    func didCancelPickingImages()
}

/// An Image Picker that allows users to pick images from different sources (ex: user's library,
/// user's camera, instagram ...)
final public class FlaneurImagePickerController: UIViewController {
    
    // MARK: - Views

    var navigationBar: FlaneurImagePickerNavigationBar!
    
    var collectionViews: [UICollectionView] = [UICollectionView]()
    
    var pageControl = UIPageControl(frame: .zero)
    
    // MARK: - Initializers

    lazy var pageControlManager: PageControlManager = {
        let manager: PageControlManager = PageControlManager(with: self.pageControl, andConfig: self.config)
        manager.numberOfPages = self.selectedImages.count
        return manager
    }()
    
    var reverseScrollManager: ReverseScrollManager? {
        willSet {
            if reverseScrollManager != nil {
                self.previousLibraryOffset = reverseScrollManager?.currentOffset
            }
        }
    }
    var previousLibraryOffset: CGPoint?
    
    var loadMoreManager: LoadMoreManager?
    
    let spinToken = "spinner"
    
    var adapters: [ListAdapter] = [ListAdapter]()
    
    /// Delegate property, should be set to whatever object you want to be notified in of the ImagePicker's events and
    /// which is conforming to *FlaneurImagePickerControllerDelegate*
    open var delegate: FlaneurImagePickerControllerDelegate?

    /// Contains all the Image Picker's configurations, you can override those configs by setting their public properties
    /// from inside that object
    open var config: FlaneurImagePickerConfig = FlaneurImagePickerConfig()
    
    var userInfo: Any?
    
    var isChangingSource = false
    
    /// Array of already selected images.
    /// The page control changes if the number of item change.
    /// We also need to retrieve the adapter to refresh the UI
    var selectedImages: [FlaneurImageDescription] = [FlaneurImageDescription]() {
        didSet {
            self.pageControlManager.numberOfPages = selectedImages.count
            
            let adapter = adapterForSection(section: .selectedImages)
            adapter.performUpdates(animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.pageControlManager.currentIndex = self!.selectedImages.count - 1
                self?.pageControlManager.goToPage(page: self!.pageControlManager.currentIndex)
            }

            if selectedImages.count ==  self.config.maxNumberOfSelectedImages {
                self.config.maxNumberOfSelectedImagesReachedClosure(self)
            }
        }
    }

    /// Array of selectable images in the PickerView.
    /// We need to retrieve the adapter to refresh the UI
    var pickerViewImages: [FlaneurImageDescription] = [FlaneurImageDescription]() {
        didSet {
            let adapter = adapterForSection(section: .pickerView)
            if pickerViewImages.count == 0 {
                adapter.reloadData(completion: nil)
            } else {
                adapter.performUpdates(animated: true, completion: nil)
            }
        }
    }
    
    /// Currently used image provider
    var imageProvider: FlaneurImageProvider!
    
    /// Currently selected image source
    var currentImageSource: FlaneurImageSource? {
        didSet {
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let existingSelf = self else { return }
                guard let currentImageSource = existingSelf.currentImageSource else { return }
                existingSelf.reverseScrollManager = nil
                existingSelf.loadMoreManager = nil
                
                switch currentImageSource {
                case .camera:
                    existingSelf.imageProvider = FlaneurImageCameraProvider(delegate: existingSelf, andParentVC: existingSelf)
                case .library:
                    existingSelf.imageProvider = FlaneurImageLibraryProvider(delegate: existingSelf, andConfig: existingSelf.config)
                    DispatchQueue.main.async {
                        self?.setReverseScrollManager()
                    }
                case .instagram:
                    existingSelf.imageProvider = FlaneurImageInstagramProvider(delegate: existingSelf, andParentVC: existingSelf)
                    DispatchQueue.main.async {
                        self?.setLoadMoreManager()
                    }
                }
                
                
                if existingSelf.imageProvider.isAuthorized() {
                    existingSelf.imageProvider.fetchImagesFromSource()
                } else {
                    DispatchQueue.main.async { [weak self] in
                        self!.isChangingSource = false
                        self!.pickerViewImages = []
                    }
                }
            }
        }
    }



    // MARK: - Initializers
    
    /// Init
    ///
    /// - Parameters:
    ///   - maxNumberOfSelectedImages: Maximum number of pickable images
    ///   - userInfo: Arbitrary data
    ///   - sourcesDelegate: Array of image sources, aka: FlaneurImageSource
    ///   - selectedImages: An array of already selected images
    public init(maxNumberOfSelectedImages: Int,
         userInfo: Any?,
         sourcesDelegate: [FlaneurImageSource],
         selectedImages: [FlaneurImageDescription]) {

        if sourcesDelegate.count != 0 {
            self.config.imageSourcesArray = sourcesDelegate
        }
        
        self.selectedImages = selectedImages
        self.userInfo = userInfo
        self.config.maxNumberOfSelectedImages = maxNumberOfSelectedImages
            
        super.init(nibName: nil, bundle: nil)
    }
    
    /// A required init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Lifecyle callbacks
    
    /// viewDidLoad Lifecyle callback
    override public func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        
        createNavigationBar()
        createCollectionViews()
        createAdapters()
        
        searchFirstSource: for imageSource in config.imageSourcesArray {
            if imageSource != .camera {
                self.currentImageSource = imageSource
                break searchFirstSource
            }
        }

    }
    
    /// viewDidLayoutSubviews Lifecyle callback
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutNavigationBar()
        layoutCollectionViews()
    }
    
    // MARK: - Create Views
    
    func createNavigationBar() {
        let cancelButtonClosure: ActionKitBarButtonItemClosure = { [weak self] sender in
            self?.cancelButtonTouched()
        }
        let doneButtonClosure: ActionKitBarButtonItemClosure = { [weak self] sender in
            self?.doneButtonTouched()
        }
        
        self.navigationBar = FlaneurImagePickerNavigationBar(with: config,
                                                             cancelButtonClosure: cancelButtonClosure,
                                                             doneButtonClosure: doneButtonClosure)
        view.addSubview(navigationBar)
    }
    
    func createCollectionViews() {
        for section in config.sectionsOrderArray {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            
            collectionView.backgroundColor = config.backgroundColorForSection?[section] ?? .black
            
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.alwaysBounceVertical = false
            collectionView.alwaysBounceHorizontal = false
            
            switch section {
            case .selectedImages:
                collectionView.isPagingEnabled = true
                pageControlManager.collectionView = collectionView
                
            case .pickerView:
                collectionView.alwaysBounceVertical = true
                collectionView.setCollectionViewLayout(ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: true)
                    , animated: false)
            default:
                break
            }
            
            collectionViews.append(collectionView)
            view.addSubview(collectionView)
        }
        view.addSubview(pageControl)
    }
    
    // MARK: - Create Adapters
    
    func createAdapters() {
        for _ in 0..<collectionViews.count {
            let listAdapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
            
            adapters.append(listAdapter)
        }
        
        for i in 0..<collectionViews.count {
            if config.sectionsOrderArray[i] == .selectedImages {
                adapters[i].collectionViewDelegate = pageControlManager
            }
            adapters[i].dataSource = self
            adapters[i].collectionView = collectionViews[i]
        }
    }
    
    // MARK: - Layout Functions
    
    func layoutNavigationBar() {
        navigationBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 64)
    }
    
    func layoutCollectionViews() {
        for i in 0..<collectionViews.count {
            let collectionView = collectionViews[i]
            let currentSection = config.sectionsOrderArray[i]
            
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            collectionView.heightAnchor.constraint(equalToConstant: CGFloat(config.heightForSection[currentSection]!)).isActive = true
            
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            if i == 0 {
                collectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
            } else {
                collectionView.topAnchor.constraint(equalTo: collectionViews[i - 1].bottomAnchor).isActive = true
            }
            if currentSection == .selectedImages {
                pageControl.translatesAutoresizingMaskIntoConstraints = false
                pageControl.widthAnchor.constraint(equalTo: collectionView.widthAnchor).isActive = true
                pageControl.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
                pageControl.leftAnchor.constraint(equalTo: collectionView.leftAnchor).isActive = true
            }
        }
    }

    
    // MARK: - Button Touched
    
    func doneButtonTouched() {
        delegate?.didPickImages(images: selectedImages, userInfo: userInfo)
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonTouched() {
        self.delegate?.didCancelPickingImages()
        self.dismiss(animated: true, completion: nil)
    }
    
}


// MARK: Helpers

extension FlaneurImagePickerController {
   
    internal func adapterForSection(section: FlaneurImagePickerSection) -> ListAdapter {
        guard let sectionIndex = config.sectionsOrderArray.index(of: section),
            sectionIndex < adapters.count else {
            fatalError("Could not find adapter for section")
        }
        return adapters[sectionIndex]
     }
    
    internal func imageSourceForText(text: String) -> FlaneurImageSource {
        var flaneurImageSource = config.titleForImageSource?.filter { $0.1 == text }.map { return $0.0}
        
        if flaneurImageSource != nil {
           return flaneurImageSource![0]
        }
        
        flaneurImageSource = config.imageSourcesArray.filter { $0.rawValue == text }
    
        if flaneurImageSource != nil {
            return flaneurImageSource![0]
        } else {
            fatalError("No source for text: \(text)")
        }
    }
    
    internal func addImageToSelection(imageDescription: FlaneurImageDescription) {
        guard self.selectedImages.count < self.config.maxNumberOfSelectedImages else {
            return
        }
        if !self.selectedImages.contains(imageDescription) {
            self.selectedImages.append(imageDescription)
        }
    }
    
    internal func deleteImageFromSelection(withHashValue hashValue: Int) {
        self.selectedImages = self.selectedImages.filter { $0.hashValue != hashValue }
    }

    internal func switchToSource(withName name: String) {
        let source = imageSourceForText(text: name)
        if source != self.currentImageSource || source == .camera {
            self.showChangingSourceSpinner(forSource: source)
            self.currentImageSource = source
        }
    }
    
    internal func showAuthorisationSettinsPopup() {
        let alert = UIAlertController(title: NSLocalizedString("Authorization", comment: ""),
                                      message: NSLocalizedString("You need to authorize the source in order to pick the photos", comment: ""),
                                      preferredStyle: UIAlertControllerStyle.alert)
        let settingsAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default) { (_) -> Void in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    internal func setReverseScrollManager() {
        reverseScrollManager = ReverseScrollManager()
        reverseScrollManager?.currentOffset = previousLibraryOffset
        let adapter = adapterForSection(section: .pickerView)
        
        adapter.collectionViewDelegate = reverseScrollManager
        reverseScrollManager?.collectionView = adapter.collectionView
    }
    
    internal func setLoadMoreManager() {
        loadMoreManager = LoadMoreManager()
        let adapter = adapterForSection(section: .pickerView)
        
        adapter.collectionViewDelegate = loadMoreManager
        loadMoreManager?.adapter = adapter
        loadMoreManager?.collectionView = adapter.collectionView
        loadMoreManager?.loadMoreClosure = { [weak self] in
            self?.imageProvider?.fetchNextPage()
        }
    }
    
    internal func spinnerSectionController() -> ListSingleSectionController {
        let configureBlock = { (item: Any, cell: UICollectionViewCell) in
            guard let cell = cell as? SpinnerCell else { return }
            cell.activityIndicator.startAnimating()
        }
        
        let sizeBlock = { (item: Any, context: ListCollectionContext?) -> CGSize in
            guard let context = context else { return .zero }
            if self.isChangingSource {
                self.isChangingSource = false
                return CGSize(width: context.containerSize.width, height: context.containerSize.height)
            }
            return CGSize(width: context.containerSize.width, height: 100)
        }
        
        return ListSingleSectionController(cellClass: SpinnerCell.self,
                                           configureBlock: configureBlock,
                                           sizeBlock: sizeBlock)
    }
    
    internal func showChangingSourceSpinner(forSource source: FlaneurImageSource) {
        guard source != .camera else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self!.isChangingSource = true
            self!.pickerViewImages = []
        }
    }
}


// MARK: - ListAdapterDataSource

extension FlaneurImagePickerController: ListAdapterDataSource {

    /// A DataSource method used to feed the collection with data for a
    /// particular list adapter
    ///
    /// - Parameter listAdapter: The adapter asking for the data
    /// - Returns: An array of *ListDiffable* data
    public func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let index = adapters.index(of: listAdapter) else {
            fatalError("Could not find section for adapter")
        }
        let section = config.sectionsOrderArray[index]
        
        switch section {
        case .selectedImages:
            return selectedImages
        case .imageSources:
            return self.config.imageSourcesArray.map { $0.rawValue } as [ListDiffable]
        case .pickerView:
            var objects = pickerViewImages as [ListDiffable]
            if let loadMoreManager = self.loadMoreManager, loadMoreManager.isLoading == true {
                objects.append(spinToken as ListDiffable)
            }
            if objects.count == 0 && isChangingSource == true {
                objects.append(spinToken as ListDiffable)
            }
            return objects
        }
    }

    /// A DataSource method used to associate a section controller
    /// to object of an adapter
    ///
    /// - Parameters:
    ///   - listAdapter: The adapter asking for the section controller
    ///   - object: The current object to be associated with a section controller
    /// - Returns: The section controller for the object
    public func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        guard let index = adapters.index(of: listAdapter) else {
            fatalError("Could not find section for adapter")
        }
        
        switch config.sectionsOrderArray[index] {
        case .selectedImages:
            let removeButtonClosure: ActionKitControlClosure = { [weak self] sender in
                self?.deleteImageFromSelection(withHashValue: (sender as! UIButton).tag)
            }
            
            return SelectedImagesViewerSectionController(with: config, andRemoveButtonClosure: removeButtonClosure)
            
        case .imageSources:
            let buttonTouchedClosure: ActionKitControlClosure = { [weak self] sender in
                self?.switchToSource(withName: (sender as! UIButton).titleLabel!.text!)
            }
            
            return ImageSourcesSectionController(with: config, andButtonClosure: buttonTouchedClosure)
            
        case .pickerView:
            if object is String {
                return spinnerSectionController()
            }
            let onImageSelectionClosure: ImageSelectionClosure = { [weak self] imageDescription in
                self?.addImageToSelection(imageDescription: imageDescription)
            }
            
            return PickerSectionController(with: config, andImageSelectedClosure: onImageSelectionClosure)
        }
    }
    
    ///  A DataSource method used to show an empty view in the collection
    ///  when data for an adapter are empty
    ///
    /// - Parameter listAapter: The adapter asking for the empty view
    /// - Returns: A custom empty view of type UIView
    public func emptyView(for listAdapter: ListAdapter) -> UIView? {
        guard let index = adapters.index(of: listAdapter) else {
            fatalError("Could not find section for adapter")
        }
        let section = config.sectionsOrderArray[index]
        if currentImageSource == nil || section != .pickerView || imageProvider.isAuthorized() {
            return nil
        }
        
        let authorizeClosure: ActionKitVoidClosure = { [weak self] in
            self?.imageProvider.askForPermission { [weak self] isPermissionGiven in
                if isPermissionGiven {
                    self?.imageProvider.fetchImagesFromSource()
                } else {
                    self?.showAuthorisationSettinsPopup()
                }
            }
        }
        let sourceName = config.titleForImageSource?[currentImageSource!] ?? currentImageSource!.rawValue
        
        if let customViewClass = config.authorizationViewCustomClass, let validClass = customViewClass.self as? FlaneurAuthorizationView.Type {
            return validClass.init(withSourceName: sourceName, authorizeClosure: authorizeClosure) as? UIView
        } else {
            return FlaneurAuthorizationDefaultView(withSourceName: sourceName, authorizeClosure: authorizeClosure)
        }
    }
}

// MARK: - FlaneurImageProviderDelegate

extension FlaneurImagePickerController: FlaneurImageProviderDelegate {
    func didLoadImages(images: [FlaneurImageDescription]) {
        DispatchQueue.main.async {
            if self.currentImageSource! == .camera {
                self.addImageToSelection(imageDescription: images[0])
            } else {
                if let loadMoreManager = self.loadMoreManager, loadMoreManager.isLoading == true {
                    loadMoreManager.isLoading = false
                    loadMoreManager.hasNoMoreToLoad = images.count == 0 ? true : false
                    self.pickerViewImages += images
                } else {
                    self.pickerViewImages = images
                }
            }
        }
    }
    
    func didFailLoadingImages(with unauthorizedSourcePermission: FlaneurImageSource) {
        let title = NSLocalizedString("Error", comment: "")
        var message = ""
        
        self.pickerViewImages = []

        if unauthorizedSourcePermission == .camera {
            message = NSLocalizedString("Camera is not accessible on the device", comment: "")
        } else if unauthorizedSourcePermission == .instagram {
            message = NSLocalizedString("Check your internet connection", comment: "")
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

        self.present(alert, animated: true, completion: nil)
    }
}
