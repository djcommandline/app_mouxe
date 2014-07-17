//
//  PttrnDataObject.swift
//  Mauxe
//
//  Created by Will on 7/10/14.
//  Copyright (c) 2014 Will. All rights reserved.
//

import UIKit

class PttrnDataObject: NSObject {
   
    var imageLink: NSString?
    var project: NSString?
    var concept: NSString?
    
    init(jsonDictionary: NSDictionary) {
        
        var imageDict = jsonDictionary.objectForKey("Screenshot") as? NSDictionary
        var projectDict = jsonDictionary.objectForKey("Title") as? NSDictionary
        
        if(projectDict) {
            project = projectDict!.objectForKey("text") as? NSString
            println(project)
        }
        if(imageDict){
            imageLink = imageDict!.objectForKey("href") as? NSString
        }
        
        concept = jsonDictionary.objectForKey("Category") as? NSString

    }

}
