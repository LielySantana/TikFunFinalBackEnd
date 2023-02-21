//
//  DashboardVC.swift
//  TikKid
//
//  Created by krunal on 31/01/23.
//

import UIKit
import StoreKit

class DashboardVC: UIViewController {
    
    @IBOutlet weak var pointsLbl: UILabel!

    @IBOutlet weak var pointsV: UIView!
    let titleArr = ["DANCE","GAMES","ART","NATURE","TOYS","LEARN"]
    let colorArr:[UIColor] = [UIColor(red: 91.0/255.0, green: 114.0/255.0, blue: 206.0/255.0, alpha: 1.0),
                              UIColor(red: 91.0/255.0, green: 206.0/255.0, blue:137.0/255.0, alpha: 1.0),
                              UIColor(red: 206.0/255.0, green: 91.0/255.0, blue: 91.0/255.0, alpha: 1.0),
                              UIColor(red: 233.0/255.0, green: 224.0/255.0, blue: 90.0/255.0, alpha: 1.0),
                              UIColor(red: 141.0/255.0, green: 91.0/255.0, blue: 206.0/255.0, alpha: 1.0),
                              UIColor(red: 195.0/255.0, green: 91.0/255.0, blue: 206.0/255.0, alpha: 1.0)]
    
    
    
    //User information
    let topLearnUsers: [String] = ["kidsfunlearning", "happytotshelf", "colors_baby", "keducattion", "findwayoffice", "cyy_beautifulgirl", "kidsgift88", "bebefinn_official", "alexknowscartoons", "littledreamerseducation"]
    let topToysUsers: [String] = ["james.lam.1", "anlovetoshare", "kikiplayroom", "viralsatisfatoriovideos", "piukutetoy", "paifutoys", "untoyshop2", "mcallyp", "pam.tpon", "volgace"]
    let topNatureUsers: [String] = ["earth_and_sky_play", "creative_mama_che", "mothernatured", "unlockingfun", "thatmountainlife", "wildroadwanderers", "tasnimalatout", "thestayoutsidemama", "earlychildhoodenthusiast"]
    let topArtUsers: [String] = ["andrea.nelson.art", "learningthroughplay8", "home_is_where_the_art_is", "creative_judy", "themakingbox_", "inspiremyplay", "friendsartlab", "abcdeelearning", "celenakinsey", "art_kidss"]
    let topGameUsers: [String] = ["wholesomegames", "learnkidss", "creativeideamalaysia", "ideatimes", "liffy_devil.219", "8playgames8", "happywuggy6", "gamesdog33", "puptales", "gabutdox2"]
    let topDanceUsers: [String] = ["showsomeloove", "boopsalot", "citygirlgonemom", "tuzelitydance.93", "selvihandora", "ghettokids_tfug256", "masakakidsafricana", "kids._dancers", "margineanalinpaul", "eande_dance"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupObservers()
        pointsV.layer.borderWidth = 1.0
        pointsV.layer.cornerRadius = 5.0
        pointsV.layer.borderColor = colorArr[2].cgColor
        print(UserDefaults.standard.object(forKey: "points") ?? 0)
        
    }
    
//    func setupObservers(){
//    print("Observer setup#######################")
//    NotificationCenter.default.addObserver(self, selector:  #selector(handlePointsUpdate(_:)), name: .pointsUpdate, object: nil)
//}
//    @objc func handlePointsUpdate(_ sender: Notification){
//    print("Data updated*******************")
//    DispatchQueue.main.async {
//        UserDefaults.standard.value(forKey: "points")
//        print(UserDefaults.standard.value(forKey: "points"))
//    }
//}
    
    override func viewWillAppear(_ animated: Bool) {
        pointsLbl.text = "\(UserDefaults.standard.object(forKey: "points") ?? 0)"
    }
    
}


extension DashboardVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardCVC", for: indexPath) as! DashboardCVC
        cell.layer.cornerRadius = 10.0
        cell.imgV.image = UIImage(named: "category\(indexPath.row+1)")
        cell.titleLbl.text = titleArr[indexPath.row]
        cell.contentView.backgroundColor = colorArr[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width-48)/2, height: (collectionView.frame.size.width-48)/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CategoryDetailsVC") as! CategoryDetailsVC
        vc.titleStr = titleArr[indexPath.row]
        vc.screenColor = colorArr[indexPath.row]
        
        switch vc.titleStr {
        case titleArr[0]:
            vc.topUsers = topDanceUsers
        case titleArr[1]:
            vc.topUsers = topGameUsers
        case titleArr[2]:
            vc.topUsers = topArtUsers
        case titleArr[3]:
            vc.topUsers = topNatureUsers
        case titleArr[4]:
            vc.topUsers = topToysUsers
        default:
            vc.topUsers = topLearnUsers
        }
        
//            let titleArr = ["DANCE","GAMES","ART","NATURE","TOYS","LEARN"]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

class DashboardCVC:UICollectionViewCell{
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
}
