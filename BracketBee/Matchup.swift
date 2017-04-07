//
//  Matchup.swift
//  BracketBee
//
//  Created by Keaton Harward on 2/11/17.
//  Copyright © 2017 Keaton Harward. All rights reserved.
//

import Foundation

class MatchupNode: Equatable {
    var winner: String
    var left: MatchupNode?
    var right: MatchupNode?
    
    
    init(winner: String, left: MatchupNode?, right: MatchupNode?) {
        self.winner = winner
        self.left = left
        self.right = right
    }
    
    func selectWinner(leftIsWinner: Bool) {
        if leftIsWinner == true {
            guard let left = self.left else { return }
            self.winner = left.winner
        } else {
            guard let right = self.right else { return }
            self.winner = right.winner
        }
        
    }
}

extension MatchupNode {
    public var description: String {
        switch self.winner {
        case nil:
            return ""
        default:
            if let left = left, let right = right {
            let returnString = "value: \(winner), left = [\(left.description)], right = [\(right.description)]"
            return returnString
            } else if let left = left, right == nil {
                let returnString = "value: \(winner), left = [\(left.description)], right = []"
                return returnString
            } else if let right = right, left == nil {
                let returnString = "value: \(winner), left = [], right = [\(right.description)]"
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
