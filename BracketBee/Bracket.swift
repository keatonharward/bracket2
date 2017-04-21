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
        let seeded = Bool(aDecoder.decodeBool(forKey: "seeded"))
        guard let name = aDecoder.decodeObject(forKey: "name") as? String,
            let teams = aDecoder.decodeObject(forKey: "teams") as? [String],
            let champion = aDecoder.decodeObject(forKey: "champion") as? MatchupNode else {
                print("Error decoding bracket nodes")
                return nil }
        
        self.init(name: name, seeded: seeded, teams: teams, champion: champion)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(seeded, forKey: "seeded")
        aCoder.encode(teams, forKey: "teams")
        aCoder.encode(champion, forKey: "champion")
    }
}

