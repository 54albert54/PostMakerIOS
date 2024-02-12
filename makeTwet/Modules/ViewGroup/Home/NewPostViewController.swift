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
import FirebaseStorage

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
        uploadPhotoFirebase()
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
    private func uploadPhotoFirebase(){
        //1. verificar imagen
        guard let imageSaved = previwImagenView.image,
        //2. Comprimir imagen y pasarla al formato jpeg
        let imageSaveData:Data = imageSaved.jpegData(compressionQuality: 0.1) else {
            return
        }
        //3. Demostrar carga
        SVProgressHUD.show()
        //4. Configuracion Datos Firebase
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType =  "image/jpg"
        //5. Crear referencia fireBase
        let storage = Storage.storage()
        //6. Crear nombre para la imagen
        let imageName = Int.random(in: 100...1000)
        //7. Referencia ala carpeta donde se guardara la foto
        let folderRefence = storage.reference(withPath: "Photos-Post/\(imageName).jpg")
        //8. subir foto a Firebase
            // 8.1 DispatchQueue.global(qos: DispatchQoS.QoSClass.background) es para pasar la tarea para segundo planta
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            folderRefence.putData(imageSaveData, metadata: metaDataConfig) { (metaData: StorageMetadata?, error:Error? ) in
                //8.2 DispatchQueue.main.async  volver los resultados al hilo principar
                DispatchQueue.main.async {
                    //8.3 Detener carga
                    SVProgressHUD.dismiss()
                    //9 manejar resultados
                    if let error = error {
                        NotificationBanner(title: "Error",subtitle: "Error al Guardar la foto",style: BannerStyle.warning).show()
                        return
                    }
                    //9.1  obtener URL de la foto
                    folderRefence.downloadURL{(url: URL?,error: Error?  ) in
                        let img = url?.absoluteString ?? "no Photo "
                        //10. salvar en la base de datos con foto
                        self.createNewPost(imageUrl: img)
                    }
                    
                }
            }
        }
    }
    
    
    
    
    private func createNewPost(imageUrl: String?){
        //1. optener informacion de los campos
        guard let title = titlePost.text, !title.isEmpty else {
            //1.1 noticicar error
            NotificationBanner(title: "Error",subtitle: "Debes agregar Title",style: BannerStyle.warning).show()
            return
        }
        guard let postField = newPostField.text, !postField.isEmpty else {
            NotificationBanner(title: "Error",subtitle: "Debes agregar Something",style: BannerStyle.warning).show()
            return
        }
        SVProgressHUD.show()
        let img = imageUrl ?? "-"
        let request = CreatePostModel(title: title, detail: postField , img: img)
       
        // import Simple_Networking -> packege de crear peticiones a api
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
                self.navigationController?.popViewController(animated: true) // -> ir ala pagina anterior
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


