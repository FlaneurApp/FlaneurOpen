//
//  LoadingCollectionViewCell.swift
//  Pods
//
//  Created by Mickaël Floc'hlay on 17/05/2017.
//
//

import UIKit

public enum Result<A> {
    case success(A)
    case error(Error?)
}

public extension Result {
    public init(_ value: A?, or error: Error?) {
        if let value = value {
            self = .success(value)
        } else {
            self = .error(error)
        }
    }

    public var value: A? {
        guard case .success(let v) = self else { return nil }
        return v
    }
}

open class LoadingCollectionViewCell: UICollectionViewCell {
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    public init() {
        super.init(frame: .zero)
        configureToInitialLoadingState()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureToInitialLoadingState() {
        for view in self.subviews {
            view.removeFromSuperview()
        }

        self.addSubview(spinner)

        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true

        spinner.startAnimating()
    }

    public func configure<A>(load: (@escaping (Result<A>) -> ()) -> (),
                   build: @escaping (Result<A>) -> UICollectionViewCell) {

        configureToInitialLoadingState()

        load() { [weak self] result in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.add(cell: build(result))
            }
        }
    }

    func add(cell: UICollectionViewCell) {
        self.addSubview(cell)
        cell.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: cell,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: cell,
                               attribute: .leading,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .leading,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: cell,
                               attribute: .trailing,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .trailing,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: cell,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: 0.0)
            ])
    }
}


