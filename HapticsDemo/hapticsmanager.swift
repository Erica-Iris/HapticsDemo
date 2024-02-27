//
//  hapticsmanager.swift
//  hapticsexample
//
//  Created by Iris on 2023-08-09.
//

import UIKit
final class hapticsmanager{
    static let shared=hapticsmanager()
    private init(){}
    public func selectionVibrate(){
        DispatchQueue.main.async {
            let selectionFeedbackGenerator=UISelectionFeedbackGenerator()
            selectionFeedbackGenerator.prepare()
            selectionFeedbackGenerator.selectionChanged()
        }
    }
    public func vibrate(for type:UINotificationFeedbackGenerator.FeedbackType){
        DispatchQueue.main.async {
            let notificationGenerator=UINotificationFeedbackGenerator()
            notificationGenerator.prepare()
            notificationGenerator.notificationOccurred(type)
        }
        
    }
    
}
