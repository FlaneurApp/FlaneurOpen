import Quick
import Nimble
import Nimble_Snapshots
import UIKit
import FlaneurOpen

class FlaneurMapViewSpec: QuickSpec {
    override func spec() {
        describe("in some context") {
            var vc: UIViewController? = nil

            beforeEach {
                let window = UIWindow(frame: CGRect(x: 0.0, y: 0.0, width: 375.0, height: 667.0))
                vc = UIViewController()
                window.rootViewController = vc

                guard let tmpView = vc?.view else {
                    fatalError("vc without a view")
                }

                let mapView = FlaneurMapView()
                tmpView.addSubview(mapView)
                mapView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    mapView.leftAnchor.constraint(equalTo: tmpView.leftAnchor),
                    mapView.rightAnchor.constraint(equalTo: tmpView.rightAnchor),
                    mapView.topAnchor.constraint(equalTo: tmpView.topAnchor),
                    mapView.bottomAnchor.constraint(equalTo: tmpView.bottomAnchor),
                    ])
                window.makeKeyAndVisible()
            }

            it("has valid snapshot") {
                waitUntil(timeout: 10.0) { done in
                    DispatchQueue.global().async {
                        Thread.sleep(forTimeInterval: 5.0)
                        DispatchQueue.main.sync {
                            guard let view = vc?.view else {
                                return fail("No view")
                            }
                            // 📷(view)
                            expect(view).to(haveValidSnapshot())
                        }
                        done()
                    }
                }
            }
        }
    }
}
