//
//  Matchup.swift
//  BracketBee
//
//  Created by Keaton Harward on 2/11/17.
//  Copyright © 2017 Keaton Harward. All rights reserved.
//

import Foundation

class MatchupNode {
    var winner: String
    var left: MatchupNode?
    var right: MatchupNode?
    
    
    init(winner: String, left: MatchupNode?, right: MatchupNode?) {
        self.winner = winner
        self.left = left
        self.right = right
    }
}

//extension MatchupNode {
//    public var description: String {
//        switch self {
//        case let .node(left, value, right):
//            let returnString = "value: \(value), left = [\(left.description)], right = [\(right.description)]"
//            return returnString
//        case .empty:
//            return ""
//        }
//    }
//}

//public protocol BinaryTree: Equatable {
//    var winner: T { get set }
//    var left: Self? { get set }
//    var right: Self? { get set }
//}

extension MatchupNode {
    public static func ==(lhs: MatchupNode, rhs: MatchupNode) -> Bool {
        guard let left = lhs.left, let right = rhs.right else { return false }
        return (lhs.winner == rhs.winner) && left == left && right == right
    }
}
