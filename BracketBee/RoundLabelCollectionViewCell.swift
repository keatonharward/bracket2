//
//  RoundLabelCollectionViewCell.swift
//  BracketBee
//
//  Created by Keaton Harward on 3/12/17.
//  Copyright © 2017 Keaton Harward. All rights reserved.
//

import UIKit

@IBDesignable
class RoundLabelCollectionViewCell: UICollectionViewCell {
    
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
        self.layer.backgroundColor = Keys.shared.accent.cgColor
    }
}
