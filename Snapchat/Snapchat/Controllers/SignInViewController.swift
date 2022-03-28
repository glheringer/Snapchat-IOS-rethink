//
//  SignInViewController.swift
//  Snapchat
//
//  Created by Rethink on 23/03/22.
//

import UIKit
import Firebase
class SignInViewController: UIViewController {

    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    var alert : Alert!
    @IBAction func signIn(_ sender: Any) {
        if let email = self.emailTxtField.text{
            if let password = self.passwordTxtField.text{
                Auth.auth().signIn(withEmail: email, password: password) { (user, erro) in
                    if erro == nil{ //Após nao ter erro, sucesso ao logar entao encaminha o usuaria à tela principal do sistema
                        if user != nil {
                            self.performSegue(withIdentifier: "loginSegue", sender: nil)
                        }
                        else{
                            
                            //Exibindo alerta com a mensagem do erro
                            self.alert = Alert(title: "Erro ao autenticar!", message:"Tente novamente.")
                            self.present(self.alert.getAlert(), animated: true, completion: nil)
                        }
                    }
                    else{
                    
                        //Exibindo alerta com a mensagem do erro
                        self.alert = Alert(title: "Dados incorretos!", message: "Dados digitados nao são inválidos.")
                        self.present(self.alert.getAlert(), animated: true, completion: nil)
                        
                    }
                }
            }
        }
    }
                                               
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

   

}
