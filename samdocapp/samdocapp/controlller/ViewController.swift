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
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
 

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
        
        state = .loggedout
    }
    
   
    
    @IBAction func TapButton(_ sender: UIButton) {
        
       // let userName = userNameTextField.text
           let context = LAContext()
           let password = passwordTextField.text ?? ""
              context.setCredential(Data(password.utf8), type: .applicationPassword)
              //let data = KeychainHelper.loadPassProtected(key: self.entryName, context: context)
        
        
        /*if (userName = "" || password = "")
        {
            return
        }*/
    }
    

    
    
    static func getPwSecAccessControl() -> SecAccessControl {
        var access: SecAccessControl?
        var error: Unmanaged<CFError>?
        
        access = SecAccessControlCreateWithFlags(nil,
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            .applicationPassword,
            &error)
        precondition(access != nil, "SecAccessControlCreateWithFlags failed")
        return access!
    }
    
    static func createEntry(key: String, data: Data, password: String) -> OSStatus {
        let context = LAContext()
        context.setCredential(password.data(using: .utf8), type: .applicationPassword)
        
        let query = [
            kSecClass as String            : kSecClassGenericPassword as String,
            kSecAttrAccount as String      : key,
            kSecAttrAccessControl as String: getPwSecAccessControl(),
            kSecValueData as String        : data as NSData,
            kSecUseAuthenticationContext   : context] as CFDictionary
        
        return SecItemAdd(query, nil)
    }
    
    static func loadPassProtected(key: String, context: LAContext? = nil) -> Data? {
        var query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue,
            kSecAttrAccessControl as String: getPwSecAccessControl(),
            kSecMatchLimit as String  : kSecMatchLimitOne]
        
        if let context = context {
            query[kSecUseAuthenticationContext as String] = context
            
            // Prevent system UI from automatically requesting password
            // if the password inside supplied context is wrong
            query[kSecUseAuthenticationUI as String] = kSecUseAuthenticationUIFail
        }
        
        var dataTypeRef: AnyObject? = nil
        
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr {
            return (dataTypeRef! as! Data)
        } else {
            return nil
        }
    }
}

