//
//  ConceptCollectionViewController.swift
//  Mauxe
//
//  Created by Will on 7/11/14.
//  Copyright (c) 2014 Will. All rights reserved.
//

import UIKit
import QuartzCore

extension Array {
    var last: T {
    return self[self.endIndex - 1]
    }
}

class ScreenShotViewController: UIViewController {
    
    //index for the page view controller delgate methods (location of data)
    var index: NSIndexPath?
    
    var imageView: UIImageView?
    var image: UIImage?
    
    var data: PttrnDataObject?
    
    var spinner: UIActivityIndicatorView?
    var isNewProject: Bool = false
    var tempCover: UIView?
    var label: UILabel?
    
    init(newData: PttrnDataObject) {
        
        
        super.init(nibName: nil , bundle: nil)
        
        self.view.backgroundColor = UIColor.blackColor()
        
        spinner = UIActivityIndicatorView(frame: CGRectMake((self.view.frame.size.width - 20)/2, (self.view.frame.size.height - 20)/2, 20, 20))
        spinner!.startAnimating()
        spinner!.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        self.view.addSubview(spinner!)
        
        data = newData
        
        //download the image in the background
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            var imageLink = NSURL(string: self.data!.imageLink)
            
            println("Data \(imageLink)")
            
            var imageForStack = UIImage(data: NSData(contentsOfURL: imageLink))
            
            self.image = imageForStack

                //on completion, remove the spinner and present the image view
                dispatch_sync(dispatch_get_main_queue(), {
                    self.spinner?.stopAnimating()
                    self.spinner?.removeFromSuperview()
                    
                    var dimensions = self.image!.size.height / self.image!.size.width
                    
                    var height:CGFloat = dimensions == 1.775 ? 1136/2 : 960/2
                    
                    self.imageView = UIImageView(image: self.image)
                    self.imageView!.frame = CGRectMake(0, (self.view.frame.size.height - height)/2, 320, height)
                    self.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
                    self.view.addSubview(self.imageView)
                    self.view.sendSubviewToBack(self.imageView)
            })
        })
        
    }
    
    //method called for transitioning to a new project, consists of a .75 alpha cover view with white label on top with the project name
    func showProjectInfo() -> (){
        
        if tempCover {
            return
        }
        
        println("Show project info----------------------")
        
        isNewProject = true
        
        tempCover = UIView(frame: self.view.frame)
        tempCover!.backgroundColor = UIColor(white: 0, alpha: 1)
        tempCover!.alpha = 0.8
        self.view.addSubview(tempCover)
        
        label = UILabel(frame: CGRectMake((self.view.frame.width - (self.view.frame.width - 30))/2, 0, self.view.frame.width - 30, self.view.frame.height))
        label!.text = data?.project
        label!.font = UIFont(name: "HelveticaNeue-Medium", size: 64/2)
        label!.numberOfLines = 0
        label!.textAlignment = NSTextAlignment.Center
        label!.textColor = UIColor.whiteColor()
        self.view!.addSubview(label)
    }
    
    //hide project info, called when the view is presented
    func hideProjectInfo() -> () {
        
        if !isNewProject {
            return
        }
        
        UIView.animateWithDuration(0.75, animations: {
        
            self.tempCover!.alpha = 0
            self.label!.alpha = 0
            
            }, completion: { (fininshed: Bool) -> () in
                
                self.tempCover!.removeFromSuperview()
                self.tempCover = nil
                self.label!.removeFromSuperview()
                self.label = nil
                self.isNewProject = false
                
            })
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        

        
        
    }
    
    
}

