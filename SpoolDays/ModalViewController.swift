import UIKit

class ModalViewController {
    fileprivate let baseController: UIViewController

    init(baseController: UIViewController) {
        self.baseController = baseController
    }

    func presentModalViewController(_ controller: UIViewController) {
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        baseController.navigationController?.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        baseController.present(navigationController, animated: true, completion: nil)
    }
}
