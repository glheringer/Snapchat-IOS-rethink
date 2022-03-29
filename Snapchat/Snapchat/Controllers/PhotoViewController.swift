//
//  PhotoViewController.swift
//  Snapchat
//
//  Created by Rethink on 24/03/22.
//

import UIKit
import FirebaseStorage

class PhotoViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
  
    let imagePicker = UIImagePickerController()
    
    //criamos um ID para o nome da imagem.
    var imageId = NSUUID().uuidString
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var photoDescription: UITextField!
    
    @IBAction func selectPhoto(_ sender: Any) {
        
        imagePicker.sourceType = .savedPhotosAlbum // . camera para usar a camera do usuario, para ele tirar a foto usando sua camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func next(_ sender: Any) {
        
        nextButton.isEnabled = false
        nextButton.setTitle("Carregando...", for: .normal)
        
        //Estamos apotando para a raiz do Storage no firebase
        let storage = Storage.storage().reference()
        
        //Funciona parecido com o armazenamento da dados, so que aqui nao estamos criando um nó e sim uma pasta
        let imagesFolder = storage.child("imagens")
        
        //Aqui nos damos o nome a imagem que vai ser salva que no caso sera um ID
        let imagesFile = imagesFolder.child("\(self.imageId).jpg")
        
        //Recuperar imagem para enviar para o Banco
        if let recoveredImage = image.image {
       
            //convertendo imagem de modo ao firebase entendela
            if let imageData = recoveredImage.jpegData(compressionQuality: 0.5){
                
                //enviando a imagem para o firebase
                imagesFile.putData(imageData, metadata: nil) { (metaData, erro) in
                    if erro == nil{
                        //recuperando a url da imagem que foi upada
                        imagesFile.downloadURL(completion: { (url, error) in

                            if let urlR = url?.absoluteString {

                                //mandando o usuario para tela de lista de usuarios, e passando a URL para ser recuperada la
                                self.performSegue(withIdentifier: "selectUserSegue", sender: urlR)


                            }

                        })
                        //voltar o botao para "Proximo"
                        self.nextButton.isEnabled = true
                        self.nextButton.setTitle("Proximo", for: .normal)
                    }
                    else{
                        print("Deu erro cara \(String(describing: erro?.localizedDescription))")
                    }
                }
            }
            
        }
    
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "selectUserSegue"{
            
            let userViewController = segue.destination as! UsersTableViewController
            
            userViewController.photoDescription = self.photoDescription.text!
            userViewController.imageId = self.imageId
            userViewController.url = sender as! String
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        let recoveredImage = info [ UIImagePickerController.InfoKey.originalImage ] as! UIImage
        
        image.image = recoveredImage
        //Habilitando Botao Proximo
        self.nextButton.isEnabled = true
        self.nextButton.backgroundColor = UIColor(displayP3Red: 0.553, green: 0.369, blue: 0.749, alpha: 1)
        
        //o dismiss pra sair da tela de selecao depois que o usuario selecionar a foto
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        
    }
    
}
