//
//  ViewController.swift
//  makeTwet
//
//  Created by Angel alberto Bernechea on 2/9/24.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var butonInicio: UIButton!
    @IBOutlet weak var titleWelcome: UILabel!
    
    let data = ApiPostManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stupUI()
//        data.getAllPost()
//        print("__________________")
//        data.getPost(id: 1)
//        print("__________________")
//        data.getPost(id: 0)
    }
    private func stupUI(){
        print("hola desde stup")
        
        
    }

}

