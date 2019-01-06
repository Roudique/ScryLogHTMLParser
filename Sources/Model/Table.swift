//
//  Table.swift
//  ScryLog
//
//  Created by Roudique on 12/17/18.
//  Copyright © 2018 Roudique. All rights reserved.
//

import Foundation

public typealias Row = [String]

open class Table {
    public var title: String
    public let rows: [Row]
    
    public init(title: String, rows: [Row]) {
        self.title = title
        self.rows = rows
    }
}
