    //
    //  BracketController.swift
    //  BracketBee
    //
    //  Created by Keaton Harward on 2/11/17.
    //  Copyright © 2017 Keaton Harward. All rights reserved.
    //
    
    import Foundation
    import GameKit
    
    class BracketController {
        
        static let shared = BracketController()
        
        init() {
            loadFromPersistentStore()
        }
        
        var brackets: [Bracket] = []
        
        func addBracket(name: String, seeded: Bool, teams: [String]){
            
            let champion = self.layoutBracket(teams: teams, seeded: seeded)
            //            print(champion.description)
            let bracket = Bracket(name: name, seeded: seeded, teams: teams, champion: champion)
            let brokenDown = breakDownRounds(bracket: bracket)
            //            print(brokenDown)
            brackets.append(bracket)
            saveToPersistentStore()
        }
        
        func layoutBracket(teams: [String], seeded: Bool) -> MatchupNode<String>{
            
            let teamNodes = seedTeamsToNodes(teams: teams, seeded: seeded)
            
            let champion = findMatchups(teams: teamNodes)
            return champion
        }
        
        // Create node objects that hold each team name & add nodes to an ordered array of seeds
        func seedTeamsToNodes(teams: [String], seeded: Bool) -> [MatchupNode<String>] {
            
            var teams = teams
            
            if seeded == false {
                teams = shuffle(teams: teams)
            }
            
            var teamNodes:[MatchupNode<String>] = []
            
            for team in teams {
                let nodeTeam = team
                let node = MatchupNode.node(.empty, nodeTeam, .empty)
                teamNodes.append(node)
            }
            
            return teamNodes
            
        }
        
        // TODO: - fix this function
        // Randomize seeds if bracket is not seeded
        func shuffle(teams: [String]) -> [String] {
            let shuffledTeams = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: teams) as! [String]
            return shuffledTeams
        }
        
        func findMatchups(teams: [MatchupNode<String>]) -> MatchupNode<String> {
            //        let totalGames = (teams.count - 1)
            let rounds = findRounds(numberOfTeams: teams.count)
            var allNodes = teams
            
            // Calculate the number of Bye's to add teams to the second round
            var numberOfByes: Int
            let nthRoot = Double(Double(1)/Double(rounds)) // Used to find the number of teams to the root of the number of rounds. If that value == 2, there are no bye's. (2, 4, 8, 16, 32, 64, 128 so on teams)
            
            if pow(Double(teams.count), nthRoot) == 2 {
                numberOfByes = 0
            } else {
                let maxGamesInFirstRound = Int(pow(Double(2), Double(rounds)))
                numberOfByes = maxGamesInFirstRound - teams.count
            }
            
            
            var remainingMatchups = ((allNodes.count - numberOfByes) / 2) + numberOfByes
            
            while remainingMatchups > 0 {
                var round = [MatchupNode<String>]()
                
                // This while loop adds the nodes of teams that have a bye in the 1st round to the bracket to an array of nodes that will otherwise hold matchups
                while numberOfByes > 0 {
                    numberOfByes -= 1
                    remainingMatchups -= 1
                    if let team = allNodes.first {
                        allNodes.removeFirst()
                        round.append(team)
                    }
                }
                
                // This loop combines all teams until there is only a champion node
                while remainingMatchups > 0 {
                    remainingMatchups -= 1
                    if let firstNode = allNodes.first {
                        if let secondNode = allNodes.popLast() {
                            
                            let matchup = MatchupNode.node(firstNode, "TBD", secondNode)
                            allNodes.removeFirst()
                            round.append(matchup)
                        }
                    }
                }
                allNodes = round
                remainingMatchups = allNodes.count / 2
            }
            guard let gameWithAllChildren = allNodes.first else { return allNodes.first! }
            return gameWithAllChildren
        }
        
        // Find the number of rounds to calculate the number of matchups that will need to be created in each round.
        func findRounds(numberOfTeams:Int) -> Int {
            var gamesRemaining = numberOfTeams - 1
            var numberOfRounds = 0
            var gamesPerRoundCounter = 1
            while gamesRemaining > 0 {
                numberOfRounds += 1
                gamesRemaining -= gamesPerRoundCounter
                gamesPerRoundCounter *= 2
            }
            
            return numberOfRounds
        }
        
        func breakDownRounds(bracket: Bracket) -> [Int: [MatchupNode<String>?]] {
            var round = findRounds(numberOfTeams: bracket.teams.count)
            var previousRoundArray = [MatchupNode<String>?]()
            previousRoundArray.append(bracket.champion)
            var allRoundsDictionary = [Int: [MatchupNode<String>?]]()
            allRoundsDictionary.updateValue([bracket.champion], forKey: round)
            let passes = round
            
            for _ in 1...passes {
                round -= 1
                var roundArray = [MatchupNode<String>?]()
                for matchup in previousRoundArray {
                    if let matchup = matchup {
                        let leftTeam = matchup.left
                        switch leftTeam {
                        case .empty:
                            roundArray.append(nil)
                        case .node:
                            roundArray.append(leftTeam)
                        }
                        
                        let rightTeam = matchup.right
                        switch rightTeam {
                        case .empty:
                            roundArray.append(nil)
                        case .node:
                            roundArray.append(rightTeam)
                        }
                    } else {
                        roundArray.append(nil)
                        roundArray.append(nil)
                        
                    }
                }
                allRoundsDictionary.updateValue(roundArray, forKey: round)
                previousRoundArray = roundArray
            }
            
            return allRoundsDictionary
        }
        
        func saveToPersistentStore() {
            for bracket in brackets {
                let filePath = getDocumentsDirectory().appendingPathComponent("\(bracket.name).bracket")
                print(filePath)
                let bracketData = NSKeyedArchiver.archivedData(withRootObject: bracket)
                do {
                    try bracketData.write(to: filePath)
                } catch let error as NSError {
                    print("Could not save bracket called \(bracket.name). \(error.localizedDescription)")
                }
            }
        }
        
        func loadFromPersistentStore() {
            let filePath = getDocumentsDirectory()
            var loadedBrackets: [Bracket] = []
            // TODO: - Fix this so it holds files, not strings.
            var bracketsToLoad: [String] = []
            do {
                bracketsToLoad = try FileManager.default.contentsOfDirectory(atPath: filePath.path)
                print(bracketsToLoad)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            for bracketData in bracketsToLoad {
                if let bracket = NSKeyedUnarchiver.unarchiveObject(withFile: bracketData) as? Bracket {
                    loadedBrackets.append(bracket)
                }
            }
            brackets = loadedBrackets
        }
        
        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let bracketsDirectory = paths[0].appendingPathComponent("Brackets", isDirectory: true)
            
            // TODO: - I think this is going to be false every time, need to do something to make it actually check whether or not the directory exists.
            if FileManager.default.fileExists(atPath: bracketsDirectory.absoluteString) == false {
                do {
                    try FileManager.default.createDirectory(at: bracketsDirectory, withIntermediateDirectories: true, attributes: nil)
                } catch let error as NSError {
                    print("Error creating directory: \(error.localizedDescription)")
                }
            }
            return bracketsDirectory
        }
    }
