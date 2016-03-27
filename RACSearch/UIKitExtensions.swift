//
//  UIKitExtensions.swift
//  RACSearch
//
//  Created by Raheel Ahmad on 3/26/16.
//  Copyright © 2016 Raheel Ahmad. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

extension UISearchBar : UISearchBarDelegate {
    public var rac_searchBarTextDidChange : Signal<(UISearchBar,String?),NoError> {
        var searchBarTextDidChange: UInt8 = 0
        
        var value = objc_getAssociatedObject(self, &searchBarTextDidChange) as? Signal<(UISearchBar,String?),NoError>
        if value == nil {
            self.delegate = self
            
            let signalProducer: SignalProducer<(UISearchBar, String?), NoError> = self.rac_signalForSelector(Selector("searchBar:textDidChange:"), fromProtocol: UISearchBarDelegate.self)
                .toSignalProducer()
                .flatMapError { (sp) -> SignalProducer<AnyObject?, NoError> in
                    let sp = SignalProducer<AnyObject?, NoError>(value: nil)
                    return sp
                }
                .map {
                    let tuple = $0 as! RACTuple
                    return (tuple.first as! UISearchBar, tuple.second as! String?)
                }
            signalProducer.startWithSignal({ (inner, _) -> () in
                value = inner
            })
            
            objc_setAssociatedObject(self,  &searchBarTextDidChange, value, .OBJC_ASSOCIATION_RETAIN)
        }
        return value!
    }
}
