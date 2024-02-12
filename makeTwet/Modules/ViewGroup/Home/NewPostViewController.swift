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

import UniformTypeIdentifiers
import AVFoundation
import AVKit
import MobileCoreServices

class NewPostViewController: UIViewController {
    
    
    @IBOutlet weak var videoButton: UIButton!
    
    
    @IBOutlet weak var newPostField: UITextView!
    
    @IBOutlet weak var titlePost: UITextField!
    
    @IBOutlet weak var previwImagenView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoButton.isHidden = true
        
    }
    
    //MARK: - Close keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    var cameraFile:CameraOption = .empty
    
    @IBAction func saveNewPost() {
        
        switch cameraFile {
        case .empty:
            self.createNewPost(imageUrl: nil, videoUrl: nil)
        case .foto:
            self.uploadPhotoFirebase()
        case .video:
            self.uploadVideoFirebase()
        }
        
    }
    
    @IBAction func abrirCamara() {
        let alert = UIAlertController(title: "Camera", message: "Seleciona video o foto", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Foto", style: .default, handler: { _ in
            self.openCamara()
            self.cameraFile = .foto
        }))
        alert.addAction(UIAlertAction(title: "Video", style: .default, handler: { _ in
            self.openVideoCamara()
            self.cameraFile = .video
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
        
        present(alert, animated: true , completion: nil)
        
        
    }
    
    
    @IBAction func playVideo() {
        guard let recordedVideoUrlSaved = currentVideoUrl else {
            return
        }
        //3.1 Create Video
        let avPlayer = AVPlayer(url: recordedVideoUrlSaved)
        //3.2 Controller del video
        let avPlayerController = AVPlayerViewController()
        
        avPlayerController.player = avPlayer
        
        present(avPlayerController, animated: true ){
            //3.3 Que reprodusca video automaticamente
            avPlayerController.player?.play()
            
        }
        
    }
    
    
    
    
    //MARK: - adjust camara and take Video
    private var currentVideoUrl:URL?
    
    private func openVideoCamara(){
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.mediaTypes = ["public.movie"]
        imagePicker?.cameraFlashMode = .off
        imagePicker?.cameraCaptureMode = .video
        imagePicker?.videoQuality = .typeMedium
        imagePicker?.videoMaximumDuration = TimeInterval(5)
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        
        guard let imagePicker = imagePicker else {
            return
        }
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    //MARK: - adjust camara and take photo
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
    //MARK: - Upload photo to firebase
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
                    if let _ = error {
                        NotificationBanner(title: "Error",subtitle: "Error al Guardar la foto",style: BannerStyle.warning).show()
                        return
                    }
                    //9.1  obtener URL de la foto
                    folderRefence.downloadURL{(url: URL?,error: Error?  ) in
                        let img = url?.absoluteString ?? "no Photo "
                        //10. salvar en la base de datos con foto
                        self.createNewPost(imageUrl: img, videoUrl: nil)
                    }
                }
            }
        }
    }
    
    //MARK: - Upload Video to firebase
    private func uploadVideoFirebase(){
        //1. verificar Video Cuardado
        guard let currentVideoSavedURL = currentVideoUrl,
              //2. Comprimir Video a Data
              let VideoData = try? Data(contentsOf: currentVideoSavedURL)
                
        else {
            return
        }
        //3. Demostrar carga
        SVProgressHUD.show()
        //4. Configuracion Datos Firebase
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType =  "video/mp4"
        //5. Crear referencia fireBase
        let storage = Storage.storage()
        //6. Crear nombre para la imagen
        let videoName = Int.random(in: 100...1000)
        //7. Referencia ala carpeta donde se guardara la foto
        let folderRefence = storage.reference(withPath: "video-Post/\(videoName).mp4")
        //8. subir foto a Firebase
        // 8.1 DispatchQueue.global(qos: DispatchQoS.QoSClass.background) es para pasar la tarea para segundo planta
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            folderRefence.putData(VideoData, metadata: metaDataConfig) { (metaData: StorageMetadata?, error:Error? ) in
                //8.2 DispatchQueue.main.async  volver los resultados al hilo principar
                DispatchQueue.main.async {
                    //8.3 Detener carga
                    SVProgressHUD.dismiss()
                    //9 manejar resultados
                    if let _ = error {
                        NotificationBanner(title: "Error",subtitle: "Error al Guardar la foto",style: BannerStyle.warning).show()
                        return
                    }
                    //9.1  obtener URL de la foto
                    folderRefence.downloadURL{(url: URL?,error: Error?  ) in
                        let video = url?.absoluteString ?? "no Photo "
                        //10. salvar en la base de datos con video
                        self.createNewPost(imageUrl: nil, videoUrl: video)
                    }
                }
            }
        }
    }
    
    
    
    //MARK: - Create info and post to server
    private func createNewPost(imageUrl: String? ,videoUrl:String?){
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
        let video = videoUrl ?? "-"
        let img = imageUrl ?? "-"
        let request = CreatePostModel(title: title, detail: postField , img: img ,videoUrl: video, location:"no locatio"  )
        
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
//MARK: - Camera ajust
extension NewPostViewController :UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //1. pasr ala camara la camara
        imagePicker?.dismiss(animated: true)
        
        //2. Tomar Fotos
        if info.keys.contains(.originalImage){
            // aparecer donde se vera el pre-view de la imagen
            previwImagenView.isHidden = false
            previwImagenView.image = info[.originalImage] as? UIImage
        }
        //3. Capturar Video
        if info.keys.contains(.mediaURL), let  recordedVideoUrl = (info[.mediaURL] as? URL)?.absoluteURL{
            self.videoButton.isHidden = false
            currentVideoUrl = recordedVideoUrl
            
            
        }
    }
}


