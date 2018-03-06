import UIKit
import FlaneurOpen

class DemoProgressModalViewController: UIViewController {
    let backgroundImageView = UIImageView(image: UIImage(named: "radial-gradient"))
    let presentModalButton = UIButton(type: .custom)

    var progress: Progress? = nil
    var startDate: CFTimeInterval? = nil
    var displayLink: CADisplayLink? = nil
    let animationDuration: CFTimeInterval = 3.0
    var progressModalViewController: ProgressModalViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImageView.contentMode = .scaleToFill

        presentModalButton.setTitle("Show modal", for: .normal)
        presentModalButton.setTitleColor(.white, for: .normal)
        presentModalButton.backgroundColor = .black

        presentModalButton.addTarget(self, action: #selector(launchModalAction(_:)), for: .touchUpInside)

        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(presentModalButton)
        presentModalButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
            presentModalButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            presentModalButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }

    func createDisplayLink() {
        progress = Progress(totalUnitCount: Int64(animationDuration * 1000))
        startDate = nil
        let displayLink =  CADisplayLink(target: self, selector: #selector(step(displaylink:)))
        self.displayLink = displayLink
        displayLink.add(to: .current, forMode: .defaultRunLoopMode)
    }

    @objc func step(displaylink: CADisplayLink) {
        if startDate == nil {
            startDate = displaylink.timestamp
        }

        let elapsed: CFTimeInterval = displaylink.timestamp - startDate!
        progress?.completedUnitCount = Int64(elapsed * 1000)
        if elapsed >= animationDuration {
            displaylink.invalidate()
        }
    }

    @IBAction func launchModalAction(_ sender: Any? = nil) {
        self.createDisplayLink()

        let progressModalViewController = ProgressModalViewController()
        self.progressModalViewController = progressModalViewController
        progressModalViewController.topPadding = 0.0 // <- below status bar
        progressModalViewController.modalPresentationStyle = .overCurrentContext
        progressModalViewController.delegate = self

        guard let progress = progress else {
            fatalError("No progress available to observe")
        }

        progressModalViewController.observeProgress(progress)
        self.present(progressModalViewController, animated: true) {
            debugPrint("The progress modal view appeared presentation animation completed.")
        }
    }

    deinit {
        debugPrint("deiniting DemoProgressModalViewController")
    }
}

extension DemoProgressModalViewController: ProgressModalViewControllerDelegate {
    func progressModalViewControllerDidComplete(_ viewController: ProgressModalViewController) {
        debugPrint("ProgressModalViewController is done observing")
        viewController.titleLabel.text = nil
        viewController.bodyLabel.text = "Demo completed"

        DispatchQueue.global().async {
            sleep(1)
            DispatchQueue.main.async {
                viewController.dismiss(animated: true) {
                    self.progressModalViewController = nil
                }
            }
        }
    }

    func progressModalViewControllerWillStartObservingProgress(_ viewController: ProgressModalViewController) {
        debugPrint("ProgressModalViewController will start observing")
        viewController.titleLabel.text = "In progress"
        viewController.bodyLabel.text = "Please wait"
    }

    func progressModalViewControllerDidAppear(_ viewController: ProgressModalViewController) {
        debugPrint("ProgressModalViewController did appear")
    }

    func progressModalViewControllerDidDisappear(_ viewController: ProgressModalViewController) {
        debugPrint("ProgressModalViewController did disappear")
    }

    func progressModalViewControllerDidCancel(_ viewController: ProgressModalViewController) {
        self.displayLink?.invalidate()
        debugPrint("ProgressModalViewController did cancel")
        viewController.titleLabel.text = nil
        viewController.bodyLabel.text = "Demo cancelled"

        DispatchQueue.global().async {
            sleep(1)
            DispatchQueue.main.async {
                viewController.dismiss(animated: true) {
                    self.progressModalViewController = nil
                }
            }
        }
    }
}
