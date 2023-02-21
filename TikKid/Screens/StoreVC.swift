//
//  StoreVC.swift
//  FollowTok
//
//  Created by krunal on 3/28/20.
//  Copyright © 2020 krunal. All rights reserved.
//

import UIKit
import StoreKit

class StoreVC: UIViewController {
    
    @IBOutlet weak var walletBgView: UIView!
    
    @IBOutlet weak var pointsLbl: UILabel!
    
    //Dollar price array
    let dollarArr = [0.99,1.99,3.99,6.99,11.99,19.99,29.99,49.99,99.99]
    
    //percentage off array
    let discountArr = [0,15,20,30,35,40,55,70,80]
    
    //points off array
    let pointsArr = [100,250,500,1000,3000,6500,10000,20000,50000]
    
    let bundleIdArr = ["com.tikkidfaem.app.iap11","com.tikkidfaem.app.iap22","com.tikkidfaem.app.iap33","com.tikkidfaem.app.iap44","com.tikkidfaem.app.iap55","com.tikkidfaem.app.iap66","com.tikkidfaem.app.iap77","com.tikkidfaem.app.iap88","com.tikkidfaem.app.iap99"]
    
    
    
    var productArr = [SKProduct]()
    
    //collectionview displayed on screen for points and price
    @IBOutlet weak var storeCV: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
        
        walletBgView.layer.cornerRadius = 5.0
        walletBgView.layer.borderWidth = 1.0
        walletBgView.layer.borderColor = UIColor(named: "primary")?.cgColor
       
        
        PKIAPHandler.shared.setProductIds(ids: bundleIdArr)
        PKIAPHandler.shared.fetchAvailableProducts { [weak self](products)   in
            guard let sSelf = self else {return}
            sSelf.productArr = products
            
            DispatchQueue.main.async {
                sSelf.storeCV.reloadData()
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
        UserDefaults.standard.value(forKey: "points")
        print(UserDefaults.standard.value(forKey: "points") ?? 0)
    }
}


    override func viewWillAppear(_ animated: Bool) {
        pointsLbl.text = "\(UserDefaults.standard.object(forKey: "points") ?? 0)"
    }
    
}

extension StoreVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dollarArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //PriceCVC Identifier given to collectionview cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PriceCVC", for: indexPath) as! PriceCVC
        cell.priceLbl.text = "$\(dollarArr[indexPath.row]) USD"
        cell.pointsLbl.text = "\(pointsArr[indexPath.row])"
        
//        cell.priceLbl.textColor = UIColor.black
//        cell.pointsLbl.textColor = UIColor.black
        cell.layer.cornerRadius = 10.0
//        cell.layer.borderWidth = 1.0
//        cell.layer.borderColor = UIColor.black.cgColor
//        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 50)
    }
    
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    //            return CGSize(width: collectionView.frame.width - 32, height: 40)
    //    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if (productArr.count >= 0){
            puchaseProduct(indexNo:indexPath.row)
        } else {
            let alertVC = UIAlertController(title:"Loading", message: "Products still loading, please try again in a couple seconds, if issue persists please check your internet connection.", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "Ok", style: .default) { [self] _ in

            }


            alertVC.addAction(okAction)
            present(alertVC, animated: true, completion: nil)
        }
        
//        if indexPath.section == 0 {
//            let alertVC = UIAlertController(title:"Confirm", message: "Do you want to purchase \(pointsArr[indexPath.row]) points", preferredStyle: .alert)
//
//            let okAction = UIAlertAction(title: "Yes", style: .default) { _ in
////                totalPoints = totalPoints + Int(self.pointsArr[indexPath.row])
//                self.puchaseProduct(indexNo: indexPath.row)
//                self.storeCV.reloadData()
//                UserDefaults.standard.set(totalPoints, forKey: "points")
//                UserDefaults.standard.synchronize()
////                setNavigationBar(vc: self)
//                self.pointsLbl.text = "\(totalPoints)"
//
////                                self.puchaseProduct(indexNo: indexPath.row)
//            }
//
//            let cancelAction = UIAlertAction(title: "No", style: .default) { _ in
//
//            }
//
//            alertVC.addAction(okAction)
//            alertVC.addAction(cancelAction)
//            present(alertVC, animated: true, completion: nil)
//
//        }
    }
    
    func puchaseProduct(indexNo:Int){
        
        var pr : SKProduct?
        for item in productArr {
            if item.productIdentifier ==  bundleIdArr[indexNo]{
                pr = item
                break
            }
        }
        if pr == nil{
            return
        }

        
        
        PKIAPHandler.shared.purchase(product: pr!) { (alert, product, transaction) in
            if let tran = transaction, let prod = product {
                //use transaction details and purchased product as you want
                
                let tob = Int(self.pointsArr[indexNo])
                
//                updatePoints(pts: tob)
                totalPoints = totalPoints + Int(self.pointsArr[indexNo])
                self.storeCV.reloadData()
                UserDefaults.standard.set(totalPoints, forKey: "points")
                print("==============POINTS SAVEDDDDDDDDDD!!!!!!!!!!!!!!!!!!!!=========")
//                setNavigationBar(vc: self)
//                self.pointsLbl.text = "\(totalPoints)"

                    let obj = ReceiptValidator()
                    obj.verifyReceipt(tran)
                
            }
        }
        
        
    }
    
}



//Create class for Price display Cell
class PriceCVC: UICollectionViewCell {
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var pointsLbl: UILabel!
}

//Points Available CollectionViewCell
class PointsCVC: UICollectionReusableView {
    @IBOutlet weak var stackV: UIStackView!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var contentView: UIView!
}

//extension to support specific corner rounded
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
