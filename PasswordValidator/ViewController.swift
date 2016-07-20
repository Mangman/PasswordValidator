//  Created by Stepan on 18/07/16.

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    var validator: ValidatorProtocol? = nil
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func enterButton(sender: AnyObject) {
        validator?.validate(loginField.text ?? "", password: passwordField.text ?? "")
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        validator = PasswordValidator()
        validator!.output = self
        
        //TODO: написать textFieldController или вроде того
        loginField.delegate    = self
        passwordField.delegate = self
        
        imageView.image = UIImage(named: "ValidatorLogo")
    }
}

extension ViewController: ValidatorOutput {
    ///Получает результат проверки пароля и текст ошибки, если она не прошла
    func didObtainPasswordValidationResult (result: Bool, errorMsg: String?) {
        errorLabel.textAlignment = NSTextAlignment.Center
        
        if result == false {
            errorLabel.textColor = UIColor (colorLiteralRed: 255, green: 0, blue: 0, alpha: 255)
            errorLabel.text = errorMsg
        }
        else {
            errorLabel.textColor = UIColor (colorLiteralRed: 0, green: 0, blue: 0 , alpha: 255)
            errorLabel.text = "password is fine"
        }
    }
}

//MARK: TextFieldDelegate Methoods
extension ViewController {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if loginField.isFirstResponder() {
        textField.resignFirstResponder()
        passwordField.becomeFirstResponder()
        return true
        }
        else {
            textField.resignFirstResponder()
            return true
        }
    }
}

