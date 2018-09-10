//
//  AppDelegate.swift
//  PLPinViewController_Example
//
//  Created by Ash Thwaites on 25/08/2018.
//  Copyright © 2018 Ash Thwaites. All rights reserved.
//

import UIKit
import Foundation
import PLPinViewController

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var pinExpired: Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupAppearance()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // After 10 seconds if we are still in the bg then ensure pin has expired
        var backgroundTask = application.beginBackgroundTask(expirationHandler: {
            endBackgroundTask()
        })
        pinExpired = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
            if (UIApplication.shared.applicationState == .background) {
                print("applicationBGLogout")
            }
            self.pinExpired = true
            endBackgroundTask()
        })
        
        func endBackgroundTask() {
            application.endBackgroundTask(backgroundTask)
            backgroundTask = UIBackgroundTaskInvalid
        }

    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        if (pinExpired){
            guard let rvc = self.window?.rootViewController as? PLExampleViewController else {
                print("no root view controller!")
                return
            }
            rvc.presentPinController()
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    private func setupAppearance() {
        let pinAppearance = PLPinAppearance.default()
        pinAppearance?.backgroundColor = UIColor.tealish
        pinAppearance?.numberButtonColor = UIColor.coolGrey
        pinAppearance?.numberButtonTitleColor = UIColor.white
        pinAppearance?.numberButtonStrokeColor = UIColor.white
        pinAppearance?.deleteButtonColor = UIColor.white
        pinAppearance?.pinFillColor = UIColor.coolGrey
        pinAppearance?.pinHighlightedColor = UIColor.white
        pinAppearance?.titleColor = UIColor.white
        pinAppearance?.titleFont = UIFont.textStyle
        pinAppearance?.messageColor = UIColor.white
        pinAppearance?.messageFont = UIFont.textStyle6
        pinAppearance?.statusBarStyle = UIStatusBarStyle.lightContent
        pinAppearance?.errorColor = UIColor.red
        pinAppearance?.errorFont = UIFont.textStyle6
        pinAppearance?.enterPinErrorMessageVisibleDuration = 3.0
        pinAppearance?.cancelButtonTintColor = UIColor.white
        pinAppearance?.logoutButtonTextColor = UIColor.white
        pinAppearance?.logoutButtonFont = UIFont.textStyle2
        pinAppearance?.logoutLabelTextColor = UIColor.coolGrey
        pinAppearance?.logoutButtonFont = UIFont.textStyle7
        PLPinWindow.defaultInstance().pinAppearance = pinAppearance
    }
}
