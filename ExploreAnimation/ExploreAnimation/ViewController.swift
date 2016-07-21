//
//  ViewController.swift
//  ExploreAnimation
//
//  Created by govind gupta on 7/19/16.
//  Copyright © 2016 govind gupta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var blurView : UIView!
    var coverView : UIView!
    var topCurtain :UIImageView!
    var fadedView : UIImageView!
    var bottomCurtain : UIImageView!
    
    
    let menuOption : Array = [["1" : ["A" : ["a":"a","ab":"ab","ac":"ac"],"B" : ["ad":"ad","abd":"abd","acd":"acd"]]],
                              ["2" : ["B" : ["b":"b","bb":"bb","bc":"bc"]]],
                              ["3" : ["C" : ["c":"c","cd":"cd"]]],
                              ["4" : ["D" : ["d":"d","da":"da","db":"db","dc":"dc"]]],]
    
    var selectedPaths : NSMutableArray!
    var menuList : NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect : UIBlurEffect = UIBlurEffect(style:UIBlurEffectStyle.ExtraLight)
        blurView = UIVisualEffectView(effect:blurEffect)
        blurView.frame = CGRectMake(0, 0, self.navigationController!.view.frame.size.width, 20);
        menuList = NSMutableArray()
        selectedPaths = NSMutableArray()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        var numberOfSection : Int = menuOption.count
        if selectedPaths.count != 0 {
            
            numberOfSection = selectedPaths.count + 1;
        }
        
        return numberOfSection;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let numberOfSection = self.numberOfSectionsInTableView(tableView);
        var numberOfRows = 0;
        if (selectedPaths.count != 0) {
            if (section == (numberOfSection - 1)) {
                
                let selectedMenu = (menuList.lastObject as?  NSDictionary)!.valueForKey("infoValue");
                numberOfRows = (selectedMenu!.allKeys?.count)!;
            } else {
                
                numberOfRows = 0;
            }
        }
        else {
            
            let selectedMenu : NSDictionary! = menuOption[section] as NSDictionary;
            numberOfRows = ((selectedMenu.allValues as? NSArray)!.firstObject as! NSDictionary).allKeys.count;
        }
        return numberOfRows;
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var tableViewCell : UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("cell")
        if (tableViewCell == nil) {
            
            tableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        }
        let objectInfo : Dictionary = menuOption[indexPath.section]
        let allKeys : Array = Array(objectInfo.keys)
        
        
        if indexPath.section == 0 {
            tableViewCell.textLabel!.font = UIFont.boldSystemFontOfSize(17);
        }else{
            tableViewCell.textLabel!.font = UIFont.systemFontOfSize(17);
        }
        
        if (selectedPaths.count != 0) {
            
            let selectedMenu : NSDictionary! = (menuList.lastObject as? NSDictionary)!.valueForKey("infoValue") as! NSDictionary;
            let infoKey : String! = selectedMenu.allKeys[indexPath.row] as! String
            tableViewCell.textLabel!.text = infoKey
            // hamburgerMenu =  selectedMenu.valueForKey(infoKey) as! NSDictionary;
        } else {
            
            let selectedMenu : NSDictionary! = menuOption[indexPath.section] as NSDictionary;//["1" : ["A" : ["a":"a","ab":"ab","ac":"ac"]]]
            let infoKey : String! = ((selectedMenu.allValues as? NSArray)!.firstObject as! NSDictionary).allKeys[indexPath.row] as! String
            tableViewCell.textLabel!.text = infoKey
            // hamburgerMenu =  selectedMenu.valueForKey(infoKey) as! NSDictionary;
        }
        //        if (hamburgerMenu.childObjects.count > 0) {
        //
        //            tableCell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ARROW_DOWN_BLACK_ICON]];
        //            tableCell.accessoryView.frame = CGRectMake(0, 0, 12, 10);
        //        } else {
        //            tableCell.accessoryView = [[UIView alloc] initWithFrame:CGRectZero];
        //
        //        }
        
        
        
        return tableViewCell!;
    }
    
    
    func imageWithView(view: UIView, andFrame frame:CGRect) -> UIImage {
        
        
        UIGraphicsBeginImageContext(self.tableView.superview!.bounds.size);
        
        self.tableView.superview!.layer.renderInContext(UIGraphicsGetCurrentContext()!);
        
        let viewImage : UIImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        let rect : CGRect = frame;
        let imageRef : CGImageRef = CGImageCreateWithImageInRect(viewImage.CGImage,rect)!;
        
        let img : UIImage = UIImage(CGImage:imageRef);
        
        
        return img;
    }
    
    func createBackViewForImage() {
        
        fadedView = UIImageView(frame:CGRectMake(0,0,self.view.frame.size.width,self.tableView.frame.size.height));
        fadedView.alpha = 0.4;
        fadedView.backgroundColor = UIColor.whiteColor();
        
    }
    
    func createTopViewForImage(selfPortrait:UIImage, andFrame frame:CGRect, andToframe toframe:CGRect) {
        
        
        topCurtain = UIImageView(frame:CGRectNull);
        topCurtain.image = selfPortrait;
        topCurtain.clipsToBounds = true;
        
        topCurtain.contentMode = UIViewContentMode.Top;
        topCurtain.frame = CGRectMake(0, (toframe.origin.y-coverView.frame.origin.y), self.tableView.frame.size.width, frame.origin.y+44-coverView.frame.origin.y);
        
        coverView.addSubview(topCurtain);
    }
    
    func createBottomViewForImage(selfPortrait:UIImage, andFrame frame:CGRect, andToframe toframe:CGRect) {
        
        bottomCurtain = UIImageView(frame:CGRectNull);
        bottomCurtain.image = selfPortrait;
        bottomCurtain.clipsToBounds = true;
        
        bottomCurtain.contentMode = UIViewContentMode.Bottom;
        bottomCurtain.frame = CGRectMake(0,(topCurtain.frame.origin.y + topCurtain.frame.size.height), self.tableView.frame.size.width, (coverView.frame.size.height - topCurtain.frame.origin.y - topCurtain.frame.size.height));
        
        coverView.addSubview(bottomCurtain);
    }
    
    func curtainRevealViewControllerForState(extend:ObjCBool) {
        
        self.view.userInteractionEnabled = false;
        
        UIView.animateWithDuration(0.5, delay: 0.0,usingSpringWithDamping:1.3, initialSpringVelocity:1 , options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            
            
            var leftFrame : CGRect = self.topCurtain.frame;
            var rightFrame : CGRect = self.bottomCurtain.frame;
            if extend {
                leftFrame.origin.y = leftFrame.origin.y - leftFrame.size.height;
                rightFrame.origin.y = rightFrame.size.height + rightFrame.origin.y;
            } else {
                leftFrame.origin.y = leftFrame.origin.y + leftFrame.size.height;
                rightFrame.origin.y = rightFrame.origin.y - rightFrame.size.height;
            }
            
            
            self.topCurtain.frame = leftFrame;
            
            
            
            
            self.bottomCurtain.frame = rightFrame;
            
            
            } , completion: { (finished: Bool) -> Void in
                
                UIView.animateWithDuration(0.5, delay: 0.0,usingSpringWithDamping:1.3, initialSpringVelocity:1 , options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    
                    
                    self.topCurtain.alpha = 0;
                    self.bottomCurtain.alpha = 0;
                    self.fadedView.alpha = 0;
                    self.coverView.alpha = 0;
                    } , completion: { (finished: Bool) -> Void in
                        
                        self.topCurtain.removeFromSuperview();
                        self.bottomCurtain.removeFromSuperview();
                        self.fadedView.removeFromSuperview();
                        self.coverView.removeFromSuperview();
                        self.view.userInteractionEnabled = true;
                })
        })
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var selectedMenu : NSDictionary?
        var infoKey : String!
        if (selectedPaths.count != 0) {
            
            selectedMenu = (menuList.lastObject as?  NSDictionary)!.valueForKey("infoValue") as? NSDictionary;
            infoKey = selectedMenu!.allKeys[indexPath.row] as! String
            selectedMenu =  selectedMenu!.valueForKey(infoKey as String) as? NSDictionary;
            
        }
        else {
            
            selectedMenu = menuOption[indexPath.section] as NSDictionary;//["1" : ["A" : ["a":"a","ab":"ab","ac":"ac"]]]
            infoKey = selectedMenu!.allKeys[indexPath.row] as! String
            selectedMenu =  selectedMenu!.valueForKey(infoKey as String) as? NSDictionary;
        }
        
        if (selectedMenu?.allKeys.count > 0) {
            
            self.navigationController!.setNavigationBarHidden(true, animated:true);
            self.view.addSubview(blurView);
            menuList.addObject(["infoValue" : (selectedMenu as? NSDictionary!)!, "infoKey" : infoKey]);
            selectedPaths.addObject(indexPath);
            var vissibleCell : NSArray = tableView.indexPathsForVisibleRows!;
            var rectOfCell : CGRect = tableView.rectForRowAtIndexPath(vissibleCell.firstObject as! NSIndexPath);
            rectOfCell = tableView.convertRect(rectOfCell, toView:tableView.superview);
            if (rectOfCell.origin.y < 0) {
                rectOfCell.origin.y = 0;
            }
            coverView = UIView(frame:CGRectMake(0, rectOfCell.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - rectOfCell.origin.y));
            coverView.backgroundColor = UIColor.whiteColor();
            coverView.clipsToBounds = true;
            var selfPortrait : UIImage = self.imageWithView(self.tableView,andFrame:coverView.frame);
            
            self.createBackViewForImage();
            if (selectedPaths.count > 1) {
                
                coverView.addSubview(fadedView);
                
            }
            
            var rectOfCellInTableView : CGRect = tableView.rectForRowAtIndexPath(indexPath);
            rectOfCellInTableView = tableView.convertRect(rectOfCellInTableView, toView:tableView.superview!);
            if (rectOfCellInTableView.origin.y + 44 > self.tableView.frame.size.height) {
                
                rectOfCellInTableView.origin.y = self.tableView.frame.size.height - 44;
            }
            
            self.createTopViewForImage(selfPortrait, andFrame:rectOfCellInTableView, andToframe:rectOfCell);
            self.createBottomViewForImage(selfPortrait, andFrame:rectOfCellInTableView, andToframe:rectOfCell);
            
            self.tableView.tableHeaderView = UIView(frame:CGRectMake(0, 0, self.navigationController!.view.frame.size.width, CGFloat.min));
            
            tableView.reloadData();
            // [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            
            vissibleCell = tableView.indexPathsForVisibleRows!;
            rectOfCell = tableView.rectForRowAtIndexPath(vissibleCell.firstObject as! NSIndexPath)
            rectOfCell = tableView.convertRect(rectOfCell, toView:tableView.superview!);
            if (rectOfCell.origin.y < 0) {
                rectOfCell.origin.y = 0;
            }
            var fadeframe : CGRect = fadedView.frame;
            fadeframe.origin.y = rectOfCell.origin.y - coverView.frame.origin.y;
            fadeframe.size.height = coverView.frame.size.height - fadeframe.origin.y;
            fadedView.frame = fadeframe;
            
            
            var imageframe : CGRect = fadedView.frame;
            imageframe.origin.y = fadedView.frame.origin.y + coverView.frame.origin.y;
            
            var portrait : UIImage = self.imageWithView(self.tableView, andFrame:imageframe);
            fadedView.image = portrait;
            
            self.view.addSubview(coverView);
            
            self.curtainRevealViewControllerForState(true);
            
        } else {
            
        }
    }
    
    
    func tableView(tableView:UITableView, heightForHeaderInSection section:NSInteger) -> CGFloat {
        let numberOfSection = self.numberOfSectionsInTableView(tableView);
        var headerHeight : CGFloat = 44;
        if (selectedPaths.count != 0) {
            if (section == (numberOfSection - 1)) {
                headerHeight = 40;
            } else {
                
                headerHeight = 40;
            }
        } else {
            
            headerHeight = 44;
        }
        return headerHeight;
    }
    
    func tableView(tableView:UITableView, viewForHeaderInSection section:NSInteger) -> UIView {
        
        let height : CGFloat = self.tableView(tableView, heightForHeaderInSection:section);
        
        let headerView : UIView = UIView(frame:CGRectMake(0, 0, tableView.frame.size.width, height));
        
        
        if (selectedPaths.count != 0) {
            
            let titleBtn : UIButton = UIButton(frame:CGRectMake(0, 0, tableView.frame.size.width, height));
            titleBtn.setTitleColor(UIColor.blackColor(),forState:UIControlState.Normal)
            let blurEffect : UIBlurEffect = UIBlurEffect(style:UIBlurEffectStyle.ExtraLight)
            let bluredEffectView :UIVisualEffectView = UIVisualEffectView(effect:blurEffect)
            bluredEffectView.frame = CGRectMake(0, 0, self.navigationController!.view.frame.size.width, height);
            headerView.addSubview(bluredEffectView);
            titleBtn.backgroundColor = UIColor.clearColor();
            
            
            headerView.addSubview(titleBtn);
            //            if (selectedPaths.count == section) {
            //
            //            UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 18, 14, 8)];
            //            arrowView.image = [UIImage imageNamed:ARROW_BLUE_UP_ICON];
            //            [headerView addSubview:arrowView];
            //            [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //            titleBtn.titleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_SEMI_BOLD_FONT size:17];
            //
            //            } else {
            //            [titleBtn setTitleColor:DEFAULT_UI_CONTROL_COLOR forState:UIControlStateNormal];
            //            titleBtn.titleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_REG_FONT size:13];
            //            }
            titleBtn.tag = section;
            titleBtn.addTarget(self, action:#selector(ViewController.collpaseCell(_:)), forControlEvents:UIControlEvents.TouchUpInside);
            
            self.tableView.backgroundColor = UIColor.whiteColor();
            if (section == 0) {
                
                titleBtn.setTitle("All",forState:UIControlState.Normal);
            } else {
                
                let sectionKey : String = (menuList.objectAtIndex(section-1) as?  NSDictionary)!.valueForKey("infoKey") as! String;
                titleBtn.setTitle(sectionKey as! String,forState:UIControlState.Normal);
            }
            
            
        } else {
            
            let blurEffect : UIBlurEffect = UIBlurEffect(style:UIBlurEffectStyle.ExtraLight)
            let bluredEffectView :UIVisualEffectView = UIVisualEffectView(effect:blurEffect)
            bluredEffectView.frame = CGRectMake(0, 0, self.navigationController!.view.frame.size.width, 20);
            
            
            headerView.addSubview(bluredEffectView);
            
            
            let titleLabel : UILabel = UILabel(frame:CGRectMake(15, 20, self.navigationController!.view.frame.size.width-30, 14));
            headerView.addSubview(titleLabel);
            let infoDict : NSDictionary  = menuOption[section];
            titleLabel.text = ((infoDict.allKeys as? NSArray)!.firstObject as? NSString)!.uppercaseString;
            titleLabel.textColor = UIColor(red:138.0 / 255.0, green:137.0 / 255.0, blue:137.0 / 255.0, alpha:1.0);
            titleLabel.font = UIFont.systemFontOfSize(13);
            titleLabel.backgroundColor = UIColor.clearColor();
        }
        
        
        let separtorView : UIView  = UIView(frame:CGRectMake(0, height-1, tableView.frame.size.width, 1));
        separtorView.backgroundColor = UIColor(red:232.0 / 255.0, green:232.0 / 255.0, blue:233.0 / 255.0, alpha:1.0);
        headerView.addSubview(separtorView);
        
        return headerView;
    }
    
    
    func collpaseCell(button :UIButton) {
        
        var buttonTag : NSInteger = button.tag;
        if buttonTag == (menuList.count - 1) {
            buttonTag = buttonTag - 1;
        }
        
        self.createBackViewForImage();
        
        var vissibleCell : NSArray = tableView.indexPathsForVisibleRows!;
        var rectOfCell : CGRect = tableView.rectForRowAtIndexPath(vissibleCell.firstObject as! NSIndexPath);
        rectOfCell = tableView.convertRect(rectOfCell, toView:tableView.superview);
        
        
        if (rectOfCell.origin.y < 0) {
            rectOfCell.origin.y = 0;
        }
        var fadeframe : CGRect = fadedView.frame;
        fadeframe.origin.y = rectOfCell.origin.y - coverView.frame.origin.y;
        fadeframe.size.height = coverView.frame.size.height - fadeframe.origin.y;
        fadedView.frame = fadeframe;
        
        
        var imageframe : CGRect = fadedView.frame;
        imageframe.origin.y = fadedView.frame.origin.y + coverView.frame.origin.y;
        
        let portrait : UIImage = self.imageWithView(self.tableView, andFrame:imageframe);
        fadedView.image = portrait;
        
        var currentIndex : NSInteger = buttonTag;
        while (currentIndex < (menuList.count - 1)) {
            
            selectedPaths.removeLastObject();
            menuList.removeLastObject();
        }
        if (selectedPaths.count == 0) {
            
            self.navigationController!.setNavigationBarHidden(false, animated:true);
            blurView.removeFromSuperview();
            
        }
        let indexPath  = selectedPaths.lastObject;
        
        self.tableView.reloadData();
        
        vissibleCell = self.tableView.indexPathsForVisibleRows!;
        rectOfCell  = tableView.rectForRowAtIndexPath(vissibleCell.firstObject as! NSIndexPath);
        rectOfCell = tableView.convertRect(rectOfCell, toView:tableView.superview);
        
        if (rectOfCell.origin.y < 0) {
            rectOfCell.origin.y = 0;
        }
        coverView = UIView(frame:CGRectMake(0, rectOfCell.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - rectOfCell.origin.y))
        coverView.backgroundColor = UIColor.whiteColor();
        coverView.clipsToBounds = true;
        if (selectedPaths.count != 0) {
            coverView.addSubview(fadedView);
        }
        let selfPortrait : UIImage = self.imageWithView(self.tableView, andFrame:coverView.frame);
        
        if (indexPath != nil) {
        
            var rectOfCellInTableView : CGRect = self.tableView.rectForRowAtIndexPath((indexPath as? NSIndexPath)!);
            rectOfCellInTableView = self.tableView.convertRect(rectOfCellInTableView, toView:self.tableView.superview);
            if (rectOfCellInTableView.origin.y + 44 > self.tableView.frame.size.height) {
                
                rectOfCellInTableView.origin.y = self.tableView.frame.size.height - 44;
            }
            self.createTopViewForImage(selfPortrait, andFrame:rectOfCellInTableView, andToframe:rectOfCell);
            self.createBottomViewForImage(selfPortrait, andFrame:rectOfCellInTableView, andToframe:rectOfCell);
            
            
            var  leftFrame : CGRect = topCurtain.frame;
            var rightFrame :  CGRect = bottomCurtain.frame;
            
            leftFrame.origin.y = leftFrame.origin.y - leftFrame.size.height;
            rightFrame.origin.y = rightFrame.size.height + rightFrame.origin.y;
            
            topCurtain.frame = leftFrame;
            
            bottomCurtain.frame = rightFrame;
            self.view.addSubview(coverView);
            
            self.curtainRevealViewControllerForState(false);
       }
        
        
    }
    
    
}




