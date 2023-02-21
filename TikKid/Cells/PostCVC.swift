//
//  PostCVC.swift
//  TikKid
//
//  Created by krunal on 04/02/23.
//

import UIKit

class PostCVC: UICollectionViewCell {

    @IBOutlet weak var bgImgV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImgV: UIImageView!
    var videosInfo: VideoModel!
    var userInfo: UserModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImgV.layer.cornerRadius = 8.0
        profileImgV.clipsToBounds = true
        self.layer.cornerRadius = 8.0
    }

}
