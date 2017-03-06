//
//  Bracket.swift
//  BracketBee
//
//  Created by Keaton Harward on 2/11/17.
//  Copyright © 2017 Keaton Harward. All rights reserved.
//

import Foundation

struct Bracket {
    let name: String
    let seeded: Bool
    let teams: [String]
    var champion: MatchupNode<String>
}
