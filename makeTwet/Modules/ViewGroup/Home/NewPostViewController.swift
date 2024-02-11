//
//  NewPostViewController.swift
//  makeTwet
//
//  Created by Angel alberto Bernechea on 2/10/24.
//

import UIKit
import NotificationBannerSwift
import SVProgressHUD
import Simple_Networking

class NewPostViewController: UIViewController {

    @IBOutlet weak var newPostField: UITextView!
    
    @IBOutlet weak var titlePost: UITextField!
    let homeView = HomeViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //
    }
    
    @IBAction func saveNewPost() {
        createNewPost()
        
      // dismiss(animated: true, completion: nil) // cerrar ventana
    }
    func createNewPost(){
        guard let title = titlePost.text, !title.isEmpty else {
            NotificationBanner(title: "Error",subtitle: "Debes agregar Title",style: BannerStyle.warning).show()
            return
        }
        guard let postField = newPostField.text, !postField.isEmpty else {
            NotificationBanner(title: "Error",subtitle: "Debes agregar Something",style: BannerStyle.warning).show()
            return
        }
        SVProgressHUD.show()
        let img = "-"
        let request = CreatePostModel(title: title, detail: postField , img: img)
        //CreatePostModelResponse URL:EndPoin
        print(request)
        SN.post(endpoint: EndPoin.postUrl, model: request) { (response: SNResult<CreatePostModelResponse>) in
            switch response {
            case .error(let error):
                print(" este es mi error \(error)")
                NotificationBanner(subtitle: "Error post can't be saved ",style: BannerStyle.danger).show()
                    SVProgressHUD.dismiss()
                    
                
                print(error)
              
            case .success:
                NotificationBanner(subtitle: "New post created",style: BannerStyle.success).show()
                self.newPostField.text =  ""
                self.titlePost.text = ""
                
                // pasar a la app
                SVProgressHUD.dismiss()
                
                
                
                
            }
        }
        
        
    }
    
   

    
    
    
}
