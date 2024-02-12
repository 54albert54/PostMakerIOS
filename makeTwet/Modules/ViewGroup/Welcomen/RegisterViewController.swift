//
//  RegisterViewController.swift
//  makeTwet
//
//  Created by Angel alberto Bernechea on 2/9/24.
//

import UIKit
import NotificationBannerSwift
import Simple_Networking
import SVProgressHUD

class RegisterViewController: UIViewController {
    // MARK: - Outlet
    
    @IBOutlet weak var registerUserName: UITextField!
    
    @IBOutlet weak var registerNameLastName: UITextField!
    
    @IBOutlet weak var registerPassword: UITextField!
    
    
    @IBOutlet weak var confirmPassword: UITextField!
    
    
    @IBAction func addNewUser() {
        userRegister()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Private Actions
    private func   userRegister(){
        guard let user = registerUserName.text, !user.isEmpty else {
            NotificationBanner(title: "Error",subtitle: "Debes agregar UserName",style: BannerStyle.warning).show()
            return
        }
        guard let nameLastName = registerNameLastName.text, !nameLastName.isEmpty else {
            NotificationBanner(title: "Error",subtitle: "Debes agregar nombres",style: BannerStyle.warning).show()
            return
        }
        guard let password = registerPassword.text, !password.isEmpty else {
            NotificationBanner(title: "Error",subtitle: "Debes agregar Password",style: BannerStyle.warning).show()
            return
        }
        guard let secondPassword = confirmPassword.text, !secondPassword.isEmpty else {
            NotificationBanner(title: "Error",subtitle: "Debes agregar confir Password",style: BannerStyle.warning).show()
            return
        }
        
        
        SVProgressHUD.show()
        let request = NewUserRequest(name: nameLastName, password: password, secondPassword: secondPassword, userName: user)
        
        
        SN.post(endpoint: EndPoin.addUserUrl, model: request) { (response: SNResult<NewUserResponse>) in
            switch response {
            case .error:
                
                NotificationBanner(subtitle: "Error User o Password incorrectas",style: BannerStyle.danger).show()
                
                SVProgressHUD.dismiss()
            case .success(let data ):
                let infoUser = data as NewUserResponse
                
                
                let request = AuthUser(userName: infoUser.body.newDataUser.userName , password: infoUser.body.newDataUser.password)
                
                SN.post(endpoint: EndPoin.authUrl, model: request) { (response: SNResult<AuthUserResponse>) in
                    switch response {
                    case .error:
                        NotificationBanner(subtitle: "Error User o Password incorrectas",style: BannerStyle.danger).show()

                    case .success(let data ):
                        let user: AuthUserResponse = data as AuthUserResponse
                        SimpleNetworking.setAuthenticationHeader(prefix: "Bearer", token: user.body.token)
                        // pasar a la app
                        SVProgressHUD.dismiss()
                        NotificationBanner(subtitle: "Bienvenido ",style: BannerStyle.success).show()
                        // pasar a la app
                        self.performSegue(withIdentifier: "showHome", sender: nil)
                        
                        
                        
                    }
                }
                
            }
        }
        
        
        
    }
    
    
}
