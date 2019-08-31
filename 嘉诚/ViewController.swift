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

// document.getElementById("suggesstions").value = ""
// document.getElementById("submit").click()

class ViewController: UIViewController {
    @IBOutlet weak var wkWebView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    
    static var deviceToken = ""
    
    var JSOne = ""
    var JSTwo = ""
    var JSThree = ""
    var JSFour = #"document.getElementById("submit").click()"#
    
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
        
        self.navigationController?.setNavgationBarTitleTextAttributes(color: .myRed, font: UIFont(name: "chenwixun-jian", size: 25))
        self.navigationController?.navigationBar.tintColor = UIColor.myRed
        self.navigationController?.setNavgationBarlargeTitleTextAttributes(color: .myRed, font: UIFont(name: "chenwixun-jian", size: 45))
        
        self.title = "👪三人行"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        wkWebView.allowsBackForwardNavigationGestures = true
        wkWebView.navigationDelegate = self
        let url = URL(string: "http://jiachengcc07.club:1707")!
        let request = URLRequest(url: url)
        wkWebView.load(request)
        
//        progressView = UIProgressView(progressViewStyle: .default)
//        progressView.sizeToFit()
//        let progressButton = UIBarButtonItem(customView: progressView)
//        self.navigationItem.rightBarButtonItem = progressButton
        
        wkWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        wkWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        
        
//        JSOne = #"document.getElementById("deviceToken").value = " "#
//        JSOne += "\(ViewController.deviceToken)"
//        JSOne += #" ""#
        
        JSTwo = #"document.getElementById("time").value = " "#
        let today = Date()
        let zone = NSTimeZone.system
        let interval = zone.secondsFromGMT()
        JSTwo += "\(today.addingTimeInterval(TimeInterval(interval)))"
        JSTwo += #" ""#
        
        JSThree = #"document.getElementById("deviceName").value = " "#
        JSThree += "\(UIDevice.current.name)"
        JSThree += #" ""#
        
//        var i = 0
//        for family: String in UIFont.familyNames {
//            print("\(i)---项目字体---\(family)")
//            for names: String in UIFont.fontNames(forFamilyName: family) {
//                print("== \(names)")
//            }
//            i += 1
//        }
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
        
//        //本来是直接提个txt文件里面写上前缀加网址，但是觉得这样不太好，用一个带链接button来比较好
//        wkWebView.evaluateJavaScript(#"document.getElementsByTagName("body")[0].innerText"#) { [unowned self] (result, error) in
//            if let _ = error {
//                return
//            }
//
//            if let result = result as? String, result.contains("ok it's the url: ") {
//                let results = result.split(separator: "\n")
//                var mutableResult = results[0]
//                for _ in 0 ..< 17 {
//                    mutableResult.removeFirst()
//                }
//                let url = URL(string: String(mutableResult))!
//                let request = URLRequest(url: url)
//                self.wkWebView.load(request)
//            }
//        }
        
//        wkWebView.evaluateJavaScript(#"document.getElementById("jsBtn").onclick()"#) { (result, error) in
//            if let _ = error {
//                return
//            }
//        }
    
        
        wkWebView.evaluateJavaScript(JSTwo) { [unowned self] (result, error) in
            if let result = result {
                print(result)
                
                self.wkWebView.evaluateJavaScript(self.JSThree) { (result, error) in
                    if let result = result {
                        print(result)
                        
                        self.JSOne = #"document.getElementById("deviceToken").value = " "#
                        self.JSOne += "\(ViewController.deviceToken)"
                        self.JSOne += #" ""#
                        self.wkWebView.evaluateJavaScript(self.JSOne) { (result, error) in
                            if let result = result {
                                print(result)
                                
                                self.wkWebView.evaluateJavaScript(self.JSFour) { (result, error) in
                                    if let result = result {
                                        print(result)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // 在发送请求之前，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if (navigationAction.targetFrame == nil) {
            webView.load(navigationAction.request)
        }
        
        decisionHandler(.allow)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(wkWebView.estimatedProgress)
        } else if keyPath == "title" {
            if let title = wkWebView.title {
//                print(title)
                self.title = title
            }
        }
    }
}



extension UIColor {
    static var myGreen: UIColor {
        return UIColor(displayP3Red: 0.196, green: 0.604, blue: 0.357, alpha: 1)
    }
    
    static var myBlue: UIColor {
        return UIColor(displayP3Red: 0.184, green: 0.536, blue: 0.892, alpha: 1)
    }
    
    static var myRed: UIColor {
        return UIColor(displayP3Red: 0.898, green: 0.399, blue: 0.429, alpha: 1)
    }
}

extension UINavigationController {
    
    public func setNavgationBarlargeTitleTextAttributes(color: UIColor?, font: UIFont?) {
        
        var textAttributes: [NSAttributedString.Key: AnyObject] = [:]
        
        if let c = color {
            textAttributes[NSAttributedString.Key.foregroundColor] = c
        }
        if let f = font {
            textAttributes[.font] = f
        }
        
        self.navigationBar.largeTitleTextAttributes = textAttributes
    }
    
    public func setNavgationBarTitleTextAttributes(color: UIColor?, font: UIFont?) {
        
        var textAttributes: [NSAttributedString.Key: AnyObject] = [:]
        
        if let c = color {
            textAttributes[NSAttributedString.Key.foregroundColor] = c
        }
        if let f = font {
            textAttributes[.font] = f
        }
        
        self.navigationBar.titleTextAttributes = textAttributes
    }
}

