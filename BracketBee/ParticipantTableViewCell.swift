//
//  participantTableViewCell.swift
//  BracketBee
//
//  Created by Keaton Harward on 3/6/17.
//  Copyright © 2017 Keaton Harward. All rights reserved.
//

import UIKit

class ParticipantTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var seedLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var seedImage: UIImageView!
    
    var seed: Int?
    var participant: String? {
        didSet {
            updateCell()
        }
    }
    
    func updateCell() {
        guard let participant = participant else { return }
        self.backgroundColor = Keys.shared.alternateBackground
        teamNameLabel.textColor = Keys.shared.fontColor
        teamNameLabel.text = participant
        
        if seed != nil {
            guard let cellSeed = seed else { return }
            seedLabel.isHidden = false
            seedImage.isHidden = false
            seedLabel.text = "\(cellSeed)"
            teamNameLabel.frame = CGRect(x: 45, y: 11, width: 280, height: 21)
        } else {
            seedLabel.isHidden = true
            seedImage.isHidden = true
            teamNameLabel.frame = CGRect(x: 15, y: 11, width: 280, height: 21)
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
