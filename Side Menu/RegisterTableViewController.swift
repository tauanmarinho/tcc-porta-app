//
//  RegisterTableViewController.swift
//  tccPortaEletronica
//
//  Created by Tauan Marinho on 03/05/2018.
//  Copyright © 2018 Tauan Marinho. All rights reserved.
//
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import UIKit

class RegisterTableViewController: UITableViewController, UISearchBarDelegate {
    
    var nomes: [String] = []
    var horario: [String] = []
    let ordem: String = "DESC"
    let URL_LOGS: String = "https://portaeletronica-api.herokuapp.com/api/logs?page=1&linesPerPage=20&direction="
    let URL_REFRESH: String = "https://portaeletronica-api.herokuapp.com/token/refresh"
    
    @IBOutlet var table: UITableView!
    var currentNomes = [String]()
    @IBOutlet var searchBar:UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Primeiro request
        let saveToken: String? = KeychainWrapper.standard.string(forKey: "tokenResult")
        let headers = [
            "Authorization": "Bearer " + saveToken!
        ]
        print(headers)
        
        Alamofire.request(URL_REFRESH, method: .post, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
            if response.result.isSuccess {
                print("sucess request")
                if let value = response.result.value {
                    let dataJSON = JSON(value)
                    if dataJSON["data"]["token"].exists() == true {
                        print("Exists")
                        let tokenResult = dataJSON["data"]["token"].description
                        let _: Bool = KeychainWrapper.standard.set(tokenResult, forKey: "tokenResult")
                        
                        let headersReg = [
                            "Authorization": "Bearer " + tokenResult
                        ]
                        print(headersReg)
                        
                        Alamofire.request(self.URL_LOGS + self.ordem, method: .get, encoding: JSONEncoding.default, headers: headersReg).responseJSON {
                            response in
                            
                            if response.result.isSuccess {
                                if let value = response.result.value {
                                    let dataJSON = JSON(value)
                                    
                                    for x in 0..<dataJSON["content"].count {
                                        self.horario.append(dataJSON["content"][x]["acao"].stringValue)
                                        self.nomes.append(dataJSON["content"][x]["dataHora"].stringValue)
                                    }
                                    self.currentNomes = self.nomes
                                    self.setSearchBar()
                                    self.table.reloadData()
                                }
                            } else {
                                self.actionLogin(mensagem: "Problemas de conexão")
                                print("error request")
                            }
                        }
                        
                        
                        
                    }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellsLog", for: indexPath)
        cell.textLabel?.text = nomes[indexPath.row]
        cell.detailTextLabel?.text = horario[indexPath.row]
        print (cell)
        return cell
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
