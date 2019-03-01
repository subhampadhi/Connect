//
//  Utils.swift
//  Connect
//
//  Created by Subham Padhi on 01/03/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import Foundation
import UIKit

open class Utils {
    
    static func calculateTextHeightForTableView(approxWidth: CGFloat, string: String, fontName: String, fontSize: CGFloat) -> CGFloat {
        let size = CGSize(width: approxWidth, height: 400)
        let attributes = [NSAttributedString.Key.font: UIFont.init(name: fontName, size: fontSize)!]
        let estimatedFrame = NSString(string: string).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return estimatedFrame.height
    }
    
    static func calculateTextHeightForTableView(approxWidth: CGFloat, approxWidth2: CGFloat, string: String, string2: String, fontName: String, fontName2: String, fontSize: CGFloat, fontSize2: CGFloat) -> CGFloat {
        let size = CGSize(width: approxWidth, height: 400)
        let size2 = CGSize(width: approxWidth2, height: 400)
        let attributes = [NSAttributedString.Key.font: UIFont.init(name: fontName, size: fontSize)!]
        let attributes2 = [NSAttributedString.Key.font: UIFont.init(name: fontName2, size: fontSize2)!]
        let estimatedFrame = NSString(string: string).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        let estimatedFrame2 = NSString(string: string2).boundingRect(with: size2, options: .usesLineFragmentOrigin, attributes: attributes2, context: nil)
        return estimatedFrame.height + estimatedFrame2.height
    }
    
    static func calculateTextHeightForTableView(approxWidth: CGFloat, approxWidth2: CGFloat, approxWidth3: CGFloat, string: String, string2: String, string3: String, fontName: String, fontName2: String, fontName3: String, fontSize: CGFloat, fontSize2: CGFloat, fontSize3: CGFloat) -> CGFloat {
        let size = CGSize(width: approxWidth, height: 400)
        let size2 = CGSize(width: approxWidth2, height: 400)
        let size3 = CGSize(width: approxWidth3, height: 400)
        let attributes = [NSAttributedString.Key.font: UIFont.init(name: fontName, size: fontSize)!]
        let attributes2 = [NSAttributedString.Key.font: UIFont.init(name: fontName2, size: fontSize2)!]
        let attributes3 = [NSAttributedString.Key.font: UIFont.init(name: fontName3, size: fontSize3)!]
        let estimatedFrame = NSString(string: string).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        let estimatedFrame2 = NSString(string: string2).boundingRect(with: size2, options: .usesLineFragmentOrigin, attributes: attributes2, context: nil)
        let estimatedFrame3 = NSString(string: string3).boundingRect(with: size3, options: .usesLineFragmentOrigin, attributes: attributes3, context: nil)
        return estimatedFrame.height + estimatedFrame2.height + estimatedFrame3.height
    }
    
    static func showAlert(title: String, message: String, presenter: UIViewController) {
        // create the alert
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        presenter.present(alert, animated: true, completion: nil)
    }
    
    static func showAlertWithCustomFunction(title: String, message: String, presenter: UIViewController, handler: ((UIAlertAction) -> Swift.Void)?) {
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: handler))
        
        // show the alert
        presenter.present(alert, animated: true, completion: nil)
    }
    
    static func showAlertWithAction(title: String, message: String, presenter: UIViewController) {
        // create the alert
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
            action in
            if (action.style == .default) {
                if let navController = presenter.navigationController {
                    navController.popViewController(animated: true)
                }
            }
        }))
        
        // show the alert
        presenter.present(alert, animated: true, completion: nil)
    }
}
