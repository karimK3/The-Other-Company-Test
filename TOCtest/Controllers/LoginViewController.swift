//
//  LoginViewController.swift
//  TOCTest
//
//  Created by Karim on 14/10/2018.
//  Copyright © 2018 Karim. All rights reserved.
//


import UIKit
import AVFoundation
import Photos
import SSSpinnerButton

public class LoginViewController: UIViewController {
    
    // MARK: - Variables
    
    var txtUsername: UITextField!
    var txtEmail: UITextField!
    var txtPassword: UITextField!
    
    var imgvUserIcon: UIImageView!
    var imgvEmailIcon: UIImageView!
    var imgvPasswordIcon: UIImageView!
    var imgvLogo: UIImageView!
    
    public var loginView: UIView!
    public var pictureView: UIView!
    var bottomTxtUsernameView: UIView!
    var bottomTxtEmailView: UIView!
    var bottomTxtPasswordView: UIView!
    
    var butLogin: SSSpinnerButton!
    var butSignup: UIButton!
    var labelAlert: UILabel!
    
    var pictureImageView: UIImageView!
    var uploadButton: SSSpinnerButton!
    var pictureLabel: UILabel!
    
    var isLogin = true
    
    var imagePicker = UIImagePickerController()
    
    public enum SendType {
        
        case Login
        case Signup
    }
    
    // MARK: Customizations

    public var videoURL = Bundle.main.url(forResource: "clubbing", withExtension: "mov")!
    public var logo = UIImage(named: "eyenight")
    public var loginButtonColor = UIColor.purple
    public var backgroundColor = UIColor(red: 224 / 255, green: 68 / 255, blue: 98 / 255, alpha: 1)
    public var isSignupSupported = true
    
    // MARK: - Methods
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Setup UI elements
        
        setupLoginView()
        setupVideoBackgrond()
        setupLoginLogo()
        setupEmailField()
        setupUsernameField()
        setupPasswordField()
        setupLoginButton()
        setupSignupButton()
        setupPictureView()
        setupAlert()
        
        view.addSubview(loginView)
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Background Video Player
    
