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
        
        var searchBarSignal = objc_getAssociatedObject(self, &searchBarTextDidChange) as? Signal<(UISearchBar,String?),NoError>
        if searchBarSignal == nil {
            self.delegate = self
            
            let signalProducer: SignalProducer<(UISearchBar, String?), NoError> = rac_signalForSelector(Selector("searchBar:textDidChange:"), fromProtocol: UISearchBarDelegate.self)
                .toSignalProducer()
                .flatMapError { _ -> SignalProducer<AnyObject?, NoError> in
                    return SignalProducer<AnyObject?, NoError>(value: nil)
                }
                .map {
                    let tuple = $0 as! RACTuple
                    return (tuple.first as! UISearchBar, tuple.second as! String?)
                }
            
            signalProducer.startWithSignal({ (inner, _) -> () in
                searchBarSignal = inner
            })
            
            objc_setAssociatedObject(self,  &searchBarTextDidChange, searchBarSignal, .OBJC_ASSOCIATION_RETAIN)
        }
        
        return searchBarSignal!
    }
}
