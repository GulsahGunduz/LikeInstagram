

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func SignInClicked(_ sender: Any) {
        
            if emailText.text != "" && passwordText.text != ""{
                Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authData, error in
                    if error != nil{
                        self.AlertMessage(title: "Error", msg: error?.localizedDescription ?? "Error")
                    }else{
                        self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    }
                }
            }else{
                AlertMessage(title: "Error", msg: "Email/Password?")
            }
    }
    
    
    @IBAction func SignUpClicked(_ sender: Any) {
        
            if emailText.text != "" && passwordText.text != ""{
                Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authData, error in
                    if error != nil{
                        self.AlertMessage(title: "Error", msg: error?.localizedDescription ?? "Error")
                    }else{
                        self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    }
                }
            }else{
                AlertMessage(title: "Error", msg: "Email/Password?")
            }
    }
    
    @objc func AlertMessage(title:String, msg:String){
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
  
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   

}