    func setupVideoBackgrond() {
        
            let shade = UIView(frame: self.view.frame)
            shade.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
            view.addSubview(shade)
            view.sendSubview(toBack: shade)
            
            var avPlayer = AVPlayer()
            avPlayer = AVPlayer(url: self.videoURL)
            let avPlayerLayer = AVPlayerLayer(player: avPlayer)
            avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            avPlayer.volume = 0
            avPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.none
            
            avPlayerLayer.frame = view.layer.bounds
            
            let layer = UIView(frame: self.view.frame)
            view.backgroundColor = UIColor.clear
            view.layer.insertSublayer(avPlayerLayer, at: 0)
            view.addSubview(layer)
            view.sendSubview(toBack: layer)
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
            
            avPlayer.play()
    }
    
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        
        if let p = notification.object as? AVPlayerItem {
            p.seek(to: kCMTimeZero, completionHandler: nil)
        }
    }
    
    // MARK: Background Color
    
    func setupBackgroundColor() {
        self.view.backgroundColor = self.backgroundColor
    }
    
    // MARK: Login Logo
    func setupLoginLogo() {
        
        let logoFrame = CGRect(x: (self.view.bounds.width - 100) / 2, y: 60, width: 100, height: 100)
        imgvLogo = UIImageView(frame: logoFrame)
        
        if let loginLogo = logo {
            
            imgvLogo.image = loginLogo
            
            view.addSubview(imgvLogo)
        }
    }
    
    // MARK: Login View
    func setupLoginView() {
        
        let loginX: CGFloat = 20
        let loginY = CGFloat(130 + 40)
        let loginWidth = self.view.bounds.width - 40
        let loginHeight: CGFloat = self.view.bounds.height - loginY - 30
        print(loginHeight)
        
        loginView = UIView(frame: CGRect(x: loginX, y: loginY, width: loginWidth, height: loginHeight))
    }
    
    // MARK: Picture View
    
    public func setupPictureView() {
        
        let loginY = CGFloat(130 + 40)
        let loginWidth = self.view.bounds.width - 40
        let loginHeight: CGFloat = self.view.bounds.height - loginY - 30
        print(loginHeight)
        
        pictureView = UIView(frame: CGRect(x: self.view.frame.size.width, y: loginY, width: loginWidth, height: loginHeight))
        
        pictureImageView = UIImageView(frame: CGRect(x: (self.pictureView.frame.size.width - 100)/2, y: 10, width: 100, height: 100))
        pictureImageView.image = UIImage(named: "avatar")
        pictureImageView.layer.masksToBounds = false
        pictureImageView.layer.cornerRadius = 50 //This will change with corners of image and height/2 will make this circle shape
        pictureImageView.clipsToBounds = true
        pictureView.addSubview(pictureImageView)
        
        pictureLabel = UILabel(frame: CGRect(x: 30, y: 110, width: self.pictureView.frame.size.width - 60, height: 50))
        pictureLabel.text = "Add your profile picture"
        pictureLabel.textColor = UIColor.white
        pictureLabel.numberOfLines = 0
        pictureLabel.textAlignment = NSTextAlignment.center
        pictureLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 13)!
        pictureView.addSubview(pictureLabel)
        
        uploadButton = SSSpinnerButton(title: "Upload")
        uploadButton.frame = CGRect(x: 30, y: 210, width: self.pictureView.frame.size.width - 60, height: 40)
        uploadButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        uploadButton.addTarget(self, action: #selector(self.pressUpload), for: .touchUpInside)
        uploadButton.backgroundColor = UIColor.purple
        uploadButton.layer.cornerRadius = 5
        uploadButton.layer.borderWidth = 1
        uploadButton.layer.borderColor = UIColor.clear.cgColor
        pictureView.addSubview(uploadButton)
        self.view.addSubview(pictureView)
        

    }
    

    

    
    // MARK: Setup login fields & other elements
    
    func setupEmailField() {
        
        imgvEmailIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let bundle = Bundle(for: LoginViewController.self)
        imgvEmailIcon.image = UIImage(named: "mail", in: bundle, compatibleWith: nil)
        imgvEmailIcon.alpha = 0
        loginView.addSubview(imgvEmailIcon)
        
        txtEmail = UITextField(frame: CGRect(x: imgvEmailIcon.frame.width + 5, y: 0, width: loginView.frame.width - imgvEmailIcon.frame.width - 5, height: 30))
        txtEmail.delegate = self
        txtEmail.returnKeyType = .next
        txtEmail.isSecureTextEntry = false
        txtEmail.textColor = UIColor.white
        txtEmail.autocorrectionType = .no
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        txtEmail.alpha = 0
        loginView.addSubview(txtEmail)
    
        bottomTxtEmailView = UIView(frame: CGRect(x: txtEmail.frame.minX - imgvEmailIcon.frame.width - 5, y: txtEmail.frame.maxY + 5, width: loginView.frame.width, height: 1))
        bottomTxtEmailView.backgroundColor = .white
        bottomTxtEmailView.alpha = 0
        loginView.addSubview(bottomTxtEmailView)
    }
    
    func setupUsernameField() {
        
        imgvUserIcon = UIImageView(frame: CGRect(x: 0, y: txtEmail.frame.maxY + 10, width: 30, height: 30))
        
        let bundle = Bundle(for: LoginViewController.self)
        imgvUserIcon.image = UIImage(named: "user", in: bundle, compatibleWith: nil)
        loginView.addSubview(imgvUserIcon)
        
        txtUsername = UITextField(frame: CGRect(x: imgvUserIcon.frame.width + 5, y: txtEmail.frame.maxY + 10, width: loginView.frame.width - imgvUserIcon.frame.width - 5, height: 30))
        txtUsername.delegate = self
        txtUsername.returnKeyType = .next
        txtUsername.isSecureTextEntry = false
        txtUsername.textColor = UIColor.white
        txtUsername.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        loginView.addSubview(txtUsername)
        
        bottomTxtUsernameView = UIView(frame: CGRect(x: txtUsername.frame.minX - imgvUserIcon.frame.width - 5, y: txtUsername.frame.maxY + 5, width: loginView.frame.width, height: 1))
        bottomTxtUsernameView.backgroundColor = .white
        loginView.addSubview(bottomTxtUsernameView)
    }
    
    func setupPasswordField() {
        
        imgvPasswordIcon = UIImageView(frame: CGRect(x: 0, y: txtUsername.frame.maxY + 10, width: 30, height: 30))
        
        let bundle = Bundle(for: LoginViewController.self)
        imgvPasswordIcon.image = UIImage(named: "password", in: bundle, compatibleWith: nil)
        loginView.addSubview(imgvPasswordIcon)
        
        txtPassword = UITextField(frame: CGRect(x: imgvPasswordIcon.frame.width + 5, y: txtUsername.frame.maxY + 10, width: loginView.frame.width - imgvPasswordIcon.frame.width - 5, height: 30))
        txtPassword.delegate = self
        txtPassword.returnKeyType = .done
        txtPassword.isSecureTextEntry = true
        txtPassword.textColor = UIColor.white
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        loginView.addSubview(txtPassword)
        
        bottomTxtPasswordView = UIView(frame: CGRect(x: txtPassword.frame.minX - imgvPasswordIcon.frame.width - 5, y: txtPassword.frame.maxY + 5, width: loginView.frame.width, height: 1))
        bottomTxtPasswordView.backgroundColor = .white
        bottomTxtPasswordView.alpha = 0.5
        loginView.addSubview(bottomTxtPasswordView)
    }
    
    func setupLoginButton() {
        
        butLogin = SSSpinnerButton(title: "Login")
        butLogin.frame = CGRect(x: 0, y: bottomTxtPasswordView.frame.maxY + 30, width: loginView.frame.width, height: 40)

        butLogin.backgroundColor = self.loginButtonColor
        
        butLogin.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        butLogin.layer.cornerRadius = 5
        butLogin.layer.borderWidth = 1
        butLogin.layer.borderColor = UIColor.clear.cgColor
        loginView.addSubview(butLogin)
    }
    
    func setupSignupButton() {
        
        if butSignup != nil {
            butSignup.removeFromSuperview()
        }
        if isSignupSupported {
            
            butSignup = UIButton(frame: CGRect(x: 0, y: bottomTxtPasswordView.frame.maxY + 30 + 40, width: loginView.frame.width, height: 40))
            let font = UIFont(name: "HelveticaNeue-Medium", size: 12)!
            let titleString = NSAttributedString(string: "Don't have an account? Sign up", attributes: [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.white])
            butSignup.setAttributedTitle(titleString, for: .normal)
            butSignup.alpha = 0.7
            
            butSignup.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
            loginView.addSubview(butSignup)
        }
    }
    
    func setupAlert() {
        
            labelAlert = UILabel(frame: CGRect(x: 0, y: butSignup.frame.maxY + 10, width: loginView.frame.width, height: 40))
            let fontAlert = UIFont(name: "HelveticaNeue-Medium", size: 14)!
            labelAlert.font = fontAlert
            labelAlert.textColor = UIColor.white
            labelAlert.alpha = 1
            labelAlert.textAlignment = NSTextAlignment.center
            loginView.addSubview(labelAlert)
    }
    
    
    
    
    // MARK: Button Handlers
    
    @objc func sendTapped() {
        
        let type = isLogin ? SendType.Login : SendType.Signup
        let username = self.txtUsername.text!
        let password = self.txtPassword.text!
        let email = self.txtEmail.text!
        
        self.butLogin.startAnimate(spinnerType: SpinnerType.ballClipRotate, spinnercolor: UIColor.white, spinnerSize: 25, complete:nil)
        
        // Check password count
        
        if password.count < 6 {
            
            self.butLogin.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .fail, backToDefaults: true, complete:nil)
            self.displayError(error: "The password must contain at least 6 characters")
            
        } else {
            
            if type == .Login {
                
                // SignIN call
                DataAccess.shared.signInRequest(username: username, password: password) { (success, error) in
                    
                    if success == true {
                        
                        print("User signIN Done !")
                        
                        self.butLogin.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .success, backToDefaults: false, complete:nil)
                        self.perform(#selector(self.gotoHomeViewController), with: nil, afterDelay: 1.5)
                        
                    } else {
                        
                        self.butLogin.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .fail, backToDefaults: true, complete:nil)
                        self.displayError(error: error)
                        
                    }
                }
                
                
            } else {
                
                // SignUP call
                
                DataAccess.shared.signUpRequest(username: username, email: email, password: password) { (success, error) in
                        
                    if success == true {
                        
                        print("User signUP Done !")
                        
                            self.butLogin.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .success, backToDefaults: false, complete:nil)
                            self.perform(#selector(self.loginViewAnimation), with: nil, afterDelay: 1.5)
                        
                    } else {
                        
                        self.butLogin.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .fail, backToDefaults: true, complete:nil)
                        self.displayError(error: error)
                        
                    }
                        
                }
            
            }
        }
    }
    
    // MARK: Permission and present imagePicker method
    
    @objc func pressUpload(){
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        self.perform(#selector(self.checkPermission), with: nil, afterDelay: 0.5)
    }
    
    func selectPhotoFromGallery() {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    @objc func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    self.selectPhotoFromGallery()
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }
    
    
    @objc func signupTapped() {
        toggleLoginSignup()
    }
    
    func toggleLoginSignup() {
        
        isLogin = !isLogin
        
        UIView.animate(withDuration: 0.5, animations: {
            self.butLogin.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.butLogin.alpha = 1
            })
        })
        
        txtUsername.text = ""
        
        if isLogin {
            UIView.animate(withDuration: 0.5, animations: {
                self.txtEmail.alpha = 0
                self.imgvEmailIcon.alpha = 0
                self.bottomTxtEmailView.alpha = 0
                
                let rect = CGRect(origin: CGPoint(x: self.loginView.frame.origin.x, y: self.loginView.frame.origin.y - 30), size: self.loginView.frame.size)
                self.loginView.frame = rect
            })
            
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.txtEmail.alpha = 1
                self.imgvEmailIcon.alpha = 1
                self.bottomTxtEmailView.alpha = 0.5
                
                let rect = CGRect(origin: CGPoint(x: self.loginView.frame.origin.x, y: self.loginView.frame.origin.y + 30), size: self.loginView.frame.size)
                self.loginView.frame = rect
            })
        }
        
        
        
        
        let login = isLogin ? "Login" : "Signup"
        self.butLogin.setTitle(login, for: .normal)
        
        let signup = isLogin ? "Don't have an account? Sign up" : "Have an account? Login"
        
        let font = UIFont(name: "HelveticaNeue-Medium", size: 12)!
        let titleString = NSAttributedString(string: signup, attributes: [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.white])
        self.butSignup.setAttributedTitle(titleString, for: .normal)
        
    }
    
    // MARK: - Navigation
    
    @objc func gotoHomeViewController() {
        self.performSegue(withIdentifier: "gotoHomeView", sender: nil)
    }
    
    @objc func loginViewAnimation() {
        UIView.animate(withDuration: 0.7, animations: {
            self.view.layoutIfNeeded()
            self.loginView.frame = CGRect(origin: CGPoint(x: -(self.loginView.frame.size.width), y: self.loginView.frame.origin.y), size: self.loginView.frame.size)
            self.pictureView.frame = CGRect(origin: CGPoint(x: 20, y: self.loginView.frame.origin.y), size: self.view.frame.size)
            self.view.setNeedsLayout()
        })
    }
    
    // MARK: - Display Error
    
    func displayError(error: String) {
        
        self.labelAlert.text = error
        self.labelAlert.alpha = 1
        
        UIView.animate(withDuration: 7, animations: {
            self.labelAlert.alpha = 0
        })
    }

}





//MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.txtEmail {
            
            UIView.animate(withDuration: 1, animations: {
                
                self.bottomTxtUsernameView.alpha = 0.2
                self.imgvUserIcon.alpha = 0.2
                
                self.bottomTxtPasswordView.alpha = 0.2
                self.imgvPasswordIcon.alpha = 0.2
                
                if !self.isLogin {
                    self.bottomTxtEmailView.alpha = 1
                    self.imgvEmailIcon.alpha = 1
                }
            })
        } else if textField == txtPassword{
            
            UIView.animate(withDuration: 1, animations: {
                self.bottomTxtUsernameView.alpha = 0.2
                self.imgvUserIcon.alpha = 0.2
                
                self.bottomTxtPasswordView.alpha = 1
                self.imgvPasswordIcon.alpha = 1
                
                if !self.isLogin {
                    self.imgvEmailIcon.alpha = 0.2
                    self.bottomTxtEmailView.alpha = 0.2
                }
            })
        } else if textField == txtUsername{
            
            UIView.animate(withDuration: 1, animations: {
                
                self.bottomTxtPasswordView.alpha = 0.2
                self.imgvPasswordIcon.alpha = 0.2
                
                self.bottomTxtUsernameView.alpha = 1
                self.imgvUserIcon.alpha = 1
                
                if !self.isLogin {
                    self.imgvEmailIcon.alpha = 0.2
                    self.bottomTxtEmailView.alpha = 0.2
                }
                
            })
        }
        
    }
    
    
    // Dealing with return key on keyboard
    public func textFieldShouldReturn(_
        textField: UITextField) -> Bool {
        if textField == txtEmail {
            
            self.txtPassword.becomeFirstResponder()
        } else {
            
            self.txtPassword.resignFirstResponder()
        }
        return true
    }
}


