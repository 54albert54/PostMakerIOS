//
//  LoginViewController.swift
//  makeTwet
//
//  Created by Angel alberto Bernechea on 2/9/24.
//

import UIKit
import NotificationBannerSwift
import Simple_Networking
import SVProgressHUD

class LoginViewController: UIViewController {
    // MARK: - Outlet
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func buttonLoging(){
        userLogin()
        
    }
    
    @IBAction func LoginFast(_ sender: Any) {
        self.userName.text = "adm"
        self.password.text = "123456"
        userLogin()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    // MARK: - Private Actions
    private func   userLogin(){
        guard let user = userName.text, !user.isEmpty else {
            NotificationBanner(title: "Error",subtitle: "Debes agregar UserName",style: BannerStyle.warning).show()
            return
        }
        guard let pass = password.text, !pass.isEmpty else {
            NotificationBanner(title: "Error",subtitle: "Debes agregar Password",style: BannerStyle.warning).show()
            return
        }
        //authUrl
        SVProgressHUD.show()
        
        let request = AuthUser(userName: user, password: pass)
        
        SN.post(endpoint: EndPoin.authUrl, model: request) { (response: SNResult<AuthUserResponse>) in
            switch response {
            case .error(let error):
                NotificationBanner(subtitle: "Error User o Password incorrectas",style: BannerStyle.danger).show()
                    SVProgressHUD.dismiss()
                    self.userName.text = ""
                    self.password.text = ""
                
                print(error)
              
            case .success(let data ):
                let user: AuthUserResponse = data as AuthUserResponse
                NotificationBanner(subtitle: "Bienvenido \(user.body.showData.name)",style: BannerStyle.success).show()
                SimpleNetworking.setAuthenticationHeader(prefix: "Bearer", token: user.body.token)
                // pasar a la app
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "showHome", sender: nil)
                
                
                
            }
        }
        
       


        
    }
    
    
    

   

}
