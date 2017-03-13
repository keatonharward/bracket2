//
//  BracketCollectionViewLayout.swift
//  BracketBee
//
//  Created by Keaton Harward on 3/10/17.
//  Copyright © 2017 Keaton Harward. All rights reserved.
//

import UIKit

class BracketCollectionViewLayout: UICollectionViewLayout {
    
    let cellHeight = 30.0
    let cellWidth = 100.0
    let horizontalPadding = 50.0
    let largestSectionPadding = 30.0
    
    var cellAttributesDictionary = Dictionary<IndexPath, UICollectionViewLayoutAttributes>()
    
    var contentSize = CGSize.zero
    
    var dataSourceDidUpdate = true
    
    
    // MARK: - Required layout methods
    override var collectionViewContentSize: CGSize {
        return self.contentSize
    }
    
    override func prepare() {
        
        guard let collectionView = collectionView else {
            return }
        
        let contentWidth = (Double(collectionView.numberOfSections) * cellWidth) + (Double(collectionView.numberOfSections - 1) * horizontalPadding)
        var contentHeight = 0.0
        var round1IsPlayIn = false
        
        // checks if round 1 or 2 is the largest section and sets view height accordingly
        for section in 0...collectionView.numberOfSections - 1 {
            let tempHeight = (Double(collectionView.numberOfItems(inSection: section)) * cellHeight) + (Double(collectionView.numberOfItems(inSection: section)) * largestSectionPadding)
            if tempHeight > contentHeight {
                contentHeight = tempHeight
                if section != 0 {
                    round1IsPlayIn = true
                }
            }
        }
        
        let headerHeight = cellHeight + largestSectionPadding
        let bracketHeight = contentHeight - headerHeight
        
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
        if !dataSourceDidUpdate {
            let yOffset = collectionView.contentOffset.y
            
            if collectionView.numberOfSections > 0 {
                for section in 0...collectionView.numberOfSections - 1 {
                    
                    if collectionView.numberOfItems(inSection: section) > 0 {
                        
                        let indexPath = IndexPath(item: 0, section: section)
                        
                        if let attributes = cellAttributesDictionary[indexPath] {
                            var frame = attributes.frame
                            frame.origin.y = yOffset
                            attributes.frame = frame
                        }
                    }
                }
            }
            return
        }
        
        dataSourceDidUpdate = false
        
        if collectionView.numberOfSections > 0 {
            for section in 0...collectionView.numberOfSections - 1 {
                
                if collectionView.numberOfItems(inSection: section) > 0 {
                    for item in 0...collectionView.numberOfItems(inSection: section) - 1 {
                        
                        let cellIndex = IndexPath(item: item, section: section)
                        let xPos = (Double(section) * cellWidth) + (Double(section) * horizontalPadding)
                        var yPos: Double
                        if section == 0 {
                            if item == 0 {
                                yPos = 0
                            } else if !round1IsPlayIn {
                                let cellSpread = bracketHeight / Double(collectionView.numberOfItems(inSection: section) - 1)
                                yPos = (cellSpread * Double(item)) - (cellSpread / 2.0) + (headerHeight / 2)
                            } else {
                                // TODO: - figure out how to lay these first round games out in a way that positions them to play into the appropriate games
                                yPos = (Double(item) * cellHeight) + (Double(item) * largestSectionPadding)
                            }
                        } else if section == 1 {
                            if item == 0 {
                                yPos = 0
                            } else {
                                if round1IsPlayIn {
                                    yPos = (Double(item) * cellHeight) + (Double(item) * largestSectionPadding)
                                } else {
//                                    yPos = ((((contentHeight) / Double(collectionView.numberOfItems(inSection: section))) * Double(item)) + (Double(item) * cellHeight / 2))
                                    let cellSpread = bracketHeight / Double(collectionView.numberOfItems(inSection: section) - 1)
                                    yPos = (cellSpread * Double(item)) - (cellSpread / 2.0) + (headerHeight / 2)
                                }
                            }
                        } else {
                            if item == 0 {
                                yPos = 0
                            } else {
//                                yPos = ((((contentHeight) / Double(collectionView.numberOfItems(inSection: section))) * Double(item)) + (Double(item) * cellHeight / 2))
                                let cellSpread = bracketHeight / Double(collectionView.numberOfItems(inSection: section) - 1)
                                yPos = (cellSpread * Double(item)) - (cellSpread / 2.0) + (headerHeight / 2)
                            }
                        }
                        
                        let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
                        cellAttributes.frame = CGRect(x: xPos, y: yPos, width: cellWidth, height: cellHeight)
                        if section == 0 && item == 0 {
                            cellAttributes.zIndex = 4
                        } else if section == 0 {
                            cellAttributes.zIndex = 3
                        } else if item == 0 {
                            cellAttributes.zIndex = 2
                        } else {
                            cellAttributes.zIndex = 1
                        }
                        
                        cellAttributesDictionary[cellIndex] = cellAttributes
                    }
                }
            }
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        
        for cellAttributes in cellAttributesDictionary.values {
            if rect.intersects(cellAttributes.frame) {
                attributesInRect.append(cellAttributes)
            }
        }
        return attributesInRect
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttributesDictionary[indexPath]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
    // MARK: - Helper functions
    
    
    
    
    // MARK: - for decoration view that will draw the bracket lines.
    
    //    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    //        <#code#>
    //    }
    //
    //    override func initialLayoutAttributesForAppearingDecorationElement(ofKind elementKind: String, at decorationIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    //        <#code#>
    //    }
}
