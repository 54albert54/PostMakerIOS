//
//  HomeViewController.swift
//  makeTwet
//
//  Created by Angel alberto Bernechea on 2/9/24.
//

import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBannerSwift
import AVFoundation
import AVKit

class HomeViewController: UIViewController {
    
    private let cellID = "TweetTableViewCell"
    private var postData:[BodyAP] = []
    
    @IBOutlet weak var tweetsTableView: UITableView!
    
    
    // resfresca la pantallas cada vez que de valla renderisar
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getPostData()
        self.tweetsTableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stupUI()
        
    }
    private func stupUI(){
        SVProgressHUD.show()
        tweetsTableView.dataSource = self
        tweetsTableView.delegate = self
        tweetsTableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        
    }
    
    private func getPostData(){
        
        SN.get(endpoint: EndPoin.postUrl){ (response: SNResult<AllPostData>) in
            switch response {
            case .error(let error):
                print(error)
                NotificationBanner(subtitle: "Error User o Password incorrectas",style: BannerStyle.danger).show()
                SVProgressHUD.dismiss()
                
            case .success(let data ):
               let dataPost = data as AllPostData
               self.postData = dataPost.body
                SVProgressHUD.dismiss()
                self.tweetsTableView.reloadData()
                
            }
        }
    }
    private func deletePost(indexPath: IndexPath){
        let postID = self.postData[indexPath.row].id
        let correctRow = EndPoin.postUrl + String(postID)
        SVProgressHUD.show()
        
        SN.delete(endpoint: correctRow) { (response: SNResult<CreatePostModelResponse>) in
            switch response {
            case .error:
                NotificationBanner(subtitle: "Can't Delete a post",style: BannerStyle.danger).show()
                SVProgressHUD.dismiss()
                
            case .success:
                // 1.borrar post del array de estos
                //  self.viewDidAppear(true)
                NotificationBanner(subtitle: "Post Deleted successfuly ",style:
                                    BannerStyle.success).show()
                
                self.postData.remove(at: indexPath.row)
                self.tweetsTableView.deleteRows(at: [indexPath], with: .left)
                SVProgressHUD.dismiss()
            }
        }
    }
}


// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "borrar") { (_ ,_,_ ) in
            //borrar post
            self.deletePost(indexPath: indexPath)
            
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Editar") { (_ ,_,_ ) in
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
        return configuration
    }
    //verificar que sea del mismo usuario para poder borrar
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //obtener datos desde el storage
        let storage = UserAuth()
        let user = storage.getDataStore(.userName)
        return  self.postData[indexPath.row].ownerUser == user
    }
    
}
// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tweetsTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        if let cell = cell as? TweetTableViewCell {
            
            cell.setupCell(infoPost: postData[indexPath.row])
            cell.needsToShowVideo = { url in
                //aqui se deberia de abrir el ViewController
                let  recordedVideoUrlSaved = url
                
            
                //3.1 Create Video
                let avPlayer = AVPlayer(url: recordedVideoUrlSaved)
                //3.2 Controller del video
                let avPlayerController = AVPlayerViewController()
                
                avPlayerController.player = avPlayer
                
                self.present(avPlayerController, animated: true ){
                    //3.3 Que reprodusca video automaticamente
                    avPlayerController.player?.play()
                }
            }
        }
        return cell
    }
}

//MARK: - Navigate
extension HomeViewController {
    // mandar datos de una vista a otra
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //1.verifica el identificador de la segue
        if segue.identifier == "showMapa", let mapViewControler = segue.destination
        //2. se castea con el controlador de la vista
        as? MapaViewController {
            mapViewControler.posts = postData.filter { $0.hasLocation }
            
        }
    }
    
}
