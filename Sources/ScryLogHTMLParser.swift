//
//  ScryLogHTMLParser.swift
//  ScryLog
//
//  Created by Roudique on 12/1/18.
//  Copyright © 2018 Roudique. All rights reserved.
//

import Foundation
import Kanna


class ScryLogHTMLParser {
    public static func parse(data: Data) -> [Table] {
        var tables = [Table]()
        guard let html = try? HTML(html: data, encoding: .utf8) else { return tables }
        
        let title = html.xpath("//meta[@property='og:title']").first?["content"]
        if let title = title {
            print("\nStarted parsing \(title)")
        }
        
        if let tablesNodeSet = html.xpathsSet(symbol: "table") {
            tablesNodeSet.forEach {
                let tableTitle = findPrevHeaderContent(for: $0)
                let rows = getRows(with: $0)
                
                tables.append(Table(title: tableTitle ?? "", rows: rows)) }
        }
        
        return tables
    }
    
    private static func findPrevHeaderContent(for element: Kanna.XMLElement) -> String? {
        guard let prevSibling = element.previousSibling else { return nil }
        guard let tagName = prevSibling.tagName else { return nil }
        
        // If prev sibling is table it means there was no h2 in between 2 tables, thus need to stop
        // digging.
        if tagName == "table" { return nil }
        if ["h1", "h2", "h3"].contains(tagName), let content = prevSibling.content { return content }
        
        return findPrevHeaderContent(for: prevSibling)
    }
    
    private static func getRows(with element: Kanna.XMLElement) -> [Row] {
        var rows = [Row]()
        
        guard let headObject = element.xpathsSingle(symbol: "thead") else { return rows }
        let head = getTableHead(element: headObject)
        
        guard let bodyObject = element.xpathsSingle(symbol: "tbody") else { return rows }
        guard let body = getTableBody(element: bodyObject, width: head.count) else { return rows }
        
        rows.append(head)
        rows.append(contentsOf: body)
        
        return rows
    }
    
    private static func getTableHead(element: Kanna.XMLElement) -> Row {
        var headCells = [String]()
        
        guard let cells = element.xpathsSet(symbol: "th") else { return headCells }
        cells.compactMap { $0.content }.forEach { headCells.append($0) }
        
        return headCells
    }
    
    private static func getTableBody(element: Kanna.XMLElement, width: Int) -> [Row]? {
        var rows = [Row]()
        guard let rowsXML = element.xpathsSet(symbol: "tr") else { return nil }
        for rowElement in rowsXML {
            guard let cellsXML = rowElement.xpathsSet(symbol: "td") else { return nil }
            let row = cellsXML.compactMap { $0.content?.trimmingCharacters(in: .whitespacesAndNewlines) }
            
            guard row.count == width else { return nil }
            rows.append(row)
        }
        
        return rows
    }
}


extension Kanna.Searchable {
    func xpathsSet(symbol: String) -> [Kanna.XMLElement]? {
        let xpathObject = self.css(symbol)
        
        switch xpathObject {
        case .NodeSet(nodeset: let set):
            let iterator = set.makeIterator()
            var array = [Kanna.XMLElement]()
            
            while let element = iterator.next() {
                array.append(element)
            }
            
            return array
        default:
            return nil
        }
    }
    
    func xpathsSingle(symbol: String) -> Kanna.XMLElement? {
        guard let xpaths = self.xpathsSet(symbol: symbol) else { return nil }
        guard xpaths.count == 1 else { return nil }
        return xpaths.first!
    }
}

