//
//  HeaderCollectionReusableView.swift
//  Mouxe
//
//  Created by Will on 7/11/14.
//  Copyright (c) 2014 Will. All rights reserved.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    
    var button: UIButton = UIButton()
    
    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
    }
    
    func configureWithName(name:NSString) {
        var toolBar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        toolBar.barStyle = UIBarStyle.Default
        toolBar.barTintColor = UIColor.whiteColor()
        self.addSubview(toolBar)
        
        button.frame = CGRectMake(15, (self.frame.size.height - 18)/2, 22, 18)
        button.setImage(UIImage(named: "Backarrow@2x.png"), forState: UIControlState.Normal)
        self.addSubview(button)
        
        var label = UILabel(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 48/2)
        label.textAlignment = NSTextAlignment.Center
        label.text = name
        self.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.blackColor()
        self.addSubview(label)
        
    }
    
}
