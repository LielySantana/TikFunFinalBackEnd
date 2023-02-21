//
//  LoginVC.swift
//  TikKid
//
//  Created by krunal on 31/01/23.
//

import UIKit

class LoginVC: UIViewController {

    let userDefaults = UserDefaults.standard
    var userInfo: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDefaults.removeObject(forKey: "credentials")
        print(userDefaults.object(forKey: "credentials"))

    }
    
    @IBOutlet weak var loginTextField: UITextField!
    
    @IBAction func loginBtnPress(_ sender: UIButton) {
        if(self.loginTextField.text != ""){
            self.checkText(text: loginTextField.text!)
            let loader = self.loader()
            getId(text: loginTextField.text!)
            self.stopLoader(loader: loader)
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Please enter an username", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }

       
    }
    
    func getId(text: String){
        let userIdVm = UserIdVM()
        userIdVm.getUserId(query: text.lowercased()){
            userId in
            if userId != nil {
                DispatchQueue.main.async {
                    self.getId(text: userId!)
                    let userData = self.loginTextField.text!
                    self.credentials(userData: userData)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Main")
                    appDel.window?.rootViewController = vc!
                    }
            } else {
                let alert = UIAlertController(title: "Error", message: "Please insert a valid username", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            }
    }

    func credentials(userData: String) {
//        var credentialsData = userDefaults.object(forKey: "credentials") as? [String:String] ?? [:]
        username = userData
        userDefaults.set(userData, forKey: "credentials")
        print("Credentials saved:", userDefaults.object(forKey: "credentials"))
    }


}
