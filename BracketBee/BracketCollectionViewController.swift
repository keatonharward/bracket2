//
//  BracketCollectionViewController.swift
//  BracketBee
//
//  Created by Keaton Harward on 3/10/17.
//  Copyright © 2017 Keaton Harward. All rights reserved.
//

import UIKit

private let reuseIdentifier = "participantCell"

class BracketCollectionViewController: UICollectionViewController {
    
    var bracket: Bracket?
    var rounds = 7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Do any additional setup after loading the view.
        self.collectionView?.backgroundColor = Keys.shared.background
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        guard let teams = bracket?.teams else { return 7 }
        rounds = BracketController.shared.findRounds(numberOfTeams: teams.count)
        return rounds
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == rounds - 1 {
            return 2
        }
        let repeats = (rounds - section - 1)
        var gamesInRound = 1
        for _ in 1...repeats {
            gamesInRound *= 2
        }
        return gamesInRound + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "roundCell", for: indexPath) as? RoundLabelCollectionViewCell else {
                print("Unable to cast collection view cell for round label")
                return UICollectionViewCell()
            }
            if indexPath.section == rounds - 1 {
                cell.label.text = "Champion"
            } else if indexPath.section == rounds - 2 {
                cell.label.text = "Final"
            } else if indexPath.section == rounds - 3 {
                cell.label.text = "Semi-Final"
            } else {
                cell.label.text = "Round \(indexPath.section + 1)"
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ParticipantCollectionViewCell else {
                print("Unable to cast collection view cell to custom type.")
                return UICollectionViewCell()
            }
            
            cell.label.text = "Sec \(indexPath.section)/Item \(indexPath.item)"
            return cell
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
