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
    
    private let storage = UserDefaults.standard
    @IBOutlet weak var saveData: UISwitch!
    let myStorage = UserAuth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userSaved = myStorage.getDataStore(.userName), let passSaved = myStorage.getDataStore(.userPassword){
            self.userName.text = userSaved
            self.password.text = passSaved
            saveData.isOn = false
        }

        
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
        
        
        if saveData.isOn {
            myStorage.saveDataStore(dato: pass , key: .userPassword)
        }
        // MARK: -authUrl
        SVProgressHUD.show()
        
        let request = AuthUser(userName: user, password: pass)
        SN.post(endpoint: EndPoin.authUrl, model: request) { (response: SNResult<AuthUserResponse>) in
            switch response {
            case .error:
                NotificationBanner(subtitle: "Error User o Password incorrectas",style: BannerStyle.danger).show()
                SVProgressHUD.dismiss()
                self.userName.text = ""
                self.password.text = ""
                
            case .success(let data ):
                let user: AuthUserResponse = data as AuthUserResponse
                NotificationBanner(subtitle: "Bienvenido \(user.body.showData.name)",style: BannerStyle.success).show()
                SimpleNetworking.setAuthenticationHeader(prefix: "Bearer", token: user.body.token)
                //salvar los datos en local storage
                
                self.myStorage.saveDataStore(dato: user.body.showData.userName , key: .userName)
                // pasar a la app
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "showHome", sender: nil)
                
                
                
            }
        }
        
        
        
        
        
    }
    
    
    
    
    
    
}
