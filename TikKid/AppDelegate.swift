//
//  AppDelegate.swift
//  TikKid
//
//  Created by krunal on 31/01/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        totalPoints = 0
        // Override point for customization after application launch.
        if let userId = UserDefaults.standard.value(forKey: "userId") as? String {
            print("UserId is \(userId)")
        }else{
            let uId = UIDevice.current.identifierForVendor?.uuidString
            let uAd = "POTP"
            let stringC = uAd + (uId ?? "")!

            UserDefaults.standard.set(stringC, forKey: "userId")
            print("UserId ssis \(stringC)")
        }
        
        
        let userDefaults = UserDefaults.standard
        let userRawData = userDefaults.object(forKey: "credentials")
        print(userRawData)
        if(userRawData != nil){
            //is Logged in
            do {
                let userData = userRawData
                username = userData as! String?
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "Main")
                //vc?.profilePicUrl = self.userData.profilePicUrl
                appDel.window?.rootViewController = vc
            
            } catch  {
                
            }
        }

        
  
        return true
    }

   
}

