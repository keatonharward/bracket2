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
        if indexPath.item == 0 { return false }
        guard let winnerRoundArray = roundsDictionary[indexPath.section + 1] else {
            childTeamMissingNotification(indexPath: indexPath)
            return false }
        guard let winnerMatchup = winnerRoundArray[Int(ceil(Double(indexPath.row) / 2) - 1)] else { return false }
        guard let winnerRound = roundsDictionary[indexPath.section], let winner = winnerRound[indexPath.row - 1] else { return false }
        
        if winnerMatchup.left == nil && winnerMatchup.right == nil {
            print("You did something wrong, you shouldn't be able to select that cell!")
        } else if winnerMatchup.left != nil && winnerMatchup.right != nil {
            if winner.winner == "TBD" {
                childTeamMissingNotification(indexPath: indexPath)
                return false
            } else if winnerMatchup.left?.winner == "TBD" || winnerMatchup.right?.winner == "TBD" {
                opponentMissingNotification(indexPath: indexPath)
                return false
            }
            guard let leftMatchup = winnerMatchup.left, let rightMatchup = winnerMatchup.right else { return false }
            if nodeCanChange(indexPath: indexPath) {
                if leftMatchup == winner {
                    BracketController.shared.selectWinner(matchup: winnerMatchup, leftIsWinner: true)
                } else if rightMatchup == winner {
                    BracketController.shared.selectWinner(matchup: winnerMatchup, leftIsWinner: false)
                } else {
                    print("You picked a winner that doesn't have teams!")
                }
            } else {
                winnerAlreadySelectedNotification(indexPath: indexPath)
                return false
            }
        }
        
        if bracket != nil {
            BracketController.shared.saveToPersistentStore()
        }
        collectionView.reloadData()
        return false
    }
    
    func longPressCell(sender: UILongPressGestureRecognizer) {
        let pointInCollectionView = sender.location(in: self.collectionView)
        guard let indexPath = self.collectionView?.indexPathForItem(at: pointInCollectionView) else { return }
        if indexPath.item == 0 { return }
        
        guard let roundArray = roundsDictionary[indexPath.section], let selectedMatchupNode = roundArray[indexPath.row - 1] else { return }
        
        if selectedMatchupNode.left?.winner == nil || selectedMatchupNode.right?.winner == nil {
            return
        }
        if !nodeCanChange(indexPath: indexPath) {
            winnerAlreadySelectedNotification(indexPath: indexPath)
        } else {
            if selectedMatchupNode.winner == "TBD" {
                return
            } else {
                BracketController.shared.deSelectWinner(matchup: selectedMatchupNode)
                if bracket != nil {
                    BracketController.shared.saveToPersistentStore()
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
    
    // MARK: - can't select cell error functions
    
    func childTeamMissingNotification(indexPath: IndexPath) {
        let leftTeamIndex = IndexPath(item: (indexPath.item * 2) - 2, section: indexPath.section - 1)
        let rightTeamIndex = IndexPath(item: (indexPath.item * 2) - 1, section: indexPath.section - 1)
        
        guard let previousRound = roundsDictionary[leftTeamIndex.section], let leftTeam = previousRound[leftTeamIndex.item] else { return }
        guard let rightTeam = previousRound[rightTeamIndex.item] else { return }
        
        guard let collectionView = collectionView else { return }
        
        if leftTeam.winner == "TBD" && rightTeam.winner == "TBD" {
            guard let leftCell = collectionView.cellForItem(at: rightTeamIndex) as? TBDCollectionViewCell, let rightCell = collectionView.cellForItem(at: IndexPath(item: rightTeamIndex.item + 1, section: rightTeamIndex.section)) as? TBDCollectionViewCell else { return }
            cellPulseAnimation(cell: leftCell)
            cellPulseAnimation(cell: rightCell)
        } else if leftTeam.winner == "TBD" {
            guard let leftCell = collectionView.cellForItem(at: rightTeamIndex) as? TBDCollectionViewCell else { return }
            cellPulseAnimation(cell: leftCell)
        } else if rightTeam.winner == "TBD" {
            guard let rightCell = collectionView.cellForItem(at: IndexPath(item: rightTeamIndex.item + 1, section: rightTeamIndex.section)) as? TBDCollectionViewCell else { return }
            cellPulseAnimation(cell: rightCell)
        } else {
            guard let leftCell = collectionView.cellForItem(at: rightTeamIndex) as? ParticipantCollectionViewCell, let rightCell = collectionView.cellForItem(at: IndexPath(item: rightTeamIndex.item + 1, section: rightTeamIndex.section)) as? ParticipantCollectionViewCell else { return }
            cellPulseAnimation(cell: leftCell)
            cellPulseAnimation(cell: rightCell)
        }
    }
    
    func opponentMissingNotification(indexPath: IndexPath) {
        var missingTeamIsLeft: Bool
        if indexPath.row % 2 == 0 {
            missingTeamIsLeft = true
        } else {
            missingTeamIsLeft = false
        }
        
        if missingTeamIsLeft {
            let rightTeamCell = IndexPath(item: indexPath.item - 1, section: indexPath.section)
            guard let cellToAnimate = collectionView?.cellForItem(at: rightTeamCell) as? TBDCollectionViewCell else { return }
            cellPulseAnimation(cell: cellToAnimate)
        } else {
            let leftTeamCell = IndexPath(item: indexPath.item + 1, section: indexPath.section)
            guard let cellToAnimate = collectionView?.cellForItem(at: leftTeamCell) as? TBDCollectionViewCell else { return }
            cellPulseAnimation(cell: cellToAnimate)
        }
    }
    
    func winnerAlreadySelectedNotification(indexPath: IndexPath) {
        let winnerCellIndex = IndexPath(item: Int(ceil(Double(indexPath.item) / 2)), section: indexPath.section + 1)
        guard let cellToAnimate = collectionView?.cellForItem(at: winnerCellIndex) as? ParticipantCollectionViewCell else { return }
        cellPulseAnimation(cell: cellToAnimate)
    }
    
    // MARK: - Cell animation functions
    
    func cellPulseAnimation(cell: UICollectionViewCell) {
        
        let changeBorderColor = CAKeyframeAnimation()
        changeBorderColor.keyPath = "borderColor"
        changeBorderColor.values = [Keys.shared.accent.cgColor,
                                    UIColor.red.cgColor,
                                    UIColor.yellow.cgColor,
                                    UIColor.red.cgColor,
                                    Keys.shared.accent.cgColor
        ]
        changeBorderColor.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        
        let changeSize = CAKeyframeAnimation()
        changeSize.keyPath = "transform.scale"
        
        changeSize.values = [1, 1.15, 1, 1.15, 1]
        changeSize.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        
        
        let group = CAAnimationGroup()
        group.animations = [changeBorderColor, changeSize]
        group.duration = 0.5
        group.repeatCount = 1.0
        DispatchQueue.main.async {
            cell.layer.add(group, forKey: nil)
        }
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
