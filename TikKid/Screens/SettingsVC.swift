//
//  SettingsVC.swift
//  story_viewer
//
//  Created by krunal on 27/11/22.
//

import UIKit
import StoreKit

class SettingsVC: UIViewController {

    @IBOutlet weak var tableV: UITableView!
    
    let imgArr = ["rate_us","share","restore", "", "", ""]
    let titleArr = ["Rate Us","Share App","Restore Purchases", "Sign-Out", "EULA", "Privacy Policy"]
    
    var userDefaults: UserDefaults!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setNavigationBar(vc: self)
    }

    override func viewWillAppear(_ animated: Bool) {
    }
    
    @objc func notificationPressed(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationVC")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    func rateUs(){
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()

        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "appId") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)

            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func shareApp(){
        let url = URL(string: "Link")!
        let text = "Hey!, you should try this App."
        let activity = UIActivityViewController(activityItems: [url, text], applicationActivities: nil)
        present(activity, animated: true)
    }
    
    
    func signOut(){
       //delete credentials from user defaults
//        userDefaults.removeObject(forKey: "credentials")
//        print("Removed")
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        appDel.window?.rootViewController = vc!
       
        
    }
    
    
    func restorePurchase(){
        if (SKPaymentQueue.canMakePayments()) {
          SKPaymentQueue.default().restoreCompletedTransactions()
            print("Purchase restored!")
        }
    }
    
    func eula() {
        if let url = NSURL(string: "https://docs.google.com/document/d/1z9oDuq5ipEWO774pCmZM0wPXSwt1jfkYC5_7MW7hSLM/edit?usp=sharing"){
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    func privPolicy() {
        if let url = NSURL(string: "https://docs.google.com/document/d/1gTGFiImbhEJYz3MFEbCzPDq5LAJxKLz5K_YedgLG8mI/edit?usp=sharing"){
            UIApplication.shared.openURL(url as URL)
        }
    }
}

extension SettingsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTVC") as! SettingsTVC
        cell.imgV.image = UIImage(named: imgArr[indexPath.row])
        cell.titleLbl.text = titleArr[indexPath.row]
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            rateUs()
            print("Rate app")
            break
        case 1:
            shareApp()
            print("Share app")
            break
        case 2:
           restorePurchase()
            print("Restore app")
            break
        case 3:
            signOut()
            print("Sing out")
            break
        case 4:
           eula()
            print("Restore app")
            break
        case 5:
           privPolicy()
            print("Restore app")
        default:
            break
        }
    }
}


class SettingsTVC:UITableViewCell{
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
}

