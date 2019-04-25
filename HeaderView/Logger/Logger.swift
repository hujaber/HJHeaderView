//
//  Logger.swift
//  HeaderView
//
//  Created by Hussein Jaber on 25/4/19.
//  Copyright © 2019 Hussein Jaber. All rights reserved.
//

import Foundation

enum LogEvent: String {
    case error = "[‼️]" // error
    case info = "[ℹ️]" // info
    case debug = "[💬]" // debug
    case warning = "[⚠️]" // warning
    case severe = "[🔥]" // severe
}

// wrapper above Swift.print() to allow printing only when DEBUG flag is set :)
func print(_ object: Any) {
    #if DEBUG
    Swift.print(object)
    #endif
}

final class Logger {
    private init() {}
    private static let dateFormat: String = "dd/MM/yyyy hh:mm:ss"
    fileprivate static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    class func log(type: LogEvent, _ object: Any,
                 fileName: String = #file,
                 line: Int = #line,
                 column: Int = #column,
                 funcName: String = #function) {
        print("\(Date().stringValue) \(type.rawValue)[\(sourceFileName(filePath: fileName))]:\(line) \(column) \(funcName) -> \(object)")
    }
}

private extension Date {
    var stringValue: String {
        return Logger.dateFormatter.string(from: self)
    }
}
