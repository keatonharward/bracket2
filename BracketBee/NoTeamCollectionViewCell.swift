//
//  NoTeamCollectionViewCell.swift
//  BracketBee
//
//  Created by Keaton Harward on 3/15/17.
//  Copyright © 2017 Keaton Harward. All rights reserved.
//

import UIKit

class NoTeamCollectionViewCell: UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.backgroundColor = UIColor.clear.cgColor
    }
}
