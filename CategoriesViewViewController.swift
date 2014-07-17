//
//  CategoriesViewViewController.swift
//  Mauxe
//
//  Created by Will on 7/10/14.
//  Copyright (c) 2014 Will. All rights reserved.
//

import UIKit

class CategoriesViewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var titleLabel = UILabel()
    
    var dataSource = NSMutableArray()
    
    var dataObjects = NSMutableArray()
    
    var tableView: UITableView = UITableView()
    
    var conceptsLabel: UILabel = UILabel()
    
    init(data:NSMutableArray, categories: NSArray){
        
        super.init(nibName: nil, bundle: nil)
        
        var string = NSMutableAttributedString(string: "mouxe")
        string.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size:114/2.0), range: NSMakeRange(2, 2))
        string.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-UltraLight", size:114/2.0), range: NSMakeRange(0, 2))
        string.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-UltraLight", size:114/2.0), range: NSMakeRange(4, 1))
        string.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, 5))
        
        var background = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, 1136/2))
        background.image = UIImage(named: "Launch@2x.png")
        self.view.addSubview(background)
        
        dataObjects = data
        
        dataSource = categories as NSMutableArray
        println("\(dataSource)")
        
        tableView = UITableView(frame: CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 235/2), style: UITableViewStyle.Plain)
        tableView.rowHeight = 50
        tableView.backgroundColor = UIColor(red: 161/255.0, green: 161/255.0, blue: 161/255.0, alpha: 0.5)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        self.view.addSubview(tableView)
        
        conceptsLabel = UILabel(frame: CGRectMake(0, 147/2, 320, 58/2))
        conceptsLabel.font = UIFont(name: "HelveticaNeue-Light", size: 49/2)
        conceptsLabel.textColor = UIColor(red: 145/255.0, green: 179/255.0, blue: 190/255.0, alpha: 1)
        conceptsLabel.alpha = 0;
        conceptsLabel.textAlignment = NSTextAlignment.Center
        conceptsLabel.text = "concepts"
        self.view.addSubview(conceptsLabel)
        
        titleLabel = UILabel(frame: CGRectMake(0, 21/2, 320, 137/2))
        titleLabel.attributedText = string
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(titleLabel)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int  {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int  {
        
        return dataSource.count
        
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        var string = dataSource.objectAtIndex(indexPath.row).objectForKey("Concept").objectForKey("text") as NSString
        
        println("Stringading \(string)")
        
        self.navigationController.pushViewController(ConceptContainerViewController(data: dataObjects, andConcept: string), animated: true)
        
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var newCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        newCell.textLabel.text = dataSource.objectAtIndex(indexPath.row).objectForKey("Concept").objectForKey("text") as NSString
        
        var view = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        view.backgroundColor = UIColor(white: 0, alpha: 0.2)
        newCell.selectedBackgroundView = view
        
        newCell.textLabel.textColor = UIColor.whiteColor()
        newCell.backgroundColor = UIColor.clearColor()
        var separatorLineView = UIView(frame: CGRectMake(0, 0, 320, 0.5))
        separatorLineView.backgroundColor = UIColor(red: 151/255.0, green: 174/255.0, blue: 183/255.0, alpha: 1)
        newCell.contentView.addSubview(separatorLineView)
        return newCell;
        
    }
    
    override func viewDidAppear(animated: Bool)  {
        
        UIView.animateWithDuration(0.5, animations: {
            
            self.conceptsLabel.alpha = 1;
            self.tableView.frame = CGRectMake(0, 235/2, self.view.frame.size.width, self.view.frame.size.height - 235/2)
            
            })
    }
    
    override func viewDidDisappear(animated: Bool)  {
        
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow(), animated: false)
        
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
