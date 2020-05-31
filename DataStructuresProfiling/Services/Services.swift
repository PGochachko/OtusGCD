//
//  Services.swift
//  OTUS
//
//  Created by Дмитрий Матвеенко on 16/06/2019.
//  Copyright © 2019 GkFoxes. All rights reserved.
//

import Foundation

class Services {
    
    static var feedProvider: FeedDataProvider = {
        return FeedDataProvider()
    }()
    
    static var numberFormatter: NumberFormatter = {
        var formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        return formatter
    }()
    
    static var timeNumberFormatter: NumberFormatter = {
        var formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        let digits = 6
        formatter.minimumFractionDigits = digits
        formatter.maximumFractionDigits = digits
        return formatter
    }()
}
