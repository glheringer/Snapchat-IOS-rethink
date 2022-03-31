//
//  SnapViewController.swift
//  Snapchat
//
//  Created by Rethink on 24/03/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SnapViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var snaps: [Snap] = []
    
    @IBOutlet weak var tableView: UITableView!
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
        
        let auth = Auth.auth()
        if let loggedUserID = auth.currentUser?.uid{
            
            let database = Database.database().reference()
            let users = database.child("usuarios")
            let snaps = users.child(loggedUserID).child("snaps")
            
            //Criar ouvinte para snaps
            snaps.observe(DataEventType.childAdded, with:  { (snapshot) in
                
                let data = snapshot.value as? NSDictionary //captura os valores e atribui ao data
               
                let snap = Snap() //criado objeto do tipo Snap
                
                //Inicializacao do snap
                snap.identifier = snapshot.key
                snap.name = data?["name"] as! String
                snap.description = data?["description"] as! String
                snap.urlImage = data?["urlImage"] as! String
                snap.idImage = data?["idImage"] as! String
                    
                self.snaps.append(snap) // Adicionando snap ao array de snaps
                self.tableView.reloadData() //recarregar os dados
            })
            
            //Adiciona evento para item removido, remover da tabela apos o snap for apagado no banco
            snaps.observe(DataEventType.childRemoved, with:  { (snapshot) in
                
                var index = 0
                for snap in self.snaps{
                    
                    if snap.identifier == snapshot.key{
                        
                        self.snaps.remove(at: index)
                    }
                    index = index + 1
                }
                
                self.tableView.reloadData()
            })
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let totalSnaps = snaps.count
        if totalSnaps == 0 {
            return 1
        }
        return totalSnaps
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath)
        let totalSnaps = snaps.count
        if totalSnaps == 0 {
            cell.textLabel?.text = "Nenhum snap para você :) "
        }
        else{
            let snaps = self.snaps[indexPath.row]
            cell.textLabel?.text = snaps.name
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //se a linha for selecionada
        
        let totalSnaps = snaps.count
        if totalSnaps > 0 {
            let snap = self.snaps[indexPath.row]
            self.performSegue(withIdentifier: "snapDetailsSegue", sender: snap)
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "snapDetailsSegue"{
            let snapDetailsViewController = segue.destination as! SnapDetailsViewController
            snapDetailsViewController.snap = sender as! Snap
            
        }
    }
}
