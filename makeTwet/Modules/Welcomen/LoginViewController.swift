//
//  LoginViewController.swift
//  makeTwet
//
//  Created by Angel alberto Bernechea on 2/9/24.
//

import UIKit

class LoginViewController: UIViewController {
    // MARK: - Outlet
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func buttonLoging(){
        userLogin()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    // MARK: - Private Actions
    private func   userLogin(){
        guard let user = userName.text, !user.isEmpty else {
            return
        }
        
        
    }
    

   

}