class ConceptContainerViewController: UIViewController, UIGestureRecognizerDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    //basic enum for a return value for dragging
    enum AnimationDirection {
        case Up, Down
    }
    
    enum CurrentPan {
        case Vertical, Horizontal, None
    }
    
    //main view controller (image stacks)
    var mainVCView: StacksCollectionViewController?
    
    //detail view controller (page controller)
    var currentDetailView: ImageStackViewController?
    
    //view controller to track the current view controller in the page view, used to compare the pending controllers to determine if it is a new project
    var currentViewController: ScreenShotViewController?
    
    //indexPath.section of the first view controller shown
    var imageStackIndexPath: Int = 0
    
    //array that can be accessed with index path format that holds created controllers for the page view
    var controllersArray: [[AnyObject]] = [[AnyObject]]()
    //array of Pttrn data sorted into array
    var dataArray: [[PttrnDataObject]] = [[PttrnDataObject]]()
    
    //the image view of the screenshot of the current view being dragged
    var currentlyDraggedImageView: UIImageView?
    
    init(data: NSArray, andConcept: NSString) {
        
        super.init(nibName: nil, bundle: nil)
        
        //dictionary that holds a project name associated with an array of PttrnDataObjects
        var dictionary: Dictionary<String, NSMutableArray> = Dictionary()
        
        //loop through unsorted data
        for object in data {
            
            if let dataObject = object as? PttrnDataObject {
                
                if(!dataObject.project) {
                    continue;
                }
                
                //if the project has not already been entered into the dictionary, a new array with the data and the project name as the key
                if (!dictionary[dataObject.project!]) {
                    
                    let newArray = NSArray(object: dataObject)
                    
                    
                    dictionary[dataObject.project!] = NSMutableArray(object: dataObject)
                }

                //if it does, just add it to the dictionary array
                else {
                    
                    dictionary[dataObject.project!]!.addObject(dataObject)
                }
            }
        }
    
        //present the stackview controller
        self.presentMainVC((StacksCollectionViewController(data: dictionary, andConcept: andConcept)))
        
        //create data array by reorgonizing the dictionary into an array of arrays (for pageview delegate)
        for string in mainVCView!.arrayOfKeys {

            var newArray: [PttrnDataObject] = [PttrnDataObject]()
            
            var arrayForControllers: [AnyObject] = [AnyObject]()
            
            for dataObject in mainVCView!.dataDictionary.objectForKey(string) as NSArray {
                
                newArray += dataObject as PttrnDataObject
                arrayForControllers += NSObject()
                
            }
            
            dataArray += newArray
            controllersArray += arrayForControllers //fill the controller array with place holders

        }
        
    }
    
    func presentMainVC(VC: UIViewController) {
        
        //1. Add the detail controller as child of the container
        self.addChildViewController(VC)
        
        //2. Define the detail controller's view size
        VC.view.frame = CGRectMake(0, 0, 320, 1136/2);
        
        //3. Add the Detail controller's view to the Container's detail view and save a reference to the detail View Controller
        self.view.addSubview(VC.view)
        
        //4. Complete the add flow calling the function didMoveToParentViewController
        VC.didMoveToParentViewController(self)
        
        //set the main view controller
        self.mainVCView = (VC as StacksCollectionViewController)
    }
    
    func presentDetailVC(dataStack: NSArray) {
    
        var VC: ImageStackViewController = ImageStackViewController(stack: dataStack)
    
        currentDetailView = VC
        
        VC.delegate = self
        VC.dataSource = self
        
        //1. Add the detail controller as child of the container
        self.addChildViewController(VC)
        
        //2. Define the detail controller's view size
        VC.view.frame = CGRectMake(0, 0, 320, 1136/2);
        
        //3. Add the Detail controller's view to the Container's detail view and save a reference to the detail View Controller
        self.view.addSubview(VC.view)
        
        var panGuestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
        panGuestureRecognizer.delegate = self
        VC.view.addGestureRecognizer(panGuestureRecognizer)
        
        //4. Complete the add flow calling the function didMoveToParentViewController
        VC.didMoveToParentViewController(self)
        
        
        //get the newest view controller
        var viewController: ScreenShotViewController
        
        
        if !(controllersArray[imageStackIndexPath][0] as? ScreenShotViewController) {
            //if the controller has not been created, create it
            viewController = ScreenShotViewController(newData: dataArray[imageStackIndexPath][0])
            viewController.index = NSIndexPath(forRow: 0, inSection: imageStackIndexPath)
            controllersArray[imageStackIndexPath][0] = viewController

        }
        
        else {
            //else get the controller from the controller array
            viewController = controllersArray[imageStackIndexPath][0] as ScreenShotViewController
            
        }
        
        //set the current controller
        currentViewController = viewController
        
        //set the first view controller of the page view
        currentDetailView!.setViewControllers([viewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        //prevent any scrolling ect on the below view
        self.mainVCView!.view.userInteractionEnabled = false
        
        //turn of swipe to go back
        self.navigationController.interactivePopGestureRecognizer.enabled = false

    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer!) -> Bool {
        
        if gestureRecognizer.locationInView(currentDetailView!.view).y <= 128/2 {
            
            //if the touch is in the specified region (upper portion of the view)
            
            
            //create screenshot
            if UIScreen.mainScreen().respondsToSelector(Selector("scale")) {
            
                UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, UIScreen.mainScreen().scale)
            }
            
            else {
            
                UIGraphicsBeginImageContext(self.view.frame.size)
            
            }
            
            self.view.layer.renderInContext(UIGraphicsGetCurrentContext())
            
            //pass screenshot to temporary image
            var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            //create an image view and pass it to currrently dragged image view
            var imageView: UIImageView = UIImageView(image: image)
            
            imageView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height)
            
            self.currentlyDraggedImageView = imageView
            
            //hide the actual view
            currentDetailView!.view.hidden = true
            
            //replace it with the screenshot
            self.view.addSubview(currentlyDraggedImageView)
        
            return true
            
        }
        
        return false
    }
    
    /* useless method that took a lot of time so i dont want to delete it

    func accellerationAnimation(fromValue: CGPoint, atSpeed: CGPoint, toValue: CGPoint, atToSpeed: CGPoint) -> CAKeyframeAnimation {
        
        
        //create animation to return
        var animationToReturn: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        
        animationToReturn.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        //set a decelleration rate that doubles as an acceleration rate
        var decellerationRate = -625.0 //px/s
        
        if atSpeed.y < atToSpeed.y {
            //if the speed of the throw is more negative that the target, accellerate it towards 0
            decellerationRate = -decellerationRate
        }
        
        //throwing upward
        if toValue.y < fromValue.y {
            
            //get change in position
            var finalDeltaD = toValue.y - fromValue.y
            
            var vInitial = atSpeed.y
            
            var deltaV = atToSpeed.y - atSpeed.y
            
            println("Delta V: \(deltaV)")
            
            var deltaT = deltaV / decellerationRate
            
            println("Delta T: \(deltaT)")
            
            //solve for the distance of that decelleration
            var deltaD = (vInitial * deltaT) + (0.5 * decellerationRate * (deltaT * deltaT))
            
            println("Delta D: \(deltaD)")
            
            if deltaD < finalDeltaD {
                
                //if the decelleration moves it past the goal, find how long that would take, solving for t and using final D as d
                var sqrtPortion = sqrt((4 * (vInitial * vInitial)) - (4 * decellerationRate * (-2 * finalDeltaD)))
                println("Sqrt Portion: \(sqrtPortion)")
                
                //add negatives to get from x - r to r
                var tempTPlus = -((2 * vInitial + sqrtPortion) / (2 * decellerationRate))
                var tempTMinus = -((2 * vInitial - sqrtPortion) / (2 * decellerationRate))
                
                println("Minus: \(tempTMinus)")
                println("Plus: \(tempTPlus)")
                
                //this will reach the top twice, once when at a negative velocity, and again at a positive velocity coming back
                //the smallest is what we want
                deltaT = tempTPlus < tempTMinus ? tempTPlus : tempTMinus
                
                println("Delta T: \(deltaT)")
                
                //set animation duration
                animationToReturn.duration = deltaT
                
                //get miliseconds of a second
                var miliseconds: Int = Int(deltaT * 1000 + 0.5)
                
                //create arrays to store time and value keys
                var valueKeys: [NSValue] = [NSValue]()
                var timeKeys: [NSNumber] = [NSNumber]()
                
                //create values to hold the most recent speed and location
                var lastYValue = fromValue.y
                var currentVelocity = atSpeed.y
                
                //loop through miliseconds, but save the last one to ensure that the rect is at 0,0
                for time in 1..<miliseconds {
                    
                    lastYValue += currentVelocity * 0.001
                    
                    
                    valueKeys += NSValue(CGPoint: CGPointMake(0.5 * self.view.frame.size.width, lastYValue + 0.5 * self.view.frame.size.height))
                    timeKeys += NSNumber(float: Float(time) / Float(miliseconds))
                    
                    //accellerate velocity
                    currentVelocity += decellerationRate * 0.001
                    
                }
                
                //add 0,0 and 1
                valueKeys += NSValue(CGPoint: CGPointMake(0.5 * self.view.frame.size.width, 0.5 * self.view.frame.size.height))
                timeKeys += NSNumber(float: 1)
                
                //add the values and times to animation
                animationToReturn.values = valueKeys
                animationToReturn.keyTimes = timeKeys
                
                return animationToReturn
            }
            
        }
        
        
        
        return CAKeyframeAnimation()
    }
    */

    
    func handlePan(sender: UIPanGestureRecognizer) {
        
        var pointTranslation = sender.translationInView(currentDetailView!.view) //get translation (distance moved from initial touch)
        
        var pointLocation = sender.locationInView(currentDetailView!.view) //get location (current location of touch)
        
        var speed = sender.velocityInView(currentDetailView!.view) //get speed (current velocity it pts/sec
        
        if !(pointTranslation.y < 0) {
            //prevent the view from being dragged to far up
            currentlyDraggedImageView!.frame = CGRectMake(0, pointTranslation.y, self.view.frame.size.width, self.view.frame.size.height)
        }
        
        if sender.state == UIGestureRecognizerState.Ended {
            
            //if the pan has ended ge the direction to throw the view
            
            var direction: AnimationDirection
            
            //if the point is in the bottom half of the view and...
            if pointTranslation.y > (self.view.frame.size.height / 2.0) {
                
                //it is moving down then...
                if speed.y >= 0 {
                    //move it down
                    direction = AnimationDirection.Down
                }
                
                //it is moving up then...
                else {
                    //move it up
                    direction = AnimationDirection.Up
                }
                
            }
            
            //if the point is in the top half of the view and...
            else {
                
                //if it is moving upward then...
                if speed.y <= 0 {
                    //move it up
                    direction = AnimationDirection.Up
                }
                    
                //if it is moving down then...
                else {
                    //move it down
                    direction = AnimationDirection.Down
                }
                
                
            }
            
            //adjust the speed to be faster so the animation doesnt take to long
            if speed.y < 0 {
                
                if speed.y > -1000 {
                    
                    speed.y = -1000
                    
                }
                
            }
                
            else {
                if speed.y < 2000 {
                    
                    speed.y = 2000
                    
                }
            }
            
            //get the animation time from the distance moved divided by the speed
            var animationTime: CGFloat = pointTranslation.y / speed.y
            
            //make sure its not negative
            animationTime = animationTime < 0 ?  -animationTime : animationTime
            
            //if it should move down then...
            if direction == AnimationDirection.Down {
                
                UIView.animateWithDuration(animationTime, delay: 0.0, options: UIViewAnimationOptions.CurveLinear,  animations: {
                    
                    //move the image view to the bottom of the frame
                    self.currentlyDraggedImageView!.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)
                    
                    }, completion: { (fininshed: Bool) -> () in
                    
                        self.mainVCView!.view.userInteractionEnabled = true //allow user interaction
                        self.currentlyDraggedImageView!.removeFromSuperview() //remove the screenshot
                        self.currentlyDraggedImageView = nil //set the currentlyDraggedImageView to nil
                        self.currentDetailView!.view.removeFromSuperview() //remove the detail view
                        self.currentDetailView!.removeFromParentViewController() //remove the controller
                        self.currentDetailView = nil //set it to nil
                        self.navigationController.interactivePopGestureRecognizer.enabled = true //allow backwards swipe
                    })
                
                
            }
            
            //if it should move up then...
            else {
                
                UIView.animateWithDuration(animationTime, delay: 0.0, options: UIViewAnimationOptions.CurveLinear,  animations: {
                    
                    //move the screenshot to the top of the view
                    self.currentlyDraggedImageView!.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                    
                    
                    }, completion: { (fininshed: Bool) -> () in
                        
                        self.currentDetailView!.view.hidden = false //unhide the detail view
                        self.currentlyDraggedImageView!.removeFromSuperview() //remove the image view
                        self.currentlyDraggedImageView = nil //set it to nil
                        
                    })
            }
        }
    }
    
    func presentDetainViewControllerWith(data: NSArray, topImage: UIImage, topImageStartingRect: CGRect, initialIndexPath: Int) {
        
        var dimensions = topImage.size.height / topImage.size.width
        
        println("\(dimensions)")
        
        var height:CGFloat = dimensions == 1.775 ? 476/2 : 402/2
        
        var yVal = 10.0
        
        yVal += height == 402/2 ? 37/2 : 0
        
        var imageViewToScale: UIImageView = UIImageView(image: topImage)
        
        imageViewToScale.frame = CGRectMake(15 + topImageStartingRect.origin.x, topImageStartingRect.origin.y + yVal, 268/2, height)
        
        self.view.addSubview(imageViewToScale)
        
        imageStackIndexPath = initialIndexPath
        
        UIView.animateWithDuration(0.3, animations: {
            
            imageViewToScale.frame = CGRectMake(0, dimensions == 1.775 ? 0 : 44, 320, dimensions == 1.775 ? 1136/2 : 960/2)
            
            }, completion: { (fininshed: Bool) -> () in
                
                
            self.presentDetailVC(data)
                
            imageViewToScale.removeFromSuperview()
                
        })
        
    }
    
    func pageViewController(pageViewController: UIPageViewController!, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject]!, transitionCompleted completed: Bool) {
        
        var current: ScreenShotViewController = pageViewController.viewControllers[0] as ScreenShotViewController
        
        if current.index?.section != currentViewController?.index?.section {
        
            current.hideProjectInfo()
            
        }
        
        currentViewController = current
        
        
    }
    
    func pageViewController(pageViewController: UIPageViewController!, willTransitionToViewControllers pendingViewControllers: [AnyObject]!) {
        
        var nextController = pendingViewControllers[0] as ScreenShotViewController
        
        if nextController.index?.section != currentViewController?.index?.section {
            
            nextController.showProjectInfo()
            
        }
        
    }
    
    
    //delegate for the paged view
    func pageViewController(pageViewController: UIPageViewController!, viewControllerAfterViewController viewController: UIViewController!) -> UIViewController! {
        
        var indexPath: NSIndexPath = (viewController as ScreenShotViewController).index!
        
        println("Current \(indexPath.section, indexPath.row)")
        
        var shouldShowProject: Bool = false
        
        if indexPath.row == dataArray[indexPath.section].count - 1 {
            
            if indexPath.section == dataArray.count - 1 {
                return nil
            }
            
            indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section + 1)
            
            shouldShowProject = true
            
        }
        else {
            
            indexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
            
        }
    
        println("Next \(indexPath.section, indexPath.row)")
        
        var controllerToReturn: ScreenShotViewController
        
        if !(controllersArray[indexPath.section][indexPath.row] as? ScreenShotViewController) {
            
            controllerToReturn = ScreenShotViewController(newData: dataArray[indexPath.section][indexPath.row])
            controllerToReturn.index = indexPath
            if shouldShowProject {
                println("Show info ------------------- \(indexPath.section, indexPath.row)")
                //controllerToReturn.showProjectInfo()
            }
            controllersArray[indexPath.section][indexPath.row] = controllerToReturn
            
        }
            
        else {
            
            controllerToReturn = controllersArray[indexPath.section][indexPath.row] as ScreenShotViewController
            if shouldShowProject {
                println("Show info ------------------- \(indexPath.section, indexPath.row)")
                //controllerToReturn.showProjectInfo()
            }
        }
        
        return controllerToReturn
        
    }
    
    func pageViewController(pageViewController: UIPageViewController!, viewControllerBeforeViewController viewController: UIViewController!) -> UIViewController! {
        
        var indexPath: NSIndexPath = (viewController as ScreenShotViewController).index!
        
        var shouldShowProject: Bool = false
        
        println("Current \(indexPath.section, indexPath.row)")
        
        if indexPath.row == 0 {
            
            if indexPath.section == 0 {
                return nil
            }
            
            indexPath = NSIndexPath(forRow: controllersArray[indexPath.section - 1].count - 1, inSection: indexPath.section - 1)
            
            shouldShowProject = true
            
        }
        else {
            
            indexPath = NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)
            
        }
        
        println("Previous \(indexPath.section, indexPath.row)")
        
        var controllerToReturn: ScreenShotViewController
        
        if !(controllersArray[indexPath.section][indexPath.row] as? ScreenShotViewController) {
            
            controllerToReturn = ScreenShotViewController(newData: dataArray[indexPath.section][indexPath.row])
            controllerToReturn.index = indexPath
            if shouldShowProject {
                println("Show info ------------------- \(indexPath.section, indexPath.row)")
                //controllerToReturn.showProjectInfo()
            }
            controllersArray[indexPath.section][indexPath.row] = controllerToReturn
            
        }
            
        else {
            controllerToReturn = controllersArray[indexPath.section][indexPath.row] as ScreenShotViewController
            if shouldShowProject {
                println("Show info -------------------- \(indexPath.section, indexPath.row)")
                //controllerToReturn.showProjectInfo()
            }
        }
        
        return controllerToReturn
        
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
