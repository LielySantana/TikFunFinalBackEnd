//
//  UserCVC.swift
//  TikKid
//
//  Created by krunal on 04/02/23.
//

import UIKit

class UserCVC: UICollectionViewCell {

    @IBOutlet weak var purchaseView: UIVisualEffectView!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ratingView: StarRatingView!
    var userInfo: UserModel!
    var isUnlocked:Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 8.0
    }

}
