import UIKit

class ModalViewController {
    fileprivate let baseController: UIViewController

    init(baseController: UIViewController) {
        self.baseController = baseController
    }

    func presentModalViewController(_ controller: UIViewController, _ initialDetent: UISheetPresentationController.Detent.Identifier = .medium) {
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.setupStyle()
        navigationController.modalPresentationStyle = .pageSheet
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.selectedDetentIdentifier = initialDetent
        }
        baseController.navigationController?.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        baseController.present(navigationController, animated: true, completion: nil)
    }
}
