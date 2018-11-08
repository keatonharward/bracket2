//
//  Matchup.swift
//  BracketBee
//
//  Created by Keaton Harward on 2/11/17.
//  Copyright © 2017 Keaton Harward. All rights reserved.
//

import Foundation

class MatchupNode: NSObject, NSCoding {
    var winner: String
    var left: MatchupNode?
    var right: MatchupNode?
    
    var currentLevel = 0
    
    init(winner: String, left: MatchupNode?, right: MatchupNode?) {
        self.winner = winner
        self.left = left
        self.right = right
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let winner = aDecoder.decodeObject(forKey: "winner") as? String,
            let left = aDecoder.decodeObject(forKey: "left") as? MatchupNode?,
            let right = aDecoder.decodeObject(forKey: "right") as? MatchupNode? else {
                print("There's an error in the matchupNode initializer")
                return nil }
        
        self.init(winner: winner, left: left, right: right)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(winner, forKey: "winner")
        aCoder.encode(left, forKey: "left")
        aCoder.encode(right, forKey: "right")
    }
}

extension MatchupNode {
    public var stringDescription: String {
        switch self.winner {
        case nil:
            return ""
        default:
            if let left = left, let right = right {
                let returnString = "value: \(winner), left = [\(left.stringDescription)], right = [\(right.stringDescription)]"
                return returnString
            } else if let left = left, right == nil {
                let returnString = "value: \(winner), left = [\(left.stringDescription)], right = []"
                return returnString
            } else if let right = right, left == nil {
                let returnString = "value: \(winner), left = [], right = [\(right.stringDescription)]"
                return returnString
            } else {
                let returnString = "value: \(winner), left = [], right = []"
                return returnString
            }
        }
    }
}

extension MatchupNode {
    public static func ==(lhs: MatchupNode, rhs: MatchupNode) -> Bool {       
        return (lhs.winner == rhs.winner) && lhs.left == rhs.left && lhs.right == rhs.right
    }
}

extension MatchupNode {
    
    func traverseTreeWithBlock(_ nodes:  [MatchupNode]?, _ closure: ((MatchupNode?, Int) -> Void)) {
        
        var container = [MatchupNode]()
        if nodes == nil {
            container = [self]
        } else {
            container = nodes!
        }
        
        var tempContainer = [MatchupNode]()
        
        if !container.isEmpty {
            for node in container {
                if let left = node.left {
                    tempContainer.append(left)
                }
                if let right = node.right {
                    tempContainer.append(right)
                }
                closure(node, currentLevel)
            }
            
            currentLevel += 1
            traverseTreeWithBlock(tempContainer, closure)
        }
    }
    
    
    
//    func a_traverseTreeWithBlock(_ closure: (() -> Void)?) {
//        var container = [MatchupNode?]()
//        if left != nil {
//            container.append(left)
//        }
//        if right != nil {
//            container.append(right)
//        }
//        //
//        closure?()
//        continueWithNodes(container)
//    }
//
//    func continueWithNodes(_ nodes: [MatchupNode?]) {
//        nodes.forEach { (node) in
//            a_traverseTreeWithBlock(nil)
//        }
//    }
}
