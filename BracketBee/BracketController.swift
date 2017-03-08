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
    
    var brackets: [Bracket] = []
    
    func addBracket(name: String, seeded: Bool, teams: [String]){
        
        guard let champion = self.layoutBracket(teams: teams, seeded: seeded) else {
            // TODO: -
            print("Error creating champion node, bracket was not layed out properly")
            return
        }
        print(champion.description)
        let bracket = Bracket(name: name, seeded: seeded, teams: teams, champion: champion)
        brackets.append(bracket)
        // TODO: - save me
    }
    
    func layoutBracket(teams: [String], seeded: Bool) -> MatchupNode<String>?{
        
        let teamNodes = seedTeamsToNodes(teams: teams, seeded: seeded)
        
        guard let champion = findMatchups(teams: teamNodes) else { return nil }
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
    
    func findMatchups(teams: [MatchupNode<String>]) -> MatchupNode<String>? {
//        let totalGames = (teams.count - 1)
        let rounds = findRounds(numberOfTeams: teams.count)
        var allNodes = teams
        
        // Calculate the number of Bye's to add teams to the second round
        var numberOfByes: Int
        let nthRootTestValue = Double(Double(1)/Double(rounds)) // Used to find the number of teams to the root of the number of rounds. If that value == 2, there are no bye's. (2, 4, 8, 16, 32, 64, 128 so on teams)
        
        if pow(Double(teams.count), nthRootTestValue) == 2 {
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
                guard let team = allNodes.first else { return nil }
                allNodes.removeFirst()
                round.append(team)
            }
            
            // This loop combines all teams until there is only a champion node
            while remainingMatchups > 0 {
                remainingMatchups -= 1
                guard let firstNode = allNodes.first, let secondNode = allNodes.popLast() else { return nil }
                
                let matchup = MatchupNode.node(firstNode, "TBD", secondNode)
                allNodes.removeFirst()
                round.append(matchup)
            }
            allNodes = round
            remainingMatchups = allNodes.count / 2
        }
        let gameWithAllChildren = allNodes.first
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
    
}
