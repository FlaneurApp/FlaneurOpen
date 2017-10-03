# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Unreleased

### Added

* `FlaneurCollectionViewDelegate` now supports deselection of cells and filters #9 & #10
* All `FlaneurCollectionViewDelegate` functions are now optional for `UIViewController` instances
  that benefit from a default implementation
* Added `userInfo` to `FlaneurCollectionFilter` #11
* Added `LayoutBorderManager`: a `NSLayoutConstraint` helper #14

### Changed

* Made the right buttons of a `FlaneurNavigationBar` configurable dynamically #7
* Made `nbColumns` and `cellRatio` customizable for FlaneurCollectionView #8
* Made `FlaneurCollectionView`'s collectionView public in readonly
* `FlaneurFilterCollectionViewCell` has been made `public` to allow UIAppearance customization #12
* `FlaneurMapView` replaced `FlaneurMapViewController` #13
* Updated project and dependencies for compatibility with Xcode 9
* Right actions in a `FlaneurNavigationBar` can either be a collection if images or a single text #16
* Right actions in a `FlaneurNavigationBar` are now have public getters for their `UIButton` #16
* Limit the navigation bar left action surface to its title #21

## [0.3.0] - 2017-09-19

### Added

* Completed filter support to the `FlaneurCollectionView` (#5)
* Added `.swift-version` file for cocoapods lib linting

### Changed

* Renamed `FlaneurCollectionContainerView` to `FlaneurCollectionView`
* Renamed `FlaneurDiffable` to `FlaneurCollectionItem`
* Renamed `FlaneurCollectionContainerViewDelegate` to `FlaneurCollectionViewDelegate`
  and the associated signatures.

## [0.2.1] - 2017-09-14

### Changed

* When a left action is set up on a `FlaneurNavigationBar`, touching the bar (with
  the exception of the possible right buttons) actions it (#6)

## [0.2.0] - 2017-09-12

### Added

* Added `FlaneurNavigationBar` (#4)
* Added `FlaneurCollectionContainerView` (#5)
* Added a `UILabel` extension to display text with custom letter spacing

## [0.1.1] - 2017-09-05

### Changed

* Removed dependency of the pod to `IGListKit`
* Changed async image download dependency from `SDWebImage` to `Kingfisher`

## About Older Versions

Older versions of this package were evolving at a really high pace.
The package was not stable enough and maintaining a Changelog would have a real
pain in the b***.

[0.3.0]: https://github.com/FlaneurApp/FlaneurOpen/compare/0.2.1...0.3.0
[0.2.1]: https://github.com/FlaneurApp/FlaneurOpen/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/FlaneurApp/FlaneurOpen/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/FlaneurApp/FlaneurOpen/compare/eae87872a45ee1e08a8f83de55756634c59fb4f9...v0.1.1
