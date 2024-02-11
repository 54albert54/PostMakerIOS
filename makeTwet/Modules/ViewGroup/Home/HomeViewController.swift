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
            print("se cambiaran los datos")
            self.tweetsTableView.reloadData()
        }
    }

    @IBOutlet weak var tweetsTableView: UITableView!
    
    
    // tweetsTableView
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stupUI()
        getPostData()
    }
    private func stupUI(){
        SVProgressHUD.show()
        tweetsTableView.dataSource = self
        tweetsTableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    private func getPostData(){
        
        SN.get(endpoint: EndPoin.postUrl){ (response: SNResult<AllPostData>) in
            switch response {
            case .error(let error):
                NotificationBanner(subtitle: "Error User o Password incorrectas",style: BannerStyle.danger).show()
                    SVProgressHUD.dismiss()
                  
                
                print(error)
              
            case .success(let data ):
                let dataPost = data as AllPostData
                
                self.tweetsTableView.reloadData()
                self.postData = dataPost.body

                SVProgressHUD.dismiss()
                
               
            }
        }
    }
}

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
