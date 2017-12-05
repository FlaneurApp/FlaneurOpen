//
//  SegmentedControlHeaderCollectionReusableView.swift
//  FlaneurOpen
//
//  Created by Mickaël Floc'hlay on 12/10/2017.
//

import UIKit

struct SegmentedCollectionItemControl {
    let title: String
}

extension SegmentedCollectionItemControl: Equatable {
    static func == (lhs: SegmentedCollectionItemControl, rhs: SegmentedCollectionItemControl) -> Bool {
        return lhs.title == rhs.title
    }
}

protocol SegmentedControlHeaderDelegate {
    func segmentedControlHeaderDidSelectItemAt(_ index: Int)
}

class SegmentedControlHeaderCollectionReusableView: UICollectionReusableView {
    internal var delegate: SegmentedControlHeaderDelegate?
    var buttonsStackView: UIStackView!
    var items: [SegmentedCollectionItemControl] = []

    public override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        didLoad()
    }

    func didLoad() {
        self.backgroundColor = .white

        buttonsStackView = UIStackView(frame: .zero)
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.alignment = .fill
        buttonsStackView.spacing = 0.0
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(buttonsStackView)
        _ = LayoutBorderManager.init(item: buttonsStackView,
                                     toItem: self,
                                     top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }

    internal func configure(items: [SegmentedCollectionItemControl], selectedIndex: Int) {
        self.items = items

        // Remove the existing subviews
        while buttonsStackView.arrangedSubviews.count > 0 {
            let firstView = buttonsStackView.arrangedSubviews[0]
            buttonsStackView.removeArrangedSubview(firstView)
            firstView.removeFromSuperview()
        }

        // Add the new ones
        let arrangedSubviews: [BorderedButton] = items.flatMap { viewForItem($0) }
        for (index, arrangedSubview) in arrangedSubviews.enumerated() {
            buttonsStackView.addArrangedSubview(arrangedSubview)
            arrangedSubview.isSelected = (index == selectedIndex)
        }
    }

    func viewForItem(_ item: SegmentedCollectionItemControl) -> BorderedButton {
        let newButton = BorderedButton(item: item)
        newButton.setTitle(item.title, for: .normal)
        newButton.setTitleColor(UIColor(white: (144.0/255.0), alpha: 1.0), for: .normal)
        newButton.setTitleColor(.black, for: .selected)
        newButton.bottomBorderView = newButton.createBottomBorder(width: 3.0, color: .white)

        newButton.titleLabel?.numberOfLines = 2
        newButton.titleLabel?.textAlignment = .center
        newButton.titleLabel?.font = FlaneurOpenThemeManager.shared.theme.segmentedSelectedControlFont

        newButton.addTarget(self, action: #selector(itemControlPressed), for: .touchUpInside)

        return newButton
    }

    @objc func itemControlPressed(sender: UIButton) {
        guard let borderedButton = sender as? BorderedButton else { return }

        borderedButton.isSelected = true

        buttonsStackView.arrangedSubviews
            .filter { $0 != sender }
            .forEach { view in
                guard let myButton = view as? BorderedButton else { return }
                myButton.isSelected = false
        }

        if let itemIndex = items.index(of: borderedButton.item) {
            delegate?.segmentedControlHeaderDidSelectItemAt(itemIndex)
        }
    }
}

class BorderedButton: UIButton {
    var bottomBorderView: UIView?
    let item: SegmentedCollectionItemControl

    convenience init(item: SegmentedCollectionItemControl) {
        self.init(frame: .zero, item: item)
    }

    init(frame: CGRect, item: SegmentedCollectionItemControl) {
        self.item = item
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set(newValue) {
            super.isSelected = newValue
            bottomBorderView?.backgroundColor = newValue ? .black : .white
            self.titleLabel?.font = newValue ? FlaneurOpenThemeManager.shared.theme.segmentedSelectedControlFont : FlaneurOpenThemeManager.shared.theme.segmentedDeselectedControlFont
        }
    }
}
