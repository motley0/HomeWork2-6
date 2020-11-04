import UIKit

class ColorEditorViewController: UIViewController {
    
    @IBOutlet var resultColorView: UIView!
    
    @IBOutlet var redColorValueLabel: UILabel!
    @IBOutlet var greenColorValueLabel: UILabel!
    @IBOutlet var blueColorValueLabel: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redTextField: UITextField!
    @IBOutlet var greenTextField: UITextField!
    @IBOutlet var blueTextField: UITextField!
    
    var viewColor: UIColor!
    var delegate: ColorEditorViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaultValuesForView()
        setupDefaultValuesForSliders()
        setupSliders()
        setupColorValueLabels()
        setupTextFields()
        setupToolBar()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        viewEndEditing()
    }
    
    @IBAction func changeRgbSlider(_ sender: UISlider) {
        let colorValue = toString(number: sender.value)
        refreshColorFields(tag: sender.tag, colorValue: colorValue)
        refreshBackgroundColorForResultColorView()
    }
    
    @IBAction func pressedDone(_ sender: UIButton) {
        delegate.editBackgroundColor(color: resultColorView.backgroundColor)
        dismiss(animated: true)
    }
    
    private func toString(number: Float) -> String {
        String(format: "%.2f", number)
    }
    
}

extension ColorEditorViewController {
    private func refreshColorFields(tag: Int, colorValue: String) {
        switch tag {
        case 0:
            redColorValueLabel.text = colorValue
            redTextField.text = colorValue
        case 1:
            greenColorValueLabel.text = colorValue
            greenTextField.text = colorValue
        case 2:
            blueColorValueLabel.text = colorValue
            blueTextField.text = colorValue
        default:
            break
        }
    }
    
    private func refreshSlidersValue(tag: Int, colorValue: Float) {
        switch tag {
        case 0:
            redSlider.value = colorValue
        case 1:
            greenSlider.value = colorValue
        case 2:
            blueSlider.value = colorValue
        default:
            break
        }
    }
    
    private func refreshBackgroundColorForResultColorView() {
        resultColorView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
    }
}

extension ColorEditorViewController {
    
    private func setupDefaultValuesForView() {
        resultColorView.layer.cornerRadius = 10
        resultColorView.backgroundColor = viewColor
    }
    
    private func setupDefaultValuesForSliders() {
        redSlider.minimumTrackTintColor = .red
        greenSlider.minimumTrackTintColor = .green
        blueSlider.minimumTrackTintColor = .blue
    }
    
    private func setupSliders() {
        let ciColor = CIColor(color: viewColor)
               
        redSlider.value = Float(ciColor.red)
        greenSlider.value = Float(ciColor.green)
        blueSlider.value = Float(ciColor.blue)
    }
    
    private func setupColorValueLabels() {
        redColorValueLabel.text = toString(number: redSlider.value)
        greenColorValueLabel.text = toString(number: greenSlider.value)
        blueColorValueLabel.text = toString(number: blueSlider.value)
    }
    
    private func setupTextFields() {
        redTextField.text = redColorValueLabel.text
        greenTextField.text = greenColorValueLabel.text
        blueTextField.text = blueColorValueLabel.text
        
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self
    }
    
    private func setupToolBar() {
        let toolBar = createToolBar()
        let textFields: [UITextField] = [redTextField, greenTextField, blueTextField]
        for textField in textFields {
            textField.inputAccessoryView = toolBar
        }
    }
    
    private func createToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(viewEndEditing))
        let flexibleSpaceButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        toolBar.setItems([flexibleSpaceButton, doneButton], animated: false)
        
        return toolBar
    }
    
    @objc private func viewEndEditing() {
        view.endEditing(true)
    }
}

extension ColorEditorViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let colorNumber = getColorNumber(textField: textField)

        refreshColorFields(tag: textField.tag,
                           colorValue: toString(number: colorNumber))
        refreshSlidersValue(tag: textField.tag, colorValue: colorNumber)
        refreshBackgroundColorForResultColorView()
    }
    
    private func getColorNumber(textField: UITextField) -> Float {
        if let colorNumber = Float(textField.text ?? ""),
           colorNumber >= 0,
           colorNumber <= 1 {
            return colorNumber
        }
        
        showAlert(title: "Введены некорректные данные",
                  message: "Пожалуйста, введите значение от 0 до 1")
        return 0.0
    }
    
    private func showAlert(title: String,
                   message: String,
                   handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: handler)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

}
