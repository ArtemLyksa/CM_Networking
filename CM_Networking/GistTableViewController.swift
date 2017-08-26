//
//  GistTableViewController.swift
//  CM_Networking
//
//  Created by Artem Lyksa on 8/26/17.
//  Copyright © 2017 Artem Lyksa. All rights reserved.
//

import UIKit

class GistTableViewController: UITableViewController {
    
    var gists = [Gist]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadGists()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    func loadGists() {
        GitHubAPIManager.sharedInstance.fetchPublicGists()
        { result in
            
            guard result.error == nil else {
                self.handleLoadGistError(result.error!)
                return
            }
            
            if let fetchedGists = result.value {
                self.gists = fetchedGists
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func handleLoadGistError(_ error: Error) {
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        let gist = self.gists[indexPath.row]
        cell.textLabel?.text = gist.description
        cell.detailTextLabel?.text = gist.ownerLogin
        
        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.gists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGistDetail" {
            if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                let gist = self.gists[selectedIndexPath.row]
                
                if let gistDetailVC = segue.destination as? GistDetailViewController {
                    gistDetailVC.detailItem = gist
                }
            }
        }
    }
 

}
