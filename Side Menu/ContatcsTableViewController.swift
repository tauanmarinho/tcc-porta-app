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
    
    var nomes: [String] = ["Tauan Marinho", "Tiago Maniane", "Luiz Kim", "Tiago Faxina"]
    var Telefone: [String] = ["(41) 93923-0930", "(41) 93923-0930", "(41) 93923-0930", "(41) 93923-0930"]
    
    let URL_CONTACTS: String = "https://portaeletronica-api.herokuapp.com/api/usuarios/estabelecimento"
    let user = User()
    var confirmado:Int = 0
    var currentNomes = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getData(url: URL_CONTACTS)
        currentNomes = nomes
        setSearchBar()

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
    
    func getData(url: String){
        //let list: Array<JSON> = json["list"].arrayValue
        let saveToken: String? = KeychainWrapper.standard.string(forKey: "tokenResult")
        print(saveToken!)
        let headers = [
            "Authorization": "Bearer " + saveToken!
        ]
        print(headers)
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            let dataJSON : Array<JSON> = [JSON(response.result.value!)]
            if response.result.isSuccess {
                print("sucess")
                print(dataJSON)
                
                //print(dataJSON["telefone"].arrayValue)
               
                //print(dataJSON["nome"].arrayValue)
               
                
            } else {
                print("errors")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CelulaReuso = "CelulaReuso"
        let cell = tableView.dequeueReusableCell(withIdentifier: CelulaReuso, for: indexPath) as! CallTableViewCell
        NSLog("Can anyone hear me?")
        
        cell.shareButton.tag = indexPath.row
        cell.shareButton.addTarget(self, action:#selector(callActions), for: .touchUpInside)
        cell.Label.text = nomes[indexPath.row]
        cell.subLabel.text = Telefone[indexPath.row]
        
        
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
