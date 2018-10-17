//
//  DataAccess.swift
//  TOCTest
//
//  Created by Karim on 14/10/2018.
//  Copyright © 2018 Karim. All rights reserved.
//

import Foundation
import Parse

class DataAccess {
    
    // MARK: - Properties
    
    static let shared = DataAccess()
    var events = [PFObject]()
    
    // MARK: - Constants
    
    static let serverUrl = "https://eyenight-dev.herokuapp.com/parse"
    static let appId = "1TcAvt0wD6YDxEffIJ7qJtRQvMXzu7"
    static let clientKey = "XUNfi612hLNdS6V8TTb582YTou8qSX"
    
    // Initialization
    
    private init() {
    }
    
    // MARK: - SignUp request
    
    func signUpRequest(username: String, email: String, password: String, completion: @escaping (_ success :Bool, _ error: String)->()) {
        let user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        
        user.signUpInBackground {
            (success, error) -> Void in
            if let error = error {
                if let errorString = (error as NSError).userInfo["error"] as? String {
                    NSLog(errorString);
                    completion(false, errorString)
                }
            } else {
                
                // SignUp successful -> call getEventRequest
                
                self.getEventRequest(completion: { (check) in
                    
                    if check == true {
                        completion(true, "")
                    } else {
                        completion(false, "")
                    }
                })
                
            }
        }
    }
    
    // MARK: - Login request
    
    func signInRequest(username: String, password: String, completion: @escaping (_ success :Bool, _ error: String)->()) {
        
        PFUser.logInWithUsername(inBackground: username, password: password)  { (user, error) -> Void in
          
            if user != nil {
                
                // SignIn successful -> call getEventRequest
                
                self.getEventRequest(completion: { (check) in
                    
                    if check == true {
                        completion(true, "")
                    } else {
                        completion(false, "")
                    }
                })
                
            }else{
                
                if let error = error {
                    if let errorString = (error as NSError).userInfo["error"] as? String {
                        NSLog(errorString);
                        completion(false, errorString)
                    }}
            }
        }
    }
    
    // MARK: - Get events request

    func getEventRequest(completion: @escaping (Bool)->()) {
        let query = PFQuery(className: "Event")
        query.findObjectsInBackground(block: { (objects : [PFObject]?, error: Error?) -> Void in
            if error != nil {
                completion(false)
            }else{
                completion(true)
                for object in objects! {
                    print("EVENT = ", object)
                    self.events.append(object)
                }
            }
        })
    }
    
    // MARK: - Profile picture Request
    
    func uploadPicture(profilePic: UIImage, completion: @escaping (Bool)->()) {
        
        let imageData = UIImagePNGRepresentation(profilePic)
        
        do {
            let imageFile = try PFFile(name: "mypic", data: imageData!, contentType: "image/jpeg")

            PFUser.current()?.setObject(imageFile, forKey: "image")
            PFUser.current()?.saveInBackground { (result, error) in
                
                if (error == nil) {
                    
                    completion(true)
                    
                } else {
                    
                    completion(false)
                    
                    if let error = error {
                        if let errorString = (error as NSError).userInfo["error"] as? String {
                            NSLog(errorString);
                        }}
                }
            }
        } catch (_) {
            completion(false)
        }
    }
}