// MARK: - UIImagePickerControllerDelegate

extension LoginViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        picker.dismiss(animated: true, completion: nil)
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            
            // start button animation on Main thread
            DispatchQueue.main.async {
                
                self.uploadButton.startAnimate(spinnerType: SpinnerType.ballClipRotate, spinnercolor: UIColor.white, spinnerSize: 25, complete:nil)
            }
            
            DispatchQueue.global(qos: .background).async {
                
            // Call upload picture request
            DataAccess.shared.uploadPicture(profilePic: editedImage) { (check) in
            
                if check == true {
                    
                    // Stop button animation on Main thread and update UI
                    DispatchQueue.main.async {
                        
                        self.uploadButton.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .success, backToDefaults: true, complete: {
                            self.pictureImageView.image = editedImage
                            self.uploadButton.setTitle("Let's go", for: UIControlState.normal)
                            self.uploadButton.removeTarget(nil, action: nil, for: .allEvents)
                            self.uploadButton.addTarget(self, action: #selector(self.gotoHomeViewController), for: .touchUpInside)
                        })
                    }
                    
                } else {
                    DispatchQueue.main.async {
                    self.uploadButton.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .fail, backToDefaults: true, complete:nil)
                    }
                }
            }
          }
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.uploadButton.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .fail, backToDefaults: true, complete:nil)
        self.dismiss(animated: true, completion: nil)
    }
}





