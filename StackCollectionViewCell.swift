//
//  StackCollectionViewCell.swift
//  Mauxe
//
//  Created by Will on 7/11/14.
//  Copyright (c) 2014 Will. All rights reserved.
//

import UIKit

class StackCollectionViewCell: UICollectionViewCell {
    
    var imageStack: NSArray?
    let app: NSString = NSString()
    var isConfigured: Bool = false

    
    var selfTopImage: UIImage?

    init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
                // Initialization code
    }
    
    func configureWithImageStack(stack: NSArray, topImage: UIImage?, andApp: NSString) {
        
        for tempView in self.contentView.subviews {
            tempView.removeFromSuperview()
        }
        

        imageStack = NSArray(array: stack)
        
        var dimensions = topImage!.size.height / topImage!.size.width
        
        println("\(dimensions)")
        
        var height:CGFloat = dimensions == 1.775 ? 476/2 : 402/2
        
        println("\(height)")
        
        var topSet = false
        
        var appLabel = UILabel(frame: CGRectMake(0, 515/2, 320/2, 29/2))
        appLabel.text = "\(andApp) [\(imageStack!.count)]"
        appLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 12)
        appLabel.textAlignment = NSTextAlignment.Center
        self.contentView.addSubview(appLabel)
        
        
        if topImage {
            
            selfTopImage = topImage
            
            var imageView: UIImageView = UIImageView(image: topImage)
            var xVal: CGFloat = 15
            var yVal: CGFloat = 10
            yVal += height == 402/2 ? 37/2 : 0
            println("\(yVal)")
            imageView.frame = CGRectMake(CGFloat(xVal), CGFloat(yVal), 268/2, height)
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            
            self.contentView.addSubview(imageView)
        }
        
        else {
            var viewOutline: UIView = UIView(frame: CGRectMake(15, 10, 268/2, 478/2))
            viewOutline.backgroundColor = UIColor.whiteColor()
            viewOutline.layer.borderColor = UIColor.grayColor().CGColor
            viewOutline.layer.borderWidth = 1
            self.contentView.addSubview(viewOutline)
            self.contentView.sendSubviewToBack(viewOutline)
        }
        
       
        
        for i in 1...2 {
            var xVal = 15 + Float(i) * 2.5
            var yVal = 10 + Float(i) * 2.5
            yVal += height == 402/2 ? 37/2 : 0
            
            var viewOutline: UIView = UIView(frame: CGRectMake(CGFloat(xVal), CGFloat(yVal), 268/2, height))
            viewOutline.backgroundColor = UIColor.whiteColor()
            viewOutline.layer.borderColor = UIColor.lightGrayColor().CGColor
            viewOutline.layer.borderWidth = 1
            self.contentView.addSubview(viewOutline)
            self.contentView.sendSubviewToBack(viewOutline)
        }
        
        /*
        
        for var i:Int = 0; i <= 3; ++i {
            
            if imageStack!.count >= i+1 {
                
                var data: PttrnDataObject = stack.objectAtIndex(i) as PttrnDataObject
            
                var imageLink = NSURL(string: data.imageLink)
                
                var imageForStack = UIImage(data: NSData(contentsOfURL: imageLink))
                var imageView: UIImageView = UIImageView(image: imageForStack)
                var xVal = 15 + Float(i) * 2.5
                var yVal = 10 + Float(i) * 2.5
                
                imageView.frame = CGRectMake(CGFloat(xVal), CGFloat(yVal), 268/2, 478/2)
                imageView.contentMode = UIViewContentMode.ScaleAspectFit

                self.contentView.addSubview(imageView)
                
                if !topSet {
                    
                    topImageView = imageView
                    topSet = true
                    
                }
                
            }
            
            else {
        
                
                var xVal = 15 + Float(i) * 2.5
                var yVal = 10 + Float(i) * 2.5
                
                var viewOutline: UIView = UIView(frame: CGRectMake(CGFloat(xVal), CGFloat(yVal), 268/2, 478/2))
                viewOutline.backgroundColor = UIColor.whiteColor()
                viewOutline.layer.borderColor = UIColor.grayColor().CGColor
                viewOutline.layer.borderWidth = 1
                self.contentView.addSubview(viewOutline)
                self.contentView.sendSubviewToBack(viewOutline)

            }
            isConfigured = true
            
        }

*/
        
    }
}
