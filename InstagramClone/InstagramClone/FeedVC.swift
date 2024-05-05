
import UIKit
import Firebase
import SDWebImage

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var userEmailArr = [String]()
    var userCommentArr = [String]()
    var likeArr = [Int]()
    var userImageArr = [String]()
    var docIDArr = [String]()

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        getDataFromFirestore()
    }
    
    func getDataFromFirestore(){
        
        let firestore = Firestore.firestore()
        
        firestore.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil{
                // AlertMessage
                
            }else{
                if snapshot?.isEmpty != true{
                    
                    self.userEmailArr.removeAll(keepingCapacity: false)
                    self.userImageArr.removeAll(keepingCapacity: false)
                    self.likeArr.removeAll(keepingCapacity: false)
                    self.userCommentArr.removeAll(keepingCapacity: false)
                    self.docIDArr.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents{
                        
                        let documentID = document.documentID
                        self.docIDArr.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String{
                            self.userEmailArr.append(postedBy)
                        }
                        if let postComment = document.get("postComment") as? String{
                            self.userCommentArr.append(postComment)
                        }
                        if let likes = document.get("likes") as? Int{
                            self.likeArr.append(likes)
                        }
                        if let imageUrl = document.get("imageUrl") as? String{
                            self.userImageArr.append(imageUrl)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userEmailLabel.text = userEmailArr[indexPath.row]
        cell.likeLabel.text = String(likeArr[indexPath.row])
        cell.commentLabel.text = userCommentArr[indexPath.row]
        cell.userImageView.sd_setImage(with: URL(string: self.userEmailArr[indexPath.row]))
        cell.documentIDLabel.text = docIDArr[indexPath.row]
        return cell
    }

}
