//
//  LoginViewController.swift
//  tccPortaEletronica
//
//  Created by Tauan Marinho on 23/04/2018.
//  Copyright © 2018 Tauan Marinho. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

class LoginViewController: UIViewController {
    
    let URL_LOGIN: String = "https://portaeletronica-api.herokuapp.com/token/usuario"
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let user = User()
    var confirmado:Int = 0
    var statusConnection:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    func actionLogin(mensagem: String){
        let alerta = UIAlertController(title: "Erro", message: mensagem, preferredStyle: .alert)
        
        let confirmar = UIAlertAction(title: "Ok", style: .default) { (acao) in
            NSLog("ok")
        }
        
        alerta.addAction(confirmar)
        present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func loginUser(_ sender: Any) {
        
        user.userEmail = emailTextField.text!
        user.userKey = passwordTextField.text!
        var acesso:Bool = false
        
        var parameters = [String: String]() //Dicionario
        
        if (validateEmail(candidate: user.userEmail)){
            parameters["email"] = user.userEmail
        } else {
            actionLogin(mensagem: "Insira seu e-mail")
            return
        }
        
        parameters["senha"] = user.userKey
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
            
            response in
            if response.result.isSuccess {
                print("sucess request")
                
                let dataJSON : JSON = JSON(response.result.value!)
                print(dataJSON)
                var tokenResult:String = ""
                if dataJSON["data"]["token"].exists() == true {
                    print("Exists")
                    
                    tokenResult = dataJSON["data"]["token"].description
                    let _: Bool = KeychainWrapper.standard.set(tokenResult, forKey: "tokenResult")
                    
                    acesso = true
                    let _: Bool = KeychainWrapper.standard.set(acesso, forKey: "accessResult")
                    
                    print("Enviado")
                    print("Acesso liberado")
                    
                    self.dismiss(animated: true, completion: nil)
                    self.viewDidAppear(true)
                } else {
                    acesso = false
                    let access: Bool = KeychainWrapper.standard.set(acesso, forKey: "accessResult")
                    print (access)
                    
                    self.actionLogin(mensagem: "Erro na senha/e-mail")
                    print("Enviado")
                    print("Acesso recusado")
                }
                
            } else {
                print("Error \(String(describing: response.result.error))")
                
                self.statusConnection = "Erro de conexão"
                self.actionLogin(mensagem: self.statusConnection)
                print("Não Enviado")
            }
        }
    }
}
