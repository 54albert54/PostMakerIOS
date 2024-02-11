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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCell(infoPost:BodyAP){
        self.postTitle.text = infoPost.title
        self.postUserOwner.text = infoPost.ownerUser
        if infoPost.imagen != "NOT IMAGEN YET"{
             let imagen = infoPost.imagen
             self.postImagen.kf.setImage(with: URL(string: imagen))
        
            
           
        }else{
            self.postImagen.isHidden = true
        }
    }
    
}
