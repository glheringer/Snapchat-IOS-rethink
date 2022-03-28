//
//  ViewController.swift
//  Snapchat
//
//  Created by Rethink on 23/03/22.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let auth = Auth.auth()
//        do {
//            try auth.signOut()
//        } catch  {
//            print("Erro ao deslogar usuario")
//        }
//        
        auth.addStateDidChangeListener { (auth, user) in //ouvinte
            if user != nil {
                self.performSegue(withIdentifier: "autoLoginSegue", sender: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }


}

