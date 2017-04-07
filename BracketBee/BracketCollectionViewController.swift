//
//  BracketCollectionViewController.swift
//  BracketBee
//
//  Created by Keaton Harward on 3/10/17.
//  Copyright © 2017 Keaton Harward. All rights reserved.
//

import UIKit

private let reuseIdentifier = "participantCell"

class BracketCollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate, BracketCollectionViewLayoutDelegate {
    
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
        
        //         MARK: - Test bracket
//        let tempTeams = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
//        var tempBracket = BracketController.shared.layoutBracket(teams: tempTeams, seeded: true)
        //                var bracket2 = tempBracket.left
        //                bracket2?.selectWinner(leftIsWinner: true)
        //                tempBracket.left = bracket2
        //                print(tempBracket.description)
//        bracket = Bracket(name: "Test", seeded: true, teams: tempTeams, champion: tempBracket)
        //                roundsDictionary = BracketController.shared.breakDownRounds(bracket: bracket!)
        
        self.collectionView?.backgroundColor = Keys.shared.background
        let viewControllerStack = self.navigationController?.viewControllers
        if viewControllerStack?.count == 3 {
            self.navigationController?.viewControllers.remove(at: 1)
        }
        BracketCollectionViewLayout.delegate = self
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(longPressCell(sender:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.collectionView?.addGestureRecognizer(lpgr)
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
            guard let matchupNodeArray = roundsDictionary[indexPath.section] else {
                print("Unable to fetch the team array from the round dictionary for round \(indexPath.section)")
                return UICollectionViewCell()
            }
            let cellString = matchupNodeArray[indexPath.row - 1]?.winner
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
            //            print("Error getting navBar height")
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
    
    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        guard let winnerRoundArray = roundsDictionary[indexPath.section + 1] else { return false }
        guard let winnerMatchup = winnerRoundArray[Int(ceil(Double(indexPath.row) / 2) - 1)] else { return false }
        guard let winnerRound = roundsDictionary[indexPath.section], let winner = winnerRound[indexPath.row - 1] else { return false }
        
            if winnerMatchup.left == nil && winnerMatchup.right == nil {
                print("You did something wrong, you shouldn't be able to select that cell!")
            } else if winnerMatchup.left != nil && winnerMatchup.right != nil {
                if winner.winner == "TBD" {
                    childTeamMissingNotification()
                    return false
                    //            } else if winnerMatchup.winner != "TBD" {
                    //                var replace = false
                    //                presentReplaceWinnerAlert(){ shouldReplace in
                    //                    replace = shouldReplace
                    //                }
                    //                if replace == false {
                    //                    return false
                    //                }
                } else if winnerMatchup.left?.winner == "TBD" || winnerMatchup.right?.winner == "TBD" {
                    opponentMissingNotification()
                    return false
                }
                guard let leftMatchup = winnerMatchup.left, let rightMatchup = winnerMatchup.right else { return false }
                if nodeCanChange(indexPath: indexPath) {
                    if leftMatchup == winner {
                        winnerMatchup.selectWinner(leftIsWinner: true)
                    } else if rightMatchup == winner {
                        winnerMatchup.selectWinner(leftIsWinner: false)
                    } else {
                        print("You picked a winner that doesn't have teams!")
                    }
                } else {
                    winnerAlreadySelectedNotification()
                }
            }
        
        if let bracket = bracket {
            roundsDictionary = BracketController.shared.breakDownRounds(bracket: bracket)
        }
        collectionView.reloadData()
        return false
    }
    
    func longPressCell(sender: UILongPressGestureRecognizer) {
        if sender.state != .ended { return }
        let pointInCollectionView = sender.location(in: self.collectionView)
        guard let indexPath = self.collectionView?.indexPathForItem(at: pointInCollectionView) else { return }
        
        if !nodeCanChange(indexPath: indexPath) {
            winnerAlreadySelectedNotification()
        } else {
            guard let changedNodeRound = roundsDictionary[indexPath.section] else { return }
            guard let nodeToChange = changedNodeRound[indexPath.row - 1] else { return }
            if nodeToChange.winner == "TBD" {
                return
            } else {
                nodeToChange.winner = "TBD"
                if let bracket = bracket {
                    BracketController.shared.breakDownRounds(bracket: bracket)
                    collectionView?.reloadData()
                }
            }
        }
    }
    
    
    func nodeCanChange(indexPath: IndexPath) -> Bool {
        guard let winnerRound = roundsDictionary[indexPath.section + 1] else {
            if roundsDictionary[indexPath.section] != nil { return true } else { return false }}
        guard let winnerNode = winnerRound[Int(ceil(Double(indexPath.row) / 2) - 1)] else { return false }
        
        if winnerNode.winner != "TBD" {
            return false
        }
        return true
    }
    
    // MARK: - Remove all winners after the selected node - Super broken right now
    //    func removeWinnersPastSelection(winner: MatchupNode, indexPath: IndexPath) {
    //        let newIndexPath = IndexPath(item: Int(ceil(Double(indexPath.row) / 2) - 1), section: indexPath.section + 1)
    //
    //        print(newIndexPath.section)
    //        print(newIndexPath.row)
    //        guard let nextRoundArray = roundsDictionary[newIndexPath.section] else { return }
    //        guard let nextRoundWinner = nextRoundArray[newIndexPath.item] else { return }
    //        if nextRoundWinner.winner == "TBD" {
    //            return
    //        } else {
    //            let winnerToRemove = nextRoundWinner
    //            nextRoundWinner.winner = "TBD"
    //            removeWinnersPastSelection(winner: winnerToRemove, indexPath: newIndexPath)
    //        }
    //    }
    
    
    // TODO: - Fix this completion so it will properly pass the bool value from the user selection before running the rest of the update winner code.
    //    func presentReplaceWinnerAlert(completion:@escaping (Bool) -> ()){
    //        let replaceWinnerAlert = UIAlertController(title: "A winner has already been chosen!", message: "Are you sure you want to change the winner?", preferredStyle: .alert)
    //        let yesAction = UIAlertAction(title: "Yes", style: .default) { (_) in
    //            completion(true)
    //        }
    //        let noAction = UIAlertAction(title: "No", style: .default) { (_) in
    //            completion(false)
    //        }
    //
    //        replaceWinnerAlert.addAction(yesAction)
    //        replaceWinnerAlert.addAction(noAction)
    //        present(replaceWinnerAlert, animated: true)
    //    }
    
    func childTeamMissingNotification() {
        let needWinnerError = UIAlertController(title: "There's not a team there!", message: "Make sure you have selected the winners of previous rounds before picking a winner!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        needWinnerError.addAction(okAction)
        present(needWinnerError, animated: true)
    }
    
    func opponentMissingNotification() {
        let needTeamsError = UIAlertController(title: "Participant doesn't have an opponent!", message: "Make sure you complete the previous rounds before selecting a winner!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        needTeamsError.addAction(okAction)
        present(needTeamsError, animated: true)
    }
    
    func winnerAlreadySelectedNotification() {
        let deSelectWinnerError = UIAlertController(title: "Winner already selected!", message: "Please de-select the winners after the selected cell and try again.", preferredStyle: .alert)
        deSelectWinnerError.addAction(UIAlertAction(title: "OK", style: .default))
        present(deSelectWinnerError, animated: true)
    }
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
