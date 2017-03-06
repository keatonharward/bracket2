//
//  ViewController.swift
//  BracketBee
//
//  Created by Keaton Harward on 2/10/17.
//  Copyright © 2017 Keaton Harward. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let teams = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35"]
        
        BracketController.shared.addBracket(name: "Test", seeded: true, teams: teams)
        
        let testBracket: Bracket = BracketController.shared.brackets[0]
        
        print(testBracket.champion.description)
    }


}

