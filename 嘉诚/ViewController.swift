//
//  ViewController.swift
//  嘉诚
//
//  Created by JiaCheng on 2019/8/30.
//  Copyright © 2019 JiaCheng. All rights reserved.
//

import UIKit
import UserNotifications
import WebKit

class ViewController: UIViewController {
    @IBOutlet weak var wkWebView: WKWebView!
    
    @objc func remove(_ sender: UIButton) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let ac = UIAlertController(title: "Notification Deleted", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        present(ac, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "👪三人行"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        wkWebView.allowsBackForwardNavigationGestures = false
        wkWebView.navigationDelegate = self
        let url = URL(string: "http://jiachengcc07.club/sanrenxingurl.txt")!
        let request = URLRequest(url: url)
        wkWebView.load(request)
        
//        let barButton1 = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
//        let barButton2 = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(remove(_:)))
//        navigationItem.rightBarButtonItems = [barButton1, barButton2]
        
    }
    
    static var badgeCount = 0;
    var count = 0
    
    @objc func scheduleLocal() {
        registerCategories()
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call \(count)"
        count += 1
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm111"
        ViewController.badgeCount += 1
        content.badge = ViewController.badgeCount as NSNumber
        content.userInfo = ["customData": "fizzbuzz"]
        //如果用默认的tritone（三全音）就是UNNotificationSound.default（）方法，否则自定义的话如下:UNNotificationSound.init()
        content.sound = UNNotificationSound.default
        
        /*
         var dateComponent = DateComponents()
         dateComponent.hour = 10
         dateComponent.minute = 30
         //        由于模拟器测试基于时间比较慢，用了下面这个间隔五秒的
         let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
         */
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        //      因为这是一个通知的请求，如果identifier一样的话，他会覆盖出现，不会增加通知个数。
        //      所以我现在想试试给它改成固定的uuid看一看结果。看它是否是覆盖更新且不会产生新的
        //      这样多点几个注册貌似前面的通知就不会弹出来了诶。。还得改进。
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        let ac = UIAlertController(title: "Notification Created", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            //这句话注册本地通知请求
            center.add(request)
        }))
        present(ac,animated: true)
        
        //        这句话取消将要发生的alert
        //        center.removeAllPendingNotificationRequests()
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm111", actions: [show], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish")
        
        wkWebView.evaluateJavaScript(#"document.getElementsByTagName("body")[0].innerText"#) { [unowned self] (result, error) in
            if let _ = error {
                return
            }
            
            if let result = result as? String, result.contains("jiachengcc07.club") {
                let url = URL(string: result)!
                let request = URLRequest(url: url)
                self.wkWebView.load(request)
            }
        }
    }
}


