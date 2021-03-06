# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Unreleased

* Constrained `FlaneurMapViewDelegate` and `FlaneurCollectionViewDelegate` to be `AnyObject` so that delegate references can be made weak to avoid memory leaks.
* Upgraded form components to be compatible with FlaneurImagePicker 1.0
* Documented classes around the `FlaneurFormView` component.
* Made FlaneurFormImagePickerElementCollectionViewCell public.
* Added `reloadItems` to `FlaneurCollectionView`.

## [0.10.0] - 2018-03-12

* Added `dismissSearchBar` in `FlaneurSearchViewController` so that the search bar can be dismissed without the need of another view controller being presented
* Refactored/renamed `ProgressModalViewController` so that it is easier to implement
* Added a cancel button to `ProgressModalViewController`

## [0.9.0] - 2018-02-20

* Added `segmentedCollectionView(_:willDisplayHeader:)` to `SegmentedCollectionViewDelegate`
* Improved documentation of `SegmentedCollectionViewDelegate`
* Added `FlaneurSearchViewController` and the associated demo
* Added `KeyboardObserver` to delegate keyboard notification observations
* Added `initials` extension to `String`
* Started ignoring Pods in repository (because GoogleMaps is unmanageable and diffs were getting too hard to read)
* `FlaneurMapView` updates:
    * Updated the `FlaneurMapView` demo to make it simpler
    * Made code simpler and improved documentation
* Added some sample code for screenshot testing

## [0.8.0] - 2018-02-05

* Created `MultiSelectDelegate` and `MultiSelectCollectionViewController` based on [objc.io's Generic Table View Controllers](https://talk.objc.io/episodes/S01E26-generic-table-view-controllers-part-2)
* Added `ItemsViewController` based on the same source as above
* Made selectDelegate an optional in `FlaneurFormSelectElementCollectionViewCell`
* Fixed cell selection management in FlaneurFormSelectElementCollectionViewCell #24
* Changed design of form cells so that they don't use conditional/forced casts so much
* Added code to create snapshots of a `MKMapView`
* Added default values for MapKit types
* Added code to render a grayscale version of a `UIImage`

## [0.7.0] - 2018-01-18

* Upgraded `FlaneurImagePicker` to version 0.5.0
* Gross implementation of a new form element type (`button`) which proves that the
  form tools should be moved and redesigned to a dedicated pod
* Fixed size of navigation bar button
* Added logo for iPhone app
* Added the option to hide the navigation bar bottom border
* Fixed bug of the image picker left button so that `localizedStringForCancelAction` is used
* Added some code specific for FlaneurApp... not ideal but we'll fix it later... I hope...

## [0.6.0] - 2017-12-05

* Swift 4

## [0.5.0] - 2017-12-05

* Updated `FlaneurImagePicker` to 0.3.0 version.
* Added functions to `SegmentedCollectionViewDelegate` for more customization of the view appearance, including default implementations for `NSObject` implementations:
    - the number of columns
    - the height of the header view
    - the vertical padding for items
    - the height for items

## [0.4.0] - 2017-11-20

### Added

* `FlaneurCollectionViewDelegate` now supports deselection of cells and filters #9 & #10
* All `FlaneurCollectionViewDelegate` functions are now optional for `UIViewController` instances
  that benefit from a default implementation
* Added `userInfo` to `FlaneurCollectionFilter` #11
* Added `LayoutBorderManager`: a `NSLayoutConstraint` helper #14
* Added `FlaneurModalProgressViewController` #23
* Added the option to toggle or deselect right buttons in `FlaneurNavigationBar` #18
* Added the option to use a custom view for the left part of the navigation bar. #17
* Added `SegmentedCollectionView` #23
* Added `FlaneurOpenThemeManager` to change fonts easily without exposing everything

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
* Fixed bug where `FlaneurCollectionView` was not updating items #22
* Extend size of right actions buttons and bring title closer to left container
* Add sender to FlaneurNavigationBar actions

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

[0.10.0]: https://github.com/FlaneurApp/FlaneurOpen/compare/0.9.0...0.10.0
[0.9.0]: https://github.com/FlaneurApp/FlaneurOpen/compare/0.8.0...0.9.0
[0.8.0]: https://github.com/FlaneurApp/FlaneurOpen/compare/0.7.0...0.8.0
[0.7.0]: https://github.com/FlaneurApp/FlaneurOpen/compare/0.6.0...0.7.0
[0.6.0]: https://github.com/FlaneurApp/FlaneurOpen/compare/0.5.0...0.6.0
[0.5.0]: https://github.com/FlaneurApp/FlaneurOpen/compare/0.4.0...0.5.0
[0.4.0]: https://github.com/FlaneurApp/FlaneurOpen/compare/0.3.0...0.4.0
[0.3.0]: https://github.com/FlaneurApp/FlaneurOpen/compare/0.2.1...0.3.0
[0.2.1]: https://github.com/FlaneurApp/FlaneurOpen/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/FlaneurApp/FlaneurOpen/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/FlaneurApp/FlaneurOpen/compare/eae87872a45ee1e08a8f83de55756634c59fb4f9...v0.1.1
