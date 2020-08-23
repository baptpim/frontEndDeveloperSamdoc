//
//  ViewController.swift
//  samdocapp
//
//  Created by Baptiste Pimont on 8/19/20.
//  Copyright © 2020 Pimont Baptiste. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
 

    var context = LAContext()

    enum AuthentificationState {
        case loggedin, loggedout
    }
    
    var state = AuthentificationState.loggedout {
        
        didSet {
            loginButton.isHighlighted = state == .loggedin
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        state = .loggedout
    }
    
    @IBAction func TapButton(_ sender: UIButton) {
        
        if state == .loggedin {

                   
                   state = .loggedout

               } else {

                   
                   context = LAContext()

                   context.localizedCancelTitle = " Username/Password"

                   
                   var error: NSError?
                   if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {

                       let reason = "Log in to your account"
                       context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in

                           if success {

                               
                               DispatchQueue.main.async { [unowned self] in
                                   self.state = .loggedin
                               }

                           } else {
                               print(error?.localizedDescription ?? "Failed to authenticate")

                               
                           }
                       }
                   } else {
                       print(error?.localizedDescription ?? "Can't evaluate policy")

                      
                   }
               }
    }
    

}

