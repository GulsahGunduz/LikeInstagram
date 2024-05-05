

import UIKit
import Firebase

class SettingsVC: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func LogoutClicked(_ sender: Any) {

        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toVC", sender: nil)
        }catch{
            print("Error")
        }

    }
    
   

}
