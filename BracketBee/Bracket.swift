//
//  Bracket.swift
//  BracketBee
//
//  Created by Keaton Harward on 2/11/17.
//  Copyright © 2017 Keaton Harward. All rights reserved.
//

import Foundation

class Bracket {
    let name: String
    let seeded: Bool
    let teams: [String]
    var champion: MatchupNode<String>
    
    init(name: String, seeded: Bool, teams: [String], champion: MatchupNode<String>) {
        self.name = name
        self.seeded = seeded
        self.teams = teams
        self.champion = champion
    }
    
    // MARK: - NSCoding
    
    required convenience init?(coder decoder: NSCoder) {
        guard let name = decoder.decodeObject(forKey: "name") as? String,
        let seeded = decoder.decodeObject(forKey: "seeded") as? Bool,
        let teams = decoder.decodeObject(forKey: "teams") as? [String],
            let champion = decoder.decodeObject(forKey: "champion") as? MatchupNode<String> else { return nil }
        
        self.init(name: name, seeded: seeded, teams: teams, champion: champion)
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(seeded, forKey: "seeded")
        coder.encode(teams, forKey: "teams")
        coder.encode(champion, forKey: "champion")
    }
}

