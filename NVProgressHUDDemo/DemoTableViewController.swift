//
//  DemoTableViewController.swift
//  NVProgressHUDDemo
//
//  Created by liang on 15/12/5.
//  Copyright © 2015年 liang. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class DemoTableViewController: UITableViewController {

    var hud: NVProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
        case 0:
            showSimple()
            break
        case 1:
            showWithLabel()
            break
        case 2:
            showWithDetailsLabel()
            break
        case 3:
            showUsingBlock()
            break
        case 4:
            showOnWindow()
            break
        case 5:
            showWithGradient()
            break
        case 6:
            showWithColor()
            break
        case 7:
            showDifferentIndicator()
            break
        case 8:
            showUsingExtension()
            break
        default:
            break
        }
    }
    
    func showSimple() {
        hud = NVProgressHUD(frame: self.view.frame)
        self.view.addSubview(hud)
        
        // Regiser for HUD callbacks so we can remove it at the right time
        hud.delegate = self
        
        hud.show(true)
        hud.hide(true, afterDelay: 1.5)
    }
    
    func showWithLabel() {
        hud = NVProgressHUD(frame: self.navigationController!.view.frame)
        self.navigationController!.view.addSubview(hud)
        
        hud.delegate = self
        hud.labelText = "Loading"
        
        hud.show(true)
        hud.hide(true, afterDelay: 2.0)
    }
   
    func showWithDetailsLabel() {
        hud = NVProgressHUD(frame: self.navigationController!.view.frame)
        self.navigationController!.view.addSubview(hud)
        
        hud.delegate = self
        hud.labelText = "Loading"
        hud.detailsLabelText = "downloading data"
        hud.square = true
        
        hud.show(true)
        hud.hide(true, afterDelay: 2.0)
    }
    
    func showUsingBlock() {
        hud = NVProgressHUD(frame: self.navigationController!.view.frame)
        self.navigationController!.view.addSubview(hud)
        
        hud.show(true, executingBlock: { () -> Void in
            print("executing.....")
            NSThread.sleepForTimeInterval(2.0)
            }, completionHandler: { () -> Void in
            print("complete.....")
            self.hud.removeFromSuperview()
        })
    }
    
    func showOnWindow() {
        hud = NVProgressHUD(frame: self.view.window!.frame)
        self.view.window?.addSubview(hud)
        
        hud.delegate = self
        
        hud.show(true)
        hud.hide(true, afterDelay: 2.0)
    }
    
    func showWithGradient() {
        hud = NVProgressHUD(frame: self.navigationController!.view.frame)
        self.navigationController!.view.addSubview(hud)
        
        hud.delegate = self
        hud.dimBackground = true
        
        hud.show(true)
        hud.hide(true, afterDelay: 2.0)
    }
    
    func showWithColor() {
        hud = NVProgressHUD(frame: self.navigationController!.view.frame)
        self.navigationController!.view.addSubview(hud)
        
        hud.delegate = self
        hud.color = UIColor(red: 0.23, green: 0.50, blue: 0.82, alpha: 0.90)
        
        hud.show(true)
        hud.hide(true, afterDelay: 2.0)
    }
    
    func showDifferentIndicator() {
        hud = NVProgressHUD(frame: self.navigationController!.view.frame, type: NVActivityIndicatorType.BallPulse)
        self.navigationController!.view.addSubview(hud)
        
        hud.delegate = self
        
        hud.show(true)
        hud.hide(true, afterDelay: 2.0)
    }
    
    func showUsingExtension() {
        self.navigationController?.view.showHUD(true)
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
            self.navigationController?.view.hideHUD(true)
        }
    }
}

extension DemoTableViewController: NVProgressHUDDelegate {
    
    func hudDidHidden(hud: NVProgressHUD) {
//        print("hudDidHidden......")
        self.hud.removeFromSuperview()
    }
}
