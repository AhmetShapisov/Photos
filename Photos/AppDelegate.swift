//
//  AppDelegate.swift
//  Photos
//
//  Created by Alex Borodalex on 6/2/20.
//  Copyright © 2020 Alex Borodalex. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        
        //        Manager.shared.apdate(items: [])
        // Override point for customization after application launch.
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}




extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            picker.dismiss(animated: true, completion: nil)
            let path = Manager.shared.saveImage(image: pickedImage)
            
            customImages.imagePath = path
            
            print(customImages.imagePath as Any)
            
            Manager.shared.save(item: customImages)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update"), object: nil)
            
        }
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}


extension ViewController {
    
    func deleteAlert() {
        let alertController = UIAlertController(title: nil, message: "Are Your Sure?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            
            Manager.shared.deleteAt(index: self.index)
            self.addRightImageView()
                   
                   self.index += 1
                   if self.index > Manager.shared.loadArray().count - 1 {
                       self.index = 0
                   }
                   UIView.animate(withDuration: 0.5, animations: {
                       self.firstImageView.alpha = 0.0
                       self.secondImageView.image = Manager.shared.loadImage(fileName: Manager.shared.loadArray()[self.index].imagePath ?? "")
                       self.secondImageView.frame.origin.x = self.firstImageView.frame.origin.x
                   }) { (_) in
                       self.firstImageView.alpha = 1
                       self.firstImageView.image = Manager.shared.loadImage(fileName: Manager.shared.loadArray()[self.index].imagePath ?? "")
                       self.secondImageView.removeFromSuperview()
                       self.likeButtonn.isSelected = Manager.shared.loadArray()[self.index].like
                       self.textField.text = Manager.shared.loadArray()[self.index].comment
                   }
            self.loadImages()
        }
        let censelAction = UIAlertAction(title: "Censel", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(censelAction)
        self.present(alertController,animated: true, completion: nil)
    }
    
    
    func showAlert(title: String, messege: String, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: messege, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(okAction)
        self.present(alertController,animated: true, completion: nil)
    }
    
    
    func showAlert(title: String, messege: String, leftButtomHandler: ((UIAlertAction) -> Void)?, rightButtonHandler: ((UIAlertAction) -> Void)?)  {
        let alertController = UIAlertController(title: title, message: messege, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: leftButtomHandler)
        let canselAction = UIAlertAction(title: "Cansel", style: .cancel, handler: rightButtonHandler)
        alertController.addAction(okAction)
        alertController.addAction(canselAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func passwordEnterAlert(password: String) {
        let alertController = UIAlertController(title: "Welcom!", message: "Enter your password", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Password"
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            guard let textFielf = alertController.textFields?.first else {
                self.showAlert(title: "Error", messege: "Enter Your Name") { (_) in
                    self.passwordEnterAlert(password: "123")
                }
                return
            }
            if textFielf.text != password {
                self.showAlert(title: "Error", messege: "Enter Your Name") { (_) in
                    self.passwordEnterAlert(password: "123")
                    return
                }
            }
            if textFielf.text == password {
//            UIView.transition(with: self.view, duration: 1.5, options: .transitionFlipFromLeft, animations: {
//                           self.blueEffect.isHidden = true
//                       }, completion: nil)
                UIView.animate(withDuration: 1) {
                    self.blueEffect.alpha = 0.0
                }
            }
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UserDefaults {
    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }
    
    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
            let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
}

extension UIView {
    
    
    func setGradient() {
        let layer = CAGradientLayer()
        layer.frame = self.bounds
        layer.colors = [
            UIColor.white.cgColor,
            UIColor.systemIndigo.cgColor,
            UIColor.systemIndigo.cgColor,
            UIColor.blue.cgColor,
            //            UIColor.blue.cgColor,
            UIColor.systemTeal.cgColor,
            UIColor.systemTeal.cgColor,
            UIColor.green.cgColor,
            UIColor.white.cgColor,
            
            
        ]
        //        layer.cornerRadius = 20 systemIndigo
        self.layer.insertSublayer(layer, at: 0)
    }
    
    func setShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.shadowRadius = 5
        self.layer.cornerRadius = 20
    }
}


