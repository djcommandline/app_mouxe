//
//  DataManager.swift
//  Mauxe
//
//  Created by Will on 7/10/14.
//  Copyright (c) 2014 Will. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    
    class var manager: DataManager {
        
        struct Singleton {
            static let instance = DataManager()
            }
            return Singleton.instance
    }
    
    func fetchDataWithCompletionHandler(completionHandler:(dataObjects: NSArray, categories: NSArray, error: NSError?) -> Void) {
        
        println("Fetch Called")
        
        var allData = NSData(contentsOfURL: NSURL(string: "https://www.kimonolabs.com/api/dhtrq3kk?apikey=fHvEUAUxedVh2VbhcqSRDq9c0OFUaq6D"))
        println("Fetch Called")
        var error: NSError?
    
        var dictionary: NSMutableDictionary = NSJSONSerialization.JSONObjectWithData(allData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSMutableDictionary
        
        var arrayOfDicts: NSArray = dictionary.objectForKey("results").objectForKey("collection1") as NSArray
        
        var arrayOfDataObjectes = NSMutableArray();
        
        for dict: AnyObject in arrayOfDicts {
            
            if dict as? NSDictionary {
                
                arrayOfDataObjectes.addObject(PttrnDataObject(jsonDictionary: dict as NSDictionary))
                println("Fire")
            }
        }
        
        var categoriesData: NSData? = NSData(contentsOfURL: NSURL(string: "https://www.kimonolabs.com/api/bcvslbym?apikey=fHvEUAUxedVh2VbhcqSRDq9c0OFUaq6D"))
        println("Fetch Called")
        var categoriesError: NSError?
        
        var categoriesDictionary: NSMutableDictionary = NSJSONSerialization.JSONObjectWithData(categoriesData!, options: NSJSONReadingOptions.MutableContainers, error: &categoriesError) as NSMutableDictionary
        
        println(categoriesDictionary["name"])
        
        var array = categoriesDictionary.objectForKey("results").objectForKey("collection1") as NSMutableArray
        
        println("Data Objects: \(arrayOfDataObjectes)")
        
        completionHandler(dataObjects: arrayOfDataObjectes, categories: array, error: error)
    
    }
    
   
}
