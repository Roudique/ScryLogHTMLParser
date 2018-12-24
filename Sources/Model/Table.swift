//
//  Table.swift
//  ScryLog
//
//  Created by Roudique on 12/17/18.
//  Copyright © 2018 Roudique. All rights reserved.
//

import Foundation

typealias Row = [String]

class Table {
    var title: String
    let rows: [Row]
    
    init(title: String, rows: [Row]) {
        self.title = title
        self.rows = rows
    }
}
