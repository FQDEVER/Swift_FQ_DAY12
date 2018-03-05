//
//  AppDelegate.swift
//  LottieLaunchAnimation1
//
//  Created by mac on 2018/1/24.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit
import Lottie

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var animationView : LOTAnimationView = LOTAnimationView(name: "LottieLogo1")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let tempVc = UIViewController()
        self.window?.rootViewController = tempVc
        //先来这里做一个动画
        self.window?.makeKeyAndVisible()
        self.animationView.frame = (self.window?.bounds)!
        self.window?.addSubview(self.animationView)
        self.window?.bringSubview(toFront: self.animationView)
        self.animationView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        self.animationView.contentMode = .scaleAspectFill
        
        self.animationView.loopAnimation = false
        self.animationView.play(toProgress: 0.7) { (bool) in
            let Vc = ViewController()
            Vc.view.backgroundColor = UIColor.white
            self.window?.rootViewController = Vc
            self.window?.makeKeyAndVisible()
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

