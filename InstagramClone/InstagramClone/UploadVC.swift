
import UIKit
import Firebase
import FirebaseStorage

class UploadVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Select Image
        imgView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(SelectImage))
        imgView.addGestureRecognizer(gesture)
    }
    
    @objc func SelectImage(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imgView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func UploadClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let mediaFolder = storageRef.child("Media")
        
        if let imgData = imgView.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            let img = mediaFolder.child("/(uuid).jpg")
            img.putData(imgData, metadata: nil) { metadata, error in
                if error != nil{
                    self.makeAlert(title: "Error", msg: error?.localizedDescription ?? "Error")
                    
                }else{
                    img.downloadURL { url, error in
                        if error == nil{
                            
                            let imgURL = url?.absoluteString
                            
                            // Database
                            let firestore = Firestore.firestore()
                            var firestoreRef : DocumentReference? = nil
                            
                            let firestorePost = ["imageUrl" : imgURL!, "postedBy" : Auth.auth().currentUser?.email! as Any, "postComment" : self.commentText.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0] as [String : Any]
                            
                            firestoreRef = firestore.collection("Posts").addDocument(data: firestorePost) { error in
                                if error != nil{
                                    self.makeAlert(title: "Error", msg: error?.localizedDescription ?? "Error")
                                }else{
                                    // Uploadtakileri sıfırlayıp FeedVCye gitsin
                                    self.imgView.image = UIImage(named: "AddPic.png")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0 // FeedVC
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func makeAlert(title:String, msg:String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
