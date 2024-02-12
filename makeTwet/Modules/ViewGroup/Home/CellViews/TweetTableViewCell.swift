//
//  TweetTableViewCell.swift
//  makeTwet
//
//  Created by Angel alberto Bernechea on 2/9/24.
//

import UIKit
import Kingfisher

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postUserOwner: UILabel!
    @IBOutlet weak var postImagen: UIImageView!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var avatarImagen: UIImageView!

    @IBOutlet weak var botonVideo: UIButton!
    
    
    var videoUrl:URL?
    
    
    
    @IBAction func play(_ sender: Any) {
        print("por si hay que cambiaron a play")
        guard let urlVideo = videoUrl else {
            return
        }
        needsToShowVideo?(urlVideo)
        
    }
    
    var needsToShowVideo: ((_ url:URL)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImagen.layer.cornerRadius = 35
        postImagen.layer.cornerRadius = 10
      
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCell(infoPost:BodyAP){
    
        let storage = UserAuth()
        let user = storage.getDataStore(.userName)
      
        
        self.postTitle.text = infoPost.title
        self.postUserOwner.text = "@"+infoPost.ownerUser
        
        if infoPost.ownerUser == user{
            let red = CGFloat(0x7A) / 255.0
            let green = CGFloat(0x7A) / 255.0
            let blue = CGFloat(0x7A) / 255.0
            let alpha = CGFloat(0.2) 

            let color = CGColor(red: red, green: green, blue: blue, alpha: alpha)
            cellView.layer.backgroundColor  = color
        }
        if infoPost.videoUrl.count > 25 {
           botonVideo.isHidden = false
            videoUrl = URL(string:infoPost.videoUrl)
        }else{
           botonVideo.isHidden = true
        }
        
        
        
        if infoPost.img.count > 25 {
             let imagen = infoPost.img
             self.postImagen.kf.setImage(with: URL(string: imagen))
            postImagen.layer.isHidden = false
        
            
           
        }else{
            postImagen.layer.isHidden = true
           
        }
    }
    
}
