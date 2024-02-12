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

class HomeViewController: UIViewController {
    
    private let cellID = "TweetTableViewCell"
    private var postData:[BodyAP] = []{
        didSet{
            self.tweetsTableView.reloadData()
        }
    }

    @IBOutlet weak var tweetsTableView: UITableView!
    
    
    // resfresca la pantallas cada vez que de valla renderisar
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getPostData()
        
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
            case .error:
                NotificationBanner(subtitle: "Error User o Password incorrectas",style: BannerStyle.danger).show()
                    SVProgressHUD.dismiss()
  
            case .success(let data ):
                let dataPost = data as AllPostData
                self.tweetsTableView.reloadData()
                self.postData = dataPost.body
                SVProgressHUD.dismiss()
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
                // definir tiempo para borrar elemento
                Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false ){ timer in
                    SVProgressHUD.dismiss()
                    self.postData.remove(at: indexPath.row)
                               
                 }
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
        
        }
        return cell
    }
    
    
}
