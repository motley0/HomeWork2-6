import UIKit

protocol ColorEditorViewControllerDelegate {
    func editBackgroundColor(color: UIColor?)
}

class ColorResultViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let colorEditorVC = segue.destination as! ColorEditorViewController
        colorEditorVC.viewColor = view.backgroundColor
        colorEditorVC.delegate = self
    }
    
    @IBAction func pressedEditColor(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "colorEditorController", sender: nil)
    }

}

extension ColorResultViewController: ColorEditorViewControllerDelegate {
    func editBackgroundColor(color: UIColor?) {
        view.backgroundColor = color
    }
}

