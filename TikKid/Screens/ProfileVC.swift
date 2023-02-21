//
//  ProfileVC.swift
//  TikKid
//
//  Created by krunal on 04/02/23.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var resultImgV: UIImageView!
    @IBOutlet weak var profileReviewView: UIView!
    @IBOutlet weak var profileBtn: UIButton!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tiktokCV: UICollectionView!
    var isFirst: Bool = true
    @IBOutlet weak var pointsLbl: UILabel!
    
    @IBOutlet weak var statisticsView: UIStackView!
    
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var egagementRate: UILabel!
    @IBOutlet weak var engagementImg: UIImageView!
    
    
    
    var userData: UserModelSearch!
    var userDataList: [UserModelSearch]! = []
    var videoDataList: [VideoModel]! = []
    var posts: Int!
    var followersN: Int!
    var likesN: Int!
    var engagement: Float!
    
    @IBOutlet weak var profilePic: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        totalPoints = UserDefaults.standard.object(forKey: "points") as? Int ?? 0
        profileReviewView.isHidden = true
        resultImgV.isHidden = true
        self.userNameLbl.text = "Welcome, \(username!)!"
        let loader = self.loader()
        self.getId(text: username!)
        stopLoader(loader: loader)
        bgView.clipsToBounds = true
        bgView.layer.cornerRadius = 15
        bgView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
        
        tiktokCV.register(UINib(nibName: "PostCVC", bundle: nil), forCellWithReuseIdentifier: "PostCVC")
        statisticsView.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pointsLbl.text = "\(totalPoints)"
    }
    
  
    
    
    @IBAction func searchBtn(_ sender: UIButton) {
        if(self.searchField.text != ""){
            self.checkText(text: searchField.text!)
            let loader = self.loader()
            loader
            var group = DispatchGroup()
            group.enter()
            getId(text: searchField.text!)
            group.leave()
            group.notify(queue: .main){
                
                if self.profileReviewView.isHidden == false{
                    self.profileReviewView.isHidden = true
                    self.profileBtn.isHidden = false
                    
                }
                self.stopLoader(loader: loader)
                
            }
           
        } else {
            print("Empty text")
        }
        
    }
    
    
    func getId(text: String){
        isFirst = false
        let userIdVm = UserIdVM()
        userIdVm.getUserId(query: text.lowercased()){
            userId in
            if userId != nil {
                DispatchQueue.main.async {
                    print(userId)
                    self.SearchContent(text: userId!)
                    self.getId(text: userId!)
                    self.getPosts(userId: userId!)
                    }
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
    
    func SearchContent (text: String){
        isFirst = false
        let contentSearch = UserListVM()
        contentSearch.getSearch(query: text.lowercased()){
            data in
            if data != nil {
                DispatchQueue.main.async {
                    self.userDataList = []
                    self.statisticsView.isHidden = false
                    var currentUser = data
                    self.followersN = data!.follower
                    self.likesN = data!.likes
                    self.following.text = "\(self.formatNumber(data!.following))"
                    self.followers.text = "\(self.formatNumber(data!.follower))"
                    self.likes.text = "\(self.formatNumber(data!.likes))"
                    self.profilePic.load(urlString: data!.profilePicUrl)
//                    print(data!)

                    }
                }
            }
    }
    
    
    func getStats (text: String){
        var semaphore = DispatchSemaphore(value: 0)
        var data: StatisticsModel!
        let contentSearch = StatisticsVM()
        contentSearch.getStats(query: text.lowercased()){
            data in
            if data != nil {
                DispatchQueue.main.async {
                    self.posts = data!.uploadCount
                    self.engageCalc()
                    print(data!)

                }
            }
            semaphore.signal()

        }

        semaphore.wait()
        if data != nil{
            return
        }
        print("First request failed")
    }
    
    func getComments(text: String){
        var semaphore = DispatchSemaphore(value: 0)
        var data: StatisticsModel!
        let contentSearch = StatisticsVM()
        contentSearch.getStats(query: text.lowercased()){
            data in
            if data != nil {
                DispatchQueue.main.async {
                    var currentUser = self.userDataList[0]
                    currentUser.commentCount = data!.commentCount
                    self.userDataList = [currentUser]
//                    self.collectionV.reloadData()
                    print(data!)

                }
            }
            semaphore.signal()
        }

        semaphore.wait()
        if data != nil{
            return
        }
        print("First comment request failed")
    }
    
    
    func engageCalc() -> Float{
        var firstValue: Int = likesN
        var secondValue: Double = 0.22
        var commentResult: Double = Double(firstValue) * secondValue
        var sum: Int = Int(commentResult)+likesN
        var engage: String
        var div: Double = Double(followersN) / Double(sum)
        var result: Float = Float(div * 100)
        print(result)
        print("This is the engageeeeeeeeeeeeeeee")
        return result
    }
    
    

    
    
    
    @IBAction func profileBtnPress(_ sender: UIButton) {
        if totalPoints <= 50{
            self.tabBarController?.selectedIndex = 2
            return
        }
        let alertVC = UIAlertController(title:"Unlock User", message: "By confirming this, 50 coins are going to be substracted from your app wallet.", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Confirm", style: .default) { _ in
//            totalPoints = totalPoints - 20
            updatePoints(pts: -50)
            UserDefaults.standard.set(totalPoints, forKey: "points")
            self.pointsLbl.text = "\(totalPoints)"
//            self.profileReviewView.isHidden = false
//            self.resultImgV.isHidden = false
//            self.profileBtn.isHidden = true
//
            
            self.engagement = self.engageCalc()
            if self.engagement <= 4 {
                let myImage = UIImage(named: "traffic-light 1")
                self.profileReviewView.isHidden = false
                self.resultImgV.isHidden = false
                self.resultImgV.image = myImage
                self.profileBtn.isHidden = true
                self.egagementRate.text = "Your Tiktok profile is in need of some work. \n Post more to engage your fans!"
                self.egagementRate.textColor = UIColor.red
                self.resultImgV.image = myImage

            } else if self.engagement > 4 && self.engagement <= 8 {
                let myImage = UIImage(named: "traffic-light (1)")
                self.profileReviewView.isHidden = false
                self.resultImgV.isHidden = false
                self.resultImgV.image = myImage
                self.profileBtn.isHidden = true
                self.egagementRate.text = "Your Tiktok profile is looking good! \n But it has the potential to improve, Keep up \n the good work!"
                self.egagementRate.textColor = UIColor.orange
                self.resultImgV.image = myImage
                
            } else if self.engagement > 8 {
                self.profileReviewView.isHidden = false
                self.resultImgV.isHidden = false
                self.profileBtn.isHidden = true
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            
        }
        
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
        
        
    }
    
}


extension ProfileVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCVC", for: indexPath) as! PostCVC
        
        if let videoDataList = videoDataList, indexPath.row < videoDataList.count {
              let profileData = videoDataList[indexPath.row]
              cell.nameLbl.text = profileData.authorName
              cell.bgImgV.load(urlString: profileData.coverUrl!)
              cell.profileImgV.load(urlString: profileData.authorPicUrl!)
              cell.videosInfo = profileData
          } else {
              cell.backgroundColor = UIColor(red: 61.0/255.0, green: 61.0/255.0, blue: 61.0/255.0, alpha: 1.0)
          }
          
          return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = NSURL(string: videoDataList[indexPath.row].videoUrl!){
            UIApplication.shared.openURL(url as URL)}
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.size.height * 0.8, collectionView.frame.size.height)
    }
}
