//
//  Extensions.swift
//  TikKid
//
//  Created by Christina Santana on 20/2/23.
//

import Foundation
import UIKit


extension UIViewController {
    func loader() -> UIAlertController {
            let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            loadingIndicator.style = UIActivityIndicatorView.Style.large
        } else {
            // Fallback on earlier versions
        }
            loadingIndicator.startAnimating()
            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
            return alert
        }
    func loaderstr() -> UIAlertController {
            let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            loadingIndicator.style = UIActivityIndicatorView.Style.large
        } else {
            // Fallback on earlier versions
        }
            loadingIndicator.startAnimating()
            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
            return alert
        }
    
        
        func stopLoader(loader : UIAlertController) {
            DispatchQueue.main.async {
                loader.dismiss(animated: true, completion: nil)
            }
        }
    
    func checkText(text: String?){
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        if text!.rangeOfCharacter(from: characterset.inverted) != nil{
            print("String with special characters")
            
        } else {
            return
            }
        }
    
    func formatNumber(_ num: Int) -> String {
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .decimal
        numFormatter.maximumFractionDigits = 1

        let numString = String(num)

        switch numString.count {
        case 4..<7:
            let shortNum = Double(num) / 1_000
            return numFormatter.string(from: NSNumber(value: shortNum))! + "k"
        case 7..<10:
            let shortNum = Double(num) / 1_000_000
            return numFormatter.string(from: NSNumber(value: shortNum))! + "M"
        case 10..<13:
            let shortNum = Double(num) / 1_000_000_000
            return numFormatter.string(from: NSNumber(value: shortNum))! + "B"
        default:
            return numFormatter.string(from: NSNumber(value: num))!
        }
    }

    
}




var imageCache = NSCache<AnyObject,AnyObject>()
extension UIImageView {
    func load(urlString : String) {
        if  let image = imageCache.object(forKey: urlString as NSString)as? UIImage{
            self.image = image
            return
        }
        guard let url = URL(string: urlString)else {
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageCache.setObject(image, forKey: urlString as NSString)
                        self?.image = image
                    }
                }
            }
        }
    }
}


extension UIImageView {

   func setRounded() {
       let radius = CGRectGetWidth(self.frame) / 2
           self.layer.cornerRadius = radius
           self.layer.masksToBounds = true
   }
}





