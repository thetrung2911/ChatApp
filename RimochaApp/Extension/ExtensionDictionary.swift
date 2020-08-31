//
//  ExtensionDictionary.swift
//  RimochaApp
//
//  Created by iMac dev4 on 8/28/20.
//  Copyright © 2020 vnc. All rights reserved.
//

import Foundation

extension Dictionary {
    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// This percent escapes in compliance with RFC 3986
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let obj = value as? Double {
                let percentEscapedValue = obj
                return "\(percentEscapedKey ?? "")=\(percentEscapedValue)"
            } else if let obj = value as? Int {
                let percentEscapedValue = obj
                return "\(percentEscapedKey ?? "")=\(percentEscapedValue)"
            }
            else {
                let percentEscapedValue = (value as! String).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                return "\(percentEscapedKey ?? "")=\(percentEscapedValue ?? "")"
            }
            
        }
        
        return parameterArray.joined(separator: "&")
    }
}
