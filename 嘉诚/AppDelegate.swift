//
//  AppDelegate.swift
//  嘉诚
//
//  Created by JiaCheng on 2019/8/30.
//  Copyright © 2019 JiaCheng. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    /*  注意上面那个代理管理了两个方法： userNotificationCenter(_:willPresent:withCompletionHandler:) 和 userNotificationCenter(_:didReceive:withCompletionHandler:)
     Use the methods of the UNUserNotificationCenterDelegate protocol to handle user-selected actions from notifications, and to process notifications that arrive when your app is running in the foreground.
     我之所以这两个方法不会被执行是因为虽然上面写了，但是UNUserNotificationCenter.current().delegate = self没有写啊傻瓜花了多少时间哦😂
     */
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        UNUserNotificationCenter.current().delegate = self
        application.applicationIconBadgeNumber = 0
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let device = NSData(data: deviceToken)
        print(device.description)
        
        let pushID = device.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        
//        print(pushID)
        
        ViewController.deviceToken = pushID
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    //处理前台运行时的信息、还有一个也是处理前台的application(_didReceiveRemoteNotification:）{}跟下面前台处理信息的类似，但是没有闭包。还有一点，这个是反对用的。还有一点，下面那个didreceive是前后台都能用的（实现了代理的两个方法后就只有静默实现了好像注意一下），但是后台的话只是会给你悬挂什么的好像目前不太了解。
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //        let userInfo = notification.request.content.userInfo
        //        let center = UNUserNotificationCenter.current()
        //
        //        let content = UNMutableNotificationContent()
        //        content.title = "Late wake up call"
        //        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        //        content.categoryIdentifier = "alarm111"
        //        content.userInfo = userInfo
        //        //如果用默认的tritone（三全音）就是UNNotificationSound.default（）方法，否则自定义的话如下
        //        content.sound = UNNotificationSound.init(named: "小叮当.mp3")
        
        completionHandler([.alert, .badge, .sound])
    }
    
    //这个应该是那些动作，即action或者说是比如打开或者5分钟后提醒之类的按钮，通过let userInfo = response.notification.request.content.userInfo也能实现到跟下面didReceiveRemoteNotification 的userInfo一样的目的。这个肯定是把它放到前台来运行了吧，不对好像要在创建action是设置模式的。
    func userNotificationCenter (_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        ViewController.badgeCount = 0
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            print("I'm UNNotificationDefaultActionIdentifier")
        default:
            print("I'm other action")
            break
        }
        
        // you must call the completion handler when you're done
        completionHandler()
    }
    
    /*这个应该处理静默推送的吧，有30秒处理什么的，但是前台也是可以的？？
     静默推送要有下面第三句，然后我①关闭后台刷新②锁屏的时候③低电量的时候 都是在后台直接可以执行执行下面那个至多30秒
     ④直接双击home向上滑肯定没得吧
     要有类似于这么一句话的completionHandler(.noData)
     [AnyHashable("aps"): {
     alert = "Your message ";
     "content-available" = 1;
     sound = default;
     }]
     然后没有"content-available" = 1;静默推送是后台是没有执行的，点通知进入后或者在前台时会执行。
     */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo)
        completionHandler(.noData)
    }
    
    
    //    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    //
    //    }
    func applicationWillResignActive(_ application: UIApplication) {
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        ViewController.badgeCount = 0
        application.applicationIconBadgeNumber = 0
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    func applicationWillTerminate(_ application: UIApplication) {
    }
}

