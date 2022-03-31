//
//  SnapDetailsViewController.swift
//  Snapchat
//
//  Created by Rethink on 29/03/22.
//

import UIKit
import SDWebImage
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class SnapDetailsViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var timer: UILabel!
    
    var snap = Snap ()
    var time = 11
    
    override func viewDidLoad() {
        super.viewDidLoad()
        details.text = "Carregando... " //setando descricao para carregando
        
        let url = URL(string: snap.urlImage) //setando url para passar ao metodo do pod , url vinda da classe snap criada anteriormejte
        image.sd_setImage(with: url) { image, erro, cache, url in //pod instalado para carregar imagem e armazena-la em cache
             
            if erro == nil{ //testando erro
                self.details.text = self.snap.description //setando descricao realmente com valor
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in //criando timer para executar acao a cada 1 segundo
                    
                    self.time = self.time - 1 //decrementando tempo
                    
                    //exibir timer na tela
                    self.timer.text = String(self.time)
                    
                    if self.time == 0 {
                        timer.invalidate()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
               
            }
        }
    
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        let auth = Auth.auth()
//
//        if let loggedUserId = auth.currentUser?.uid{
//
//            //Remover nó do Database
//            let database = Database.database().reference()
//            let users = database.child("usuarios")  //acessando nó usuarios
//            let snaps = users.child(loggedUserId).child("snaps")// acessando nó snaps
//
//            snaps.child(self.snap.identifier).removeValue()//acessando o snap especificamente e removendo valor ( o apagando)
//
//            //Remover imagem do Storage
//            let storage = Storage.storage().reference()
//            let images = storage.child("imagens")
//
//                    images.child("\(self.snap.idImage).jpg").delete { erro in  //acessando a imagem especificamente e removendo valor ( a apagando)
//                        if erro == nil{
//                            print("Sucesso ao excluir imagem")
//                        }
//                        else{
//                            print("Falha ao excluir imagem")
//                        }
//                    }
//    }
//    }
    


}
