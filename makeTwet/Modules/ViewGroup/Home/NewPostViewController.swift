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
   
    @IBOutlet weak var previwImagenView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func saveNewPost() {
        createNewPost()
    }
    
    @IBAction func abrirCamara() {
       openCamara()
        
        
        
    }

    
    //MARK: - Properties
   private var imagePicker: UIImagePickerController?
    
    private func openCamara(){
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.cameraFlashMode = .off
        imagePicker?.cameraCaptureMode = .photo
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        
        guard let imagePicker = imagePicker else {
            return
        }
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    private func createNewPost(){
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
        
        SN.post(endpoint: EndPoin.postUrl, model: request) { (response: SNResult<CreatePostModelResponse>) in
            switch response {
            case .error:
              
                NotificationBanner(subtitle: "Error post can't be saved ",style: BannerStyle.danger).show()
                    SVProgressHUD.dismiss()
            case .success:
                NotificationBanner(subtitle: "New post created",style: BannerStyle.success).show()
                self.newPostField.text =  ""
                self.titlePost.text = ""
                
                // pasar a la app
                SVProgressHUD.dismiss()
                // Home
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension NewPostViewController :UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //pasr ala camara la camara
        imagePicker?.dismiss(animated: true)
        
        if info.keys.contains(.originalImage){
            // aparecer donde se vera el pre-view de la imagen
            previwImagenView.isHidden = false
            previwImagenView.image = info[.originalImage] as? UIImage
        }
    }
}


