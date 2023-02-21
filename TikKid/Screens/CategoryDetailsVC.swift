//
//  CategoryDetailsVC.swift
//  TikKid
//
//  Created by krunal on 04/02/23.
//

import UIKit
import StoreKit

class CategoryDetailsVC: UIViewController{
    
    @IBOutlet weak var bgImgV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    var titleStr = ""
    var screenColor = UIColor.white
    @IBOutlet weak var userCV: UICollectionView!
    @IBOutlet weak var tiktokCV: UICollectionView!
    var numberOfUsers = 10
    var purchasedUserArr:[Bool] = [Bool]()
    var clickedUser = 0
    var userDefaults: UserDefaults!
    //API Call
    var isFirst: Bool = true
    var userData: UserModel!
    var userDataList: [UserModel]! = []
    var userID: String = ""
    var vidVM: globalVM!
    
    var topUsers: [String] = []
    var topUsersIds: [String] = []
    var videoDataList: [VideoModel]! = []
   
  
    
    override func viewDidLoad(){
        let loader = self.loader()
        totalPoints = UserDefaults.standard.object(forKey: "points") as? Int ?? 0
        super.viewDidLoad()
        setupObservers()
        titleLbl.text = titleStr
        bgImgV.image = UIImage(named: "\(titleStr.lowercased())_bg")
        userCV.register(UINib(nibName: "UserCVC", bundle: nil), forCellWithReuseIdentifier: "UserCVC")
        tiktokCV.register(UINib(nibName: "PostCVC", bundle: nil), forCellWithReuseIdentifier: "PostCVC")
        
        print(topUsers)
        
        
        Task.detached{ [weak self] in
            await self?.getUserIds()
            await self?.loadUsers()
            await self?.getPosts(userId: self!.userID)
            await self!.stopLoader(loader: loader)
        }
        
        
        
        for i in 0..<numberOfUsers{
            if i == 0{
                purchasedUserArr.append(true)
            }else{
                purchasedUserArr.append(false)
            }
        }

    }
    
    func setupObservers(){
        print("Observer setup#######################")
        NotificationCenter.default.addObserver(self, selector:  #selector(handlePointsUpdate(_:)), name: .pointsUpdate, object: nil)
    }
    @objc func handlePointsUpdate(_ sender: Notification){
        print("Data updated*******************")
        DispatchQueue.main.async {
            UserDefaults.standard.setValue(totalPoints, forKey: "points")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBAction func backPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func loadUsers() async{
        let loader = self.loader()
        isFirst = false
        let globalVM = globalVM()

            for userId in topUsersIds{
                    let userData = await globalVM.getUser(query: userId)

                        if(userData != nil){
                   
                            self.userDataList.append(userData!)
                            self.userCV.reloadData()
                            self.stopLoader(loader: loader)
                        } else {
                            print("Failed load of user Data")
                        }
                    
                print("This is the user ID: ", userId)
            }
    }

    
    func getUserIds() async{
        let globalVM = globalVM()
        
        for user in topUsers {
            let userIds = await globalVM.getUserId(query: user)
            if(userIds != nil){
                self.topUsersIds.append(userIds!)
                userID = topUsersIds[0]
            } else {
                print("Failed load of user Ids")
            }
        }
    }
    
    func getPosts(userId: String){
        let globalVM = globalVM()
       
        globalVM.getPosts(query: userId){
            profilePostList in
            
            if(profilePostList != nil){
                DispatchQueue.main.async {
                    self.videoDataList = profilePostList
                    print(profilePostList?.count)
                    print("===========HERE IS THE VIDEO COUNT ==================")
                    self.tiktokCV.reloadData()
                    
                }
            
        } else{
            print("Failed displaying user list")
        }
        }
           
    }
    
    func purchaseAlert(){
        if totalPoints <= 20{
            self.tabBarController?.selectedIndex = 2
            return
        }
        let alertVC = UIAlertController(title:"Unlock User", message: "By confirming this, 20 coins are going to be substracted from your app wallet.", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Confirm", style: .default) { _ in
//            totalPoints = totalPoints - 20
            updatePoints(pts: -20)
            self.purchasedUserArr[self.clickedUser] = true
            self.userCV.reloadData()
            UserDefaults.standard.set(totalPoints, forKey: "points")
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in

        }

        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }



    
    
}

extension CategoryDetailsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tiktokCV{
            return videoDataList.count
        }
        
    
        return userDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tiktokCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCVC", for: indexPath) as! PostCVC
            let profileData = videoDataList[indexPath.row]
            cell.nameLbl.text = profileData.authorName
            cell.bgImgV.load(urlString: profileData.coverUrl!)
            cell.profileImgV.load(urlString: profileData.authorPicUrl!)
            cell.videosInfo = profileData
            return cell
        }
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCVC", for: indexPath) as! UserCVC
        cell.ratingView.rating = 5.0
        cell.ratingView.starColor = screenColor
        cell.nameLbl.textColor = screenColor
        
        let topUser = userDataList[indexPath.row]
        cell.nameLbl.text = topUser.nickname
        cell.imgV.load(urlString: topUser.profilePicUrl)
        cell.imgV.setRounded()
        cell.userInfo = topUser
        
        cell.ratingView.isUserInteractionEnabled = false
    
        
        
            if purchasedUserArr[indexPath.row]{
                cell.purchaseView.isHidden = true
                cell.isUnlocked =  true
            }else{
                cell.purchaseView.isHidden = false
                cell.isUnlocked = false
    
            }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.size.height * 0.8, collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)  {
        if collectionView == userCV {
            clickedUser = indexPath.row
           
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? UserCVC else {return}
            cell.userInfo = userDataList[indexPath.row]
//            let postCell = collectionView.cellForItem(at: indexPath) as? PostCVC
            
            if cell.isUnlocked == false{
                purchaseAlert()
            } else {
                userID = userDataList[indexPath.row].userId
                print("PRESSEDDDDDDDDDDDDDDDDDDDDDD", userID)
                self.getPosts(userId: cell.userInfo.userId)
               
            }
            
            return

        }
        
        
        if collectionView == tiktokCV {
//            clickedUser = indexPath.row
            guard let cell = collectionView.cellForItem(at: indexPath) as? PostCVC else {return}
            if let url = NSURL(string: videoDataList[indexPath.row].videoUrl!){
                UIApplication.shared.openURL(url as URL)
            }
            
        }
    }
}
