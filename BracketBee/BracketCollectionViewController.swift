//
//  BracketCollectionViewController.swift
//  BracketBee
//
//  Created by Keaton Harward on 3/10/17.
//  Copyright © 2017 Keaton Harward. All rights reserved.
//

import UIKit

private let reuseIdentifier = "participantCell"

class BracketCollectionViewController: UICollectionViewController, BracketCollectionViewLayoutDelegate {
    
    var bracket: Bracket? {
        didSet {
            if let bracket = bracket {
                roundsDictionary = BracketController.shared.breakDownRounds(bracket: bracket)
            }
        }
    }
    
    var rounds = 0
    var roundsDictionary = [Int: [MatchupNode?]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Test bracket
        //        let tempTeams = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24"]
        //        var tempBracket = BracketController.shared.layoutBracket(teams: tempTeams, seeded: true)
        //        tempBracket.changeNode(newValue: "TEST")
        //        var bracket2 = tempBracket.left
        //        bracket2.changeNode(newValue: "TEST2")
        //        tempBracket.left = bracket2
        ////        print(test.description)
        //        bracket = Bracket(name: "Test", seeded: true, teams: tempTeams, champion: tempBracket)
        //        roundsDictionary = BracketController.shared.breakDownRounds(bracket: bracket!)
        
        self.collectionView?.backgroundColor = Keys.shared.background
        let viewControllerStack = self.navigationController?.viewControllers
        if viewControllerStack?.count == 3 {
            self.navigationController?.viewControllers.remove(at: 1)
        }
        BracketCollectionViewLayout.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let bracket = bracket else { return 0 }
        let height = BracketController.shared.findRounds(numberOfTeams: bracket.teams.count)
        rounds = height + 1
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
            guard let stringArray = roundsDictionary[indexPath.section] else {
                print("Unable to fetch the team array from the round dictionary for round \(indexPath.section)")
                return UICollectionViewCell()
            }
            let cellString = stringArray[indexPath.row - 1]?.winner
            if cellString == nil {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noTeamCell", for: indexPath) as? NoTeamCollectionViewCell else {
                    print("Unable to cast collection view cell to custom type.")
                    return UICollectionViewCell()
                }
                return cell
            } else if cellString == "TBD" {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TBDCell", for: indexPath) as? TBDCollectionViewCell else {
                    print("Unable to cast collection view cell to custom type.")
                    return UICollectionViewCell()
                }
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ParticipantCollectionViewCell else {
                    print("Unable to cast collection view cell to custom type.")
                    return UICollectionViewCell()
                }
                
                cell.label.text = cellString
                
                return cell
            }
        }
    }
    
    func getHeight() -> CGFloat {
        if let height = self.navigationController?.navigationBar.frame.height {
            if !UIApplication.shared.isStatusBarHidden {
                return height + UIApplication.shared.statusBarFrame.height
            }
            return height
        } else {
            print("Error getting navBar height")
            return 64
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
