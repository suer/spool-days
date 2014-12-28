import UIKit

class ModalViewController {
    private let baseController: UIViewController

    init(baseController: UIViewController) {
        self.baseController = baseController
    }

    func presentModalViewController(controller: UIViewController) {
        let navigationController = UINavigationController(rootViewController: controller)
        baseController.navigationController?.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        baseController.presentViewController(navigationController, animated: true, completion: nil)
    }
}