//
//  ImageStackViewController.swift
//  Mouxe
//
//  Created by Will on 7/12/14.
//  Copyright (c) 2014 Will. All rights reserved.
//

import UIKit

class ImageStackViewController: UIPageViewController, UIGestureRecognizerDelegate {
    
    var imageStack: NSArray?

    var currentProjectName: String?
    
    var allowForPaging: Bool = true
    
    init(stack: NSArray) {
        
        
        super.init(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        
        self.view.backgroundColor = UIColor.blackColor()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for controller in self.viewControllers {
            
            println("Recognize \((controller as UIViewController).view.gestureRecognizers)")
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
