//
//  ParticipantCollectionViewCell.swift
//  BracketBee
//
//  Created by Keaton Harward on 3/10/17.
//  Copyright © 2017 Keaton Harward. All rights reserved.
//

import UIKit

@IBDesignable
class ParticipantCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = Keys.shared.accent.cgColor
        self.layer.cornerRadius = 5.0
        self.layer.backgroundColor = Keys.shared.alternateBackground.cgColor
    }
}
