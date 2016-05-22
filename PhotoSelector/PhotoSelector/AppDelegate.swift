//
//  AppDelegate.swift
//  PhotoSelector
//
//  Created by Imanol on 5/22/16.
//  Copyright © 2016 imanol. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = PhotoSelectorViewController()
        window?.makeKeyAndVisible()
        return true
    }

}

