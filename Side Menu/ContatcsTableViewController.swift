//
//  ContactsTableViewController.swift
//  tccPortaEletronica
//
//  Created by Tauan Marinho on 23/04/2018.
//  Copyright © 2018 Tauan Marinho. All rights reserved.
//
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import UIKit

class ContactsTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var table: UITableView!
    
    var nomes: [String] = []
    var telefone: [String] = []
    var email: [String] = []
    
    let URL_CONTACTS: String = "https://portaeletronica-api.herokuapp.com/api/usuarios/estabelecimento"
    var confirmado:Int = 0
    var currentNomes = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveToken: String? = KeychainWrapper.standard.string(forKey: "tokenResult")
        let headers = [
            "Authorization": "Bearer " + saveToken!
        ]
        print("Enviado request")
        Alamofire.request(URL_CONTACTS, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
            if response.result.isSuccess {
                print("sucess request")
                if let value = response.result.value {
                    let dataJSON = JSON(value)
                    
                    print(dataJSON)
                    
                    for x in 0..<dataJSON.count {
                        self.nomes.append(dataJSON[x]["nome"].stringValue)
                        self.telefone.append(dataJSON[x]["telefone"].stringValue)
                        self.email.append(dataJSON[x]["email"].stringValue)
                    }
                    
                    print("recebido e setado")
                    
                    //print(self.nomes)
                    //print(self.horario)
                    self.currentNomes = self.nomes
                    self.setSearchBar()
                    self.table.reloadData()
                }
            } else {
                self.actionLogin(mensagem: "Problemas de conexão")
                print("error request")
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func setSearchBar() {
        searchBar.delegate = self
    }
    
    private func setDataJson(){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currentNomes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CelulaReuso = "CelulaReuso"
        let cell = tableView.dequeueReusableCell(withIdentifier: CelulaReuso, for: indexPath) as! CallTableViewCell
        NSLog("Can anyone hear me?")
        
        cell.shareButton.tag = indexPath.row
        cell.shareButton.addTarget(self, action:#selector(callActions), for: .touchUpInside)
        cell.Label.text = nomes[indexPath.row]
        cell.subLabel.text = telefone[indexPath.row] + " " + email[indexPath.row]
        
        return cell
    }
    
    @IBAction func callActions(sender: UIButton){
        let alerta = UIAlertController(title: "Ligação", message: "Deseja ligar", preferredStyle: .alert)
        
        let confirmar = UIAlertAction(title: "Confirmar", style: .default) { (acao) in
            
            self.confirmado = 1
            NSLog("Ligando")
            let url : NSURL = URL(string: "tel://41992558502")! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .destructive) { (acaoCancelar) in
            self.confirmado = 0
            NSLog("Desligado")
        }
        
        alerta.addAction(confirmar)
        alerta.addAction(cancelar)
        present(alerta, animated: true, completion: nil)

    }
    
    //Search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentNomes = nomes
            table.reloadData()
            return
        }
        
        currentNomes = nomes.filter({nome -> Bool in
            nome.lowercased().contains(searchText.lowercased())
        })
        table.reloadData()
    }
    
    func actionLogin(mensagem: String){
        let alerta = UIAlertController(title: "Erro", message: mensagem, preferredStyle: .alert)
        
        let confirmar = UIAlertAction(title: "Ok", style: .default) { (acao) in
            NSLog("ok")
        }
        
        alerta.addAction(confirmar)
        present(alerta, animated: true, completion: nil)
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
