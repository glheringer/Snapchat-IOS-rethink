//
//  SnapViewController.swift
//  Snapchat
//
//  Created by Rethink on 24/03/22.
//

import UIKit
import FirebaseAuth

class SnapViewController: UIViewController {
    
    @IBAction func exit(_ sender: Any) {
        
        let auth = Auth.auth()
        do {
            try auth.signOut()
            dismiss(animated: true, completion: nil)
        } catch  {
            print("Erro ao deslogar usuario")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
