//
//  LoadingViewController.swift
//  Mauxe
//
//  Created by Will on 7/10/14.
//  Copyright (c) 2014 Will. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    var titleLabel = UILabel()
    
    var spinner = UIActivityIndicatorView()
    
    init(){
    
        super.init(nibName: nil, bundle: nil)
        
        var string = NSMutableAttributedString(string: "mouxe")
        string.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size:114/2.0), range: NSMakeRange(2, 2))
        string.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-UltraLight", size:114/2.0), range: NSMakeRange(0, 2))
        string.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-UltraLight", size:114/2.0), range: NSMakeRange(4, 1))
        string.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, 5))
        
        var loading = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, 1136/2))
        loading.image = UIImage(named: "Launch@2x.png")
        self.view.addSubview(loading)
        
        spinner = UIActivityIndicatorView(frame: CGRectMake((self.view.frame.size.width - 20)/2, (self.view.frame.size.height - 20)/2, 20, 20))
        spinner.startAnimating()
        self.view.addSubview(spinner)
        
        
        titleLabel = UILabel(frame: CGRectMake(0, 307/2, 320, 137/2))
        titleLabel.attributedText = string
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(titleLabel)
        
    }
    
    func transitionWithHandler(handler: () -> Void) {
        print("Called")
        
        UIView.animateWithDuration(0.3, animations: {
            
            self.spinner.removeFromSuperview()
            self.titleLabel.frame = CGRectMake(0, 21/2, 320, 137/2)
            print("Called")
            
            }, completion: { (fininshed: Bool) -> () in
                print("Called")
                handler()
                
            })
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        println("Hello")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
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
