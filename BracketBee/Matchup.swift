//
//  Matchup.swift
//  BracketBee
//
//  Created by Keaton Harward on 2/11/17.
//  Copyright © 2017 Keaton Harward. All rights reserved.
//

import Foundation

public indirect enum MatchupNode<T> {
    case node(MatchupNode<T>, T, MatchupNode<T>)
    case empty
}

extension MatchupNode {
    public var description: String {
        switch self {
        case let .node(left, value, right):
            let returnString = "value: \(value), left = [ + \(left.description) + ], right = [ + \(right.description) + ]"
            return returnString
        case .empty:
            return ""
        }
    }
}
