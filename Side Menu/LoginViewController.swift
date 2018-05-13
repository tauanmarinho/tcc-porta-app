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
    var acesso:Bool = false
    
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
    
    func getToken(url: String, parameters: [String: String]){
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
            response in
            if response.result.isSuccess {
                let dataJSON : JSON = JSON(response.result.value!)
                print("sucess")
                print(dataJSON)
                self.acesso = self.updateToken(json: dataJSON)
            } else {
                print("Error \(String(describing: response.result.error))")
                self.statusConnection = "Erro de conexão"
                self.actionLogin(mensagem: self.statusConnection)
            }
        }
    }
    
    func updateToken (json: JSON) -> Bool{
        var tokenResult:String = ""
        var accessResult:Bool = false
        if json["data"]["token"].exists() == true {
            tokenResult = json["data"]["token"].description
            let saveToken: Bool = KeychainWrapper.standard.set(tokenResult, forKey: "tokenResult")
            accessResult = true
            let access: Bool = KeychainWrapper.standard.set(accessResult, forKey: "accessResult")
            print (access)
            print(saveToken)
            print(tokenResult)
            return true
        } else {
            accessResult = false
            let access: Bool = KeychainWrapper.standard.set(accessResult, forKey: "accessResult")
            print (access)
            self.actionLogin(mensagem: "Erro na senha/e-mail")
            return false
        }
    }
    
    
    @IBAction func loginUser(_ sender: Any) {
    
        user.userEmail = emailTextField.text!
        user.userKey = passwordTextField.text!
        
        var parameters = [String: String]() //Dicionario
        
        if (validateEmail(candidate: user.userEmail)){
            parameters["email"] = user.userEmail
        } else {
            actionLogin(mensagem: "Insira seu e-mail")
            return
        }

        parameters["senha"] = user.userKey
        getToken(url: URL_LOGIN, parameters: parameters)
        //print(user.userToken)
        
        if acesso != false {
            print("Acesso liberado" + user.userToken)
            user.isLogin = true
            self.dismiss(animated: true, completion: nil)
            self.viewDidAppear(true)
        } else {
            print("Acesso recusado")
        }
        
    }
    
    
}
