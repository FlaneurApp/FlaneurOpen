import UIKit

public protocol ProgressModalViewControllerDelegate: AnyObject {
    func progressModalViewControllerWillStartObservingProgress(_ viewController: ProgressModalViewController)
    func progressModalViewControllerDidComplete(_ viewController: ProgressModalViewController)

    func progressModalViewControllerDidAppear(_ viewController: ProgressModalViewController)
    func progressModalViewControllerDidDisappear(_ viewController: ProgressModalViewController)

    func progressModalViewControllerDidCancel(_ viewController: ProgressModalViewController)
}

extension ProgressModalViewControllerDelegate where Self: NSObject {
    func progressModalViewControllerWillStartObservingProgress(_ viewController: ProgressModalViewController) {
        ()
    }

    func progressModalViewControllerDidComplete(_ viewController: ProgressModalViewController) {
        ()
    }

    func progressModalViewControllerDidAppear(_ viewController: ProgressModalViewController) {
        ()
    }

    func progressModalViewControllerDidDisappear(_ viewController: ProgressModalViewController) {
        ()
    }

    func progressModalViewControllerDidCancel(_ viewController: ProgressModalViewController) {
        ()
    }
}

/// A progress view controller that is intended to be presented modally over an existing
/// view controller
final public class ProgressModalViewController: UIViewController {
    /// The top padding of the popup.
    public var topPadding: CGFloat = 0.0

    /// The title of the modal view.
    public let titleLabel = UILabel()

    /// The body of the modal view.
    public let bodyLabel = UILabel()

    /// The cancel button
    public let cancelButton = UIButton(type: .custom)

    /// The progress indicator view of the modal view.
    public let progressBar = UIProgressView(progressViewStyle: .default)

    private var finalStateReached: Bool = false

    /// The delegate of the modal view controller.
    public weak var delegate: ProgressModalViewControllerDelegate?

    private var observation: NSKeyValueObservation?

    deinit {
        #if DEBUG
            debugPrint("Deiniting ProgressModalViewController")
        #endif
    }

    private func stylePopup(_ v: UIView) {
        v.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
    }

    private func styleBody(_ l: UILabel) {
        l.textColor = .white
        l.numberOfLines = 2
        l.textAlignment = .center
    }

    private func styleTitle(_ l: UILabel) {
        l.textColor = .white
        l.numberOfLines = 1
        l.textAlignment = .center
    }

    private func styleCancelButton(_ b: UIButton) {
        b.backgroundColor = .black
        b.setTitleColor(.white, for: .normal)
        b.setTitle("Cancel", for: .normal)
        b.contentEdgeInsets = UIEdgeInsetsMake(8.0, 64.0, 8.0, 64.0)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.isOpaque = false

        let popup = UIView()
        popup.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(popup)

        progressBar.translatesAutoresizingMaskIntoConstraints = false
        popup.addSubview(progressBar)

        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        popup.addSubview(bodyLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        popup.addSubview(titleLabel)

        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        popup.addSubview(cancelButton)

        stylePopup(popup)
        styleBody(bodyLabel)
        styleTitle(titleLabel)
        styleCancelButton(cancelButton)

        cancelButton.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)

        NSLayoutConstraint.activate([
            popup.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: topPadding),
            popup.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            popup.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            popup.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: 0.0),
            progressBar.topAnchor.constraint(equalTo: popup.topAnchor, constant: 0.0),
            progressBar.leadingAnchor.constraint(equalTo: popup.leadingAnchor, constant: 0.0),
            progressBar.trailingAnchor.constraint(equalTo: popup.trailingAnchor, constant: 0.0),
            bodyLabel.leadingAnchor.constraint(equalTo: popup.leadingAnchor, constant: 15.0),
            bodyLabel.trailingAnchor.constraint(equalTo: popup.trailingAnchor, constant: -15.0),
            bodyLabel.centerYAnchor.constraint(equalTo: popup.centerYAnchor),
            titleLabel.topAnchor.constraint(equalTo: popup.topAnchor, constant: 90.0),
            titleLabel.leadingAnchor.constraint(equalTo: popup.leadingAnchor, constant: 45.0),
            titleLabel.trailingAnchor.constraint(equalTo: popup.trailingAnchor, constant: -45.0),
            cancelButton.centerXAnchor.constraint(equalTo: popup.centerXAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: popup.bottomAnchor, constant: -24.0)
            ])
    }

    public override func viewDidAppear(_ animated: Bool) {
        delegate?.progressModalViewControllerDidAppear(self)
        super.viewDidAppear(animated)
    }

    public override func viewDidDisappear(_ animated: Bool) {
        delegate?.progressModalViewControllerDidDisappear(self)
        super.viewDidDisappear(animated)
    }

    public func observeProgress(_ progress: Progress) {
        progressBar.observedProgress = progress
        delegate?.progressModalViewControllerWillStartObservingProgress(self)
        observation = progress.observe(\.fractionCompleted) { [weak self] progress, change in
            self?.progressBar.isHidden = progress.fractionCompleted >= 1.0
            if progress.fractionCompleted >= 1.0 {
                guard let existingSelf = self else { return }
                self?.delegate?.progressModalViewControllerDidComplete(existingSelf)
            }
        }
    }

    @objc func cancelAction(_ sender: Any? = nil) {
        delegate?.progressModalViewControllerDidCancel(self)
    }
}
