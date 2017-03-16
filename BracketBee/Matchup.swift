//
//  Matchup.swift
//  BracketBee
//
//  Created by Keaton Harward on 2/11/17.
//  Copyright © 2017 Keaton Harward. All rights reserved.
//

import Foundation

public enum MatchupNode<T: Comparable> {
    indirect case node(MatchupNode<T>, T, MatchupNode<T>)
    case empty
    
    private func newTreeWithInsertedValue(winnerValue: T) -> MatchupNode {
        switch self {
        case .empty:
            return .node(.empty, winnerValue, .empty)
            
        case let .node(left, _, right):
            return .node(left, winnerValue, right)
        }
    }
}

extension MatchupNode {
    public var description: String {
        switch self {
        case let .node(left, value, right):
            let returnString = "value: \(value), left = [\(left.description)], right = [\(right.description)]"
            return returnString
        case .empty:
            return ""
        }
    }
}

extension MatchupNode: BinaryTree {
    public var left: MatchupNode? {
        if case let .node(left, _, _) = self {
            if case .empty = left { return nil }
            return left
        }
        return nil
    }
    public var right: MatchupNode? {
        if case let .node(_, _, right) = self {
            if case .empty = right { return nil }
            return right
        }
        return nil
    }
    public var winner: T {
        if case let .node(_, value, _) = self {
            return value
        }
        fatalError("element can not be empty")
    }
}

public protocol BinaryTree: Equatable {
    associatedtype Winner: Comparable
    var winner: Winner { get }
    var left: Self? { get }
    var right: Self? { get }
}

extension MatchupNode {
    public static func ==(lhs: MatchupNode, rhs: MatchupNode) -> Bool {
        return (lhs.winner == rhs.winner) && lhs.left == rhs.left && lhs.right == rhs.right
    }
    
    public var height: Int {
        var (leftHeight, rightHeight) = (0, 0)
        if let left = left { leftHeight = left.height + 1 }
        if let right = right { rightHeight = right.height + 1 }
        let height = Swift.max(leftHeight, rightHeight)
        return height
    }
        
        
        
        
        
        
        
        
        
        
        
}
