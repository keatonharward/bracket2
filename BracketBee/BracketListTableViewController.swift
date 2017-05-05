//
//  BracketListTableViewController.swift
//  BracketBee
//
//  Created by Keaton Harward on 3/6/17.
//  Copyright © 2017 Keaton Harward. All rights reserved.
//

import UIKit

class BracketListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  MARK: - Make test brackets
//        let numberOfTeamsInTournament = 64
//        let numberOfTestBrackets = 10
//        var tempTeams: [String] = []
//        var counter = 1
//        while counter <= numberOfTeamsInTournament {
//            tempTeams.append("\(counter)")
//            counter += 1
//        }
//        let tempBracket = BracketController.shared.layoutBracket(teams: tempTeams, seeded: true)
//        var testBracketNumber = 1
//        while testBracketNumber <= numberOfTestBrackets {
//            let bracketTest = Bracket(name: "Test bracket \(testBracketNumber)", seeded: true, teams: tempTeams, champion: tempBracket)
//            BracketController.shared.brackets.append(bracketTest)
//            BracketController.shared.saveToPersistentStore()
//            testBracketNumber += 1
//        }
        
        // MARK: - Setup tableview
        tableView.separatorColor = Keys.shared.accent
        tableView.backgroundColor = Keys.shared.background
        self.navigationController?.navigationBar.tintColor = Keys.shared.fontColor
        self.navigationController?.navigationBar.barTintColor = Keys.shared.accent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return BracketController.shared.brackets.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bracketCell", for: indexPath)
        
        let bracket = BracketController.shared.brackets[indexPath.row]
        cell.textLabel?.text = bracket.name
        cell.textLabel?.textColor = Keys.shared.fontColor
        cell.backgroundColor = Keys.shared.alternateBackground
        
        // TODO: - Set detail text label
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            BracketController.shared.deleteFromPersistentStore(bracketPosition: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let duplicateAction = UITableViewRowAction(style: .default, title: "Duplicate") { (_, _) in
            let cell = self.tableView.cellForRow(at: indexPath)
            cell?.tag = indexPath.row
            self.performSegue(withIdentifier: "duplicateBracket", sender: cell)
        }
        duplicateAction.backgroundColor = Keys.shared.accent
        
        return [deleteAction, duplicateAction]
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
        if segue.identifier == "fromBracketList" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let destinationVC = segue.destination as? BracketCollectionViewController {
                    let bracket = BracketController.shared.brackets[indexPath.row]
                    destinationVC.bracket = bracket
                    destinationVC.title = bracket.name
                }
            }
        } else if segue.identifier == "duplicateBracket" {
            if let cell = sender as? UITableViewCell {
                let index = cell.tag
                if let destinationVC = segue.destination as? CreateBracketViewController {
                    let bracket = BracketController.shared.brackets[index]
                    print(bracket.name)
                    print(bracket.teams)
                    print(bracket.seeded)
                    destinationVC.bracketName = "\(bracket.name) copy"
                    destinationVC.seeded = bracket.seeded
                    destinationVC.participants = bracket.teams
                }
            }
        }
    }
}
