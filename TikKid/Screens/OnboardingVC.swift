//
//  OnboardingVC.swift
//  TikKid
//
//  Created by krunal on 31/01/23.
//

import UIKit

class OnboardingVC: UIViewController {
    
    @IBOutlet weak var pageCtrl: UIPageControl!
    let colorArr:[UIColor] = [UIColor(red: 91.0/255.0, green: 114.0/255.0, blue: 206.0/255.0, alpha: 1.0),
                              UIColor(red: 91.0/255.0, green: 206.0/255.0, blue:137.0/255.0, alpha: 1.0),
                              UIColor(red: 206.0/255.0, green: 91.0/255.0, blue: 91.0/255.0, alpha: 1.0),
                              UIColor(red: 141.0/255.0, green: 91.0/255.0, blue: 206.0/255.0, alpha: 1.0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension OnboardingVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCVC", for: indexPath) as! OnboardingCVC
        cell.imgV.image = UIImage(named: "splash\(indexPath.row+1).png")
        cell.txtImgV.image = UIImage(named: "msg\(indexPath.row+1).png")
        cell.backgroundColor = colorArr[indexPath.row]
        if indexPath.row == 3{
            cell.doneBtn.isHidden = false
        }else{
            cell.doneBtn.isHidden = true
        }
        cell.doneBtn.addTarget(self, action: #selector(donePress), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    @objc func donePress(){
        let vc = storyboard?.instantiateViewController(withIdentifier:
        "LoginVC")
        appDel.window?.rootViewController = vc!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2
        
        pageCtrl.currentPage = Int(offSet + horizontalCenter) / Int(width)
    }
}

class OnboardingCVC:UICollectionViewCell{
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var txtImgV: UIImageView!
    @IBOutlet weak var doneBtn: UIButton!
}

