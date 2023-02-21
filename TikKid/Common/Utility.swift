//
//  Utility.swift
//  FollowTok
//
//  Created by krunal on 3/28/20.
//  Copyright © 2020 krunal. All rights reserved.
//

import Foundation
import UIKit




var points = UserDefaults.standard.value(forKey: "points")
var totalPoints: Int = points as? Int ?? 0
let appDel = UIApplication.shared.delegate as! AppDelegate
var username: String!
let primaryColor = UIColor(named: "PrimaryColor")

func showAlert(title:String,msg:String,vc:UIViewController){
    let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
    }
    alert.addAction(okAction)
    vc.present(alert, animated: true, completion: nil)
}

//func gettingPoints() ->Int{
//    if let points = UserDefaults.standard.value(forKey: "points") as? Int {
//        // The value for "points" exists and is an Int
//         totalPoints = points
//    } else {
//        // The value for "points" is nil
//        totalPoints = 0
//    }
//    return totalPoints
//}

func setPoints(vc:UIViewController){
    
    let pointDisplayLbl = UIBarButtonItem(title: "Points", style: .plain, target: nil, action: nil)
    vc.navigationItem.leftBarButtonItem = pointDisplayLbl

    
    let coinImg = UIBarButtonItem(customView: UIImageView(image: UIImage(named: "doll")))
    
    let pointLbl = UIBarButtonItem(title: "\(totalPoints)", style: .plain, target: vc, action: nil)
    
    let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    space.width = 0
    
    vc.navigationItem.rightBarButtonItems = [coinImg,space,pointLbl]
    
}

func setRightPointsOnly(vc:UIViewController){
    
    let coinImg = UIBarButtonItem(customView: UIImageView(image: UIImage(named: "doll")))
    
    let pointLbl = UIBarButtonItem(title: "\(totalPoints)", style: .plain, target: vc, action: nil)
    
    let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    space.width = 0
    
    vc.navigationItem.rightBarButtonItems = [coinImg,space,pointLbl]
    
}

func updatePoints(pts:Int){
    let userId = UserDefaults.standard.value(forKey: "userId") as! String
    
    let request = NSMutableURLRequest(url: NSURL(string: "https://instads.xyz/pb_setpuntos.php?id=\(userId)&amt=\(pts)")! as URL,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error)
        } else {
            totalPoints += pts
            UserDefaults.standard.set(totalPoints, forKey: "points")
            NotificationCenter.default.post(name: .pointsUpdate, object: nil,userInfo: ["points":String(totalPoints)])
        }
    })
    
    dataTask.resume()
}


func getPoints(){
    let userId = UserDefaults.standard.value(forKey: "userId") as! String
    
    let request = NSMutableURLRequest(url: NSURL(string: "https://instads.xyz/ptsb_puntos.php?id=\(userId)")! as URL,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error)
        } else {
            let str = String(decoding: data!, as: UTF8.self)
            print("Get Points Response \(str)")
            totalPoints = Int(str)!
            UserDefaults.standard.set(totalPoints, forKey: "points")
            NotificationCenter.default.post(name: .pointsUpdate, object: nil,userInfo: ["points":str])
        }
    })
    
    dataTask.resume()
}



extension Notification.Name {
    static  let pointsUpdate = NSNotification.Name("pointsUpdate")
}
