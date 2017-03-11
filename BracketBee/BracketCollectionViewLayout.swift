//
//  BracketCollectionViewLayout.swift
//  BracketBee
//
//  Created by Keaton Harward on 3/10/17.
//  Copyright © 2017 Keaton Harward. All rights reserved.
//

import UIKit

class BracketCollectionViewLayout: UICollectionViewLayout {
    
    let CELL_HEIGHT = 30.0
    let CELL_WIDTH = 100.0
    
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
        
        if !dataSourceDidUpdate {
            let xOffset = collectionView.contentOffset.x
            let yOffset = collectionView.contentOffset.y
            
            if collectionView.numberOfSections > 0 {
                for section in 0...collectionView.numberOfSections - 1 {
                    
                    if collectionView.numberOfItems(inSection: section) > 0 {
                        
                        if section == 0 {
                            for item in 0...collectionView.numberOfItems(inSection: section) - 1 {
                                
                                let indexPath = IndexPath(item: item, section: section)
                                
                                if let attributes = cellAttributesDictionary[indexPath] {
                                    var frame = attributes.frame
                                    
                                    if item == 0 {
                                        frame.origin.x = xOffset
                                    }
                                    
                                    frame.origin.y = yOffset
                                    attributes.frame = frame
                                }
                            }
                        } else {
                            let indexPath = IndexPath(item: 0, section: section)
                            
                            if let attributes = cellAttributesDictionary[indexPath] {
                                var frame = attributes.frame
                                frame.origin.x = xOffset
                                attributes.frame = frame
                            }
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
                        let xPos = Double(item) * CELL_WIDTH
                        let yPos = Double(section) * CELL_HEIGHT
                        
                        let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
                        cellAttributes.frame = CGRect(x: xPos, y: yPos, width: CELL_WIDTH, height: CELL_HEIGHT)
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
        let contentWidth = Double(collectionView.numberOfItems(inSection: 0)) * CELL_WIDTH
        let contentHeight = Double(collectionView.numberOfSections) * CELL_HEIGHT
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
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
    
    
    
    // MARK: - for decoration view that will draw the bracket lines.
    
    //    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    //        <#code#>
    //    }
    //
    //    override func initialLayoutAttributesForAppearingDecorationElement(ofKind elementKind: String, at decorationIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    //        <#code#>
    //    }
}