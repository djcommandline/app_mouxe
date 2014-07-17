//
//  CustomFlowLayout.swift
//  Mouxe
//
//  Created by Will on 7/11/14.
//  Copyright (c) 2014 Will. All rights reserved.
//

import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool  {
    
        return true
        
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]! {
        
        var result: NSMutableArray = NSMutableArray(array: super.layoutAttributesForElementsInRect(rect))
        var attributeKinds: AnyObject! = result.valueForKeyPath("representedElementKind")
        var headerIndex: NSInteger = attributeKinds.indexOfObject(UICollectionElementKindSectionHeader)
        if headerIndex != NSNotFound {
            result.removeObjectAtIndex(headerIndex)
        }
  
        var contentOffset = self.collectionView.contentOffset
        var headerSize: CGSize = self.headerReferenceSize
        
        var newHeaderAttributes: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: NSIndexPath(forItem: 0, inSection: 0))
       
        var frame = CGRectMake(0, contentOffset.y, headerSize.width, headerSize.height)
        newHeaderAttributes.frame = frame;
        newHeaderAttributes.zIndex = 1024;
        
        result.addObject(newHeaderAttributes)
        
        return result
    }
    

}
