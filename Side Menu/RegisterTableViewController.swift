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
    
    var nomes: [String] = ["Tauan Marinho", "Tiago Maniane", "Luiz Kim", "Tiago Faxina"]
    var portas: [String] = ["Porta 1", "Porta 11", "Porta 2", "Porta 11"]
    var horario: [String] = ["10:17:54", "13:13:54", "08:57:54", "16:51:22"]
    let URL_LOGS: String = "https://portaeletronica-api.herokuapp.com/api/logs?page=1&linesPerPage=10&direction=ASC"
    
    @IBOutlet var table: UITableView!
    var currentNomes = [String]()
    @IBOutlet var searchBar:UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        getData(url: URL_LOGS)
        currentNomes = nomes
        setSearchBar()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
            } else {
                print("errors")
            }
        }
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
        cell.detailTextLabel?.text = horario[indexPath.row] + " " + portas[indexPath.row]

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
