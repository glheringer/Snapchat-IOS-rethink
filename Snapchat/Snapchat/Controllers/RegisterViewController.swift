//
//  RegisterViewController.swift
//  Snapchat
//
//  Created by Rethink on 23/03/22.
//

import UIKit
import Firebase
import FirebaseDatabase
class RegisterViewController: UIViewController {
    
    let firebase = Database.database().reference()
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var confirmPasswordTxtField: UITextField!
    
    @IBAction func registerUser(_ sender: Any) {
        
        if let email = self.emailTxtField.text{
            if let name = self.name.text{
                if let password = self.passwordTxtField.text{
                    if let confirmPassword = self.confirmPasswordTxtField.text{
                        
                        if password == confirmPassword{ // validacao se as senhas sao iguais
                            if name != "" { //validacao se o nome foi preenchido
                                
                                Auth.auth().createUser(withEmail: email, password: password) { (user, erro) in //criar conta no firebase
                                    if erro == nil{
                                        if user != nil{ //Após nao ter erro, sucesso ao criar conta entao encaminha o usuaria à tela principal do sistema
                                            
                                            //Criar usuario tambem no Firebase, antes de redirecionar
                                            let database = Database.database().reference() //criando banco de dados
                                            let users = database.child("usuarios") //criando nó usuarios
                                            
                                            
                                            let userID = Auth.auth().currentUser!.uid //recuperando ID do usuario
                                            let userData = ["nome": name , "email" : email] //criando dicionario para dados do usuario
                                            
                                            users.child(userID).setValue(userData) //criando nó com o id do usuario e atribuindo dicionario userData dentro dele
                                            
                                            self.performSegue(withIdentifier: "registerLoginSegue", sender: nil) //usuario criado
                                            
                                        }
                                        else{
                                            
                                            //Exibindo alerta ao usuario
                                            let alert = Alert(title:  "Erro ao autenticar.", message: "Problema ao realizar autentitcação, tente novamente")
                                            self.present(alert.getAlert(), animated: true, completion: nil)
                                            
                                        }
                                    }
                                    else{
                                        
                                        //Tratar erros de validaçao
                                        /* Principais errros:
                                         "ERROR_INVALID_EMAIL"
                                         "ERROR_WEAK_PASSWORD"
                                         "ERROR_EMAIL_ALREADY_IN_USE"
                                         */
                                        
                                        //Para capturar o codigo exato da mensagem de erro: Transformar o erro em um Objeto especial NSError
                                        let erroR = erro! as NSError
                                        if let errorKey = erroR.userInfo["error_name"]{
                                            
                                            let errorText = errorKey as! String
                                            var message = ""
                                            
                                            switch(errorText) {
                                            case "ERROR_INVALID_EMAIL" :
                                                message = "E-mail inválido, digite um e-mail válido."
                                                break
                                                
                                            case  "ERROR_WEAK_PASSWORD" :
                                                message = "Senha precisa ter no mínimo 6 caracteres, sendo dois números."
                                                break
                                                
                                            case "ERROR_EMAIL_ALREADY_IN_USE":
                                                message = "O e-mail digitado já está em uso, cadastre outro e-mail."
                                                break
                                                
                                            default:
                                                message = "Dados digitados nao são inválidos."
                                            }
                                            //Exibindo alerta com a mensagem do erro
                                            let alert = Alert(title: "Dados digitados nao são inválidos.", message: message)
                                            self.present(alert.getAlert(), animated: true, completion: nil)
                                        }
                                        
                                        
                                    }
                                }
                            }
                            else {
                                //Exibindo alerta com a mensagem do erro
                                let alert = Alert(title: "Dados incorretos!", message: "Dados o seu nome para prosseguir.")
                                self.present(alert.getAlert(), animated: true, completion: nil)
                            }
                        }
                        else{
                            
                            //Exibindo alerta ao usuario
                            let alert = Alert(title: "Dados incorretos!", message: "As senhas digitadas precisam ser iguais. ")
                            present(alert.getAlert(), animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        
    }//Fim metodo create user
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }



}
