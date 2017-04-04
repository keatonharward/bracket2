//
//  Bracket.swift
//  BracketBee
//
//  Created by Keaton Harward on 2/11/17.
//  Copyright © 2017 Keaton Harward. All rights reserved.
//

import Foundation

class Bracket: NSObject, NSCoding {
    let name: String
    let seeded: Bool
    let teams: [String]
    var champion: MatchupNode
    
    init(name: String, seeded: Bool, teams: [String], champion: MatchupNode) {
        self.name = name
        self.seeded = seeded
        self.teams = teams
        self.champion = champion
    }
    
    // MARK: - NSCoding
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String,
            let seeded = aDecoder.decodeObject(forKey: "seeded") as? Bool,
            let teams = aDecoder.decodeObject(forKey: "teams") as? [String],
            let championString = aDecoder.decodeObject(forKey: "champion") as? String else { return nil }
        
        let champion = MatchupNode(winner: "PLACEHOLDER", left: nil, right: nil)
        
        self.init(name: name, seeded: seeded, teams: teams, champion: champion)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(seeded, forKey: "seeded")
        aCoder.encode(teams, forKey: "teams")
        let championValue = String(describing: self.champion)
        aCoder.encode(championValue, forKey: "champion")
    }
}

