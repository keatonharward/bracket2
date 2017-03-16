//
//  Matchup.swift
//  BracketBee
//
//  Created by Keaton Harward on 2/11/17.
//  Copyright © 2017 Keaton Harward. All rights reserved.
//

import Foundation

public enum MatchupNode<String: Comparable> {
    indirect case node(MatchupNode<String>, String, MatchupNode<String>)
    case empty
    
    private func newTreeWithInsertedValue(winnerValue: String) -> MatchupNode {
        switch self {
        case .empty:
            return .node(.empty, winnerValue, .empty)
            
        case let .node(left, _, right):
            return .node(left, winnerValue, right)
        }
    }
    mutating func changeNode(newValue: String) {
        self = newTreeWithInsertedValue(winnerValue: newValue)
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

extension MatchupNode: Equatable {
    
    public var left: MatchupNode<String> {
        get {
            if case let .node(left, _, _) = self {
                if case .empty = left { return .empty }
                return left
            }
            return .empty
        }
        set(newWinner) {
            self = newWinner
        }
    }
    public var right: MatchupNode<String> {
        get {
            if case let .node(_, _, right) = self {
                if case .empty = right { return .empty }
                return right
            }
            return .empty
        }
        set(newWinner) {
            self = newWinner
        }
    }
    public var winner: String {
        if case let .node(_, value, _) = self {
            return value
        }
        fatalError("winner value can not be empty")
    }
}

//public protocol BinaryTree: Equatable {
//    var winner: T { get set }
//    var left: Self? { get set }
//    var right: Self? { get set }
//}

extension MatchupNode {
    public static func ==(lhs: MatchupNode, rhs: MatchupNode) -> Bool {
        return (lhs.winner == rhs.winner) && lhs.left == rhs.left && lhs.right == rhs.right
    }
}
