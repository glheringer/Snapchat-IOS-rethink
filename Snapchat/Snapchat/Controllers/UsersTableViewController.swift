//
//  UsersTableViewController.swift
//  Snapchat
//
//  Created by Rethink on 28/03/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class UsersTableViewController: UITableViewController {
    
    var users : [User] = []
    var photoDescription = ""
    var imageId = ""
    var url  = "" 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let database = Database.database().reference()
        let users = database.child("usuarios")
        
        users.observe(DataEventType.childAdded) { (snapshot) in //criar um listener para cada vez que um evento de usuario adicionado for disparado
        
             
            let data = snapshot.value as? NSDictionary //transformando os dados do snapshot em dicionario
            //Recuperando dados do usuario a partir do snapshot
            let userEmail = data!["email"] as! String
            let userName = data!["nome"] as! String
            let userID = snapshot.key
            
            //Criando usuario
            let user = User(name: userName, email: userEmail, uid: userID)
            
            //Adicionando ao array de usuarios
            self.users.append( user )
            
            //Recarregar a classe para o array ser populado
            self.tableView.reloadData()
        }
    }

    

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath)
        
        let user = self.users[indexPath.row] //recuperando array na posicao do indexpath
        cell.textLabel?.text = user.name //exbindo o nome do usuario na tabela
        cell.detailTextLabel?.text = user.email
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = self.users[indexPath.row]
        let IDselectedUser = selectedUser.uid
        
        let database = Database.database().reference()
        let users = database.child("usuarios")
        
        let snaps = users.child(IDselectedUser).child("snaps")
        
        //Recuperar dados do usuario logado
        let auth = Auth.auth()
        
        if let IDloggedUser = auth.currentUser?.uid{ //pegando ID do usuario logado
            
            let loggedUser = users.child(IDloggedUser) //Apontando usuario logado pelo ID
            loggedUser.observeSingleEvent(of: DataEventType.value) { (snapshot) in //recuperando dados do usuario logado
                
                let data = snapshot.value as? NSDictionary // transformando dados em dicionario
                
                let snap = [
                    "from": data!["email"] as? String, //adicionando no snap dados do dicionario, que corresponde aos dados do usuario logado
                    "name": data!["nome"] as? String,
                    "description": self.photoDescription,
                    "urlImage": self.url,
                    "idImage": self.imageId
                ]
                snaps.childByAutoId().setValue(snap) //childByAutoID gera uma key  unica e diferente para o nó desejado
                
            }
        }
       
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

}
