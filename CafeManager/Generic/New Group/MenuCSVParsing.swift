//
//  MenuCSVParsing.swift
//  CafeManager
//
//  Created by Denis Kurashko on 18.12.2017.
//  Copyright © 2017 Denis Kurashko. All rights reserved.
//

import Foundation

class MenuCSVParsing {
    
    /// Function parses any CSV file and returns array of string arrays
    class func parseCSVFile (contentsOfURL: URL, delimiter: String, encoding: String.Encoding) throws -> [[String]] {
        do {
            let content = try String(contentsOfFile: contentsOfURL.path, encoding: encoding)
            var lines:[String] = (content.components(separatedBy: NSCharacterSet.newlines))
            var parsedStrings: [[String]] = []
            // Remove header and separator tag if exists
            if lines[0].contains("sep=") {
                lines.removeFirst()
            }
            if lines[0].contains("Item name") {
                lines.removeFirst()
            }
            
            for line in lines {
                var values:[String] = []
                if line != "" {
                    // For a line with double quotes
                    // we use NSScanner to perform the parsing
                    if line.range(of: "\"") != nil {
                        var textToScan:String = line
                        var value:NSString?
                        var textScanner:Scanner = Scanner(string: textToScan)
                        while textScanner.string != "" {
                            
                            if (textScanner.string as NSString).substring(to: 1) == "\"" {
                                textScanner.scanLocation += 1
                                textScanner.scanUpTo("\"", into: &value)
                                textScanner.scanLocation += 1
                            } else {
                                textScanner.scanUpTo(delimiter, into: &value)
                            }
                            
                            // Store the value into the values array
                            values.append(value! as String)
                            
                            // Retrieve the unscanned remainder of the string
                            if textScanner.scanLocation < textScanner.string.count {
                                textToScan = (textScanner.string as NSString).substring(from: textScanner.scanLocation + 1)
                            } else {
                                textToScan = ""
                            }
                            textScanner = Scanner(string: textToScan)
                        }
                        
                        // For a line without double quotes, we can simply separate the string
                        // by using the delimiter (e.g. comma)
                    } else  {
                        values = line.components(separatedBy: delimiter)
                    }
                    parsedStrings.append(values)
                }
            }
            return parsedStrings
        } catch {
            let message = "Unable to parse CSV file. Error: \(error)"
            throw iCafeManagerError.ParsingError(message)
        }
    }
    
    class func parseCommonMenuCSVFile (contentsOfURL: URL, encoding: String.Encoding) throws -> [(itemCategory: String, itemName: String, itemDescription: String, itemLanguage: String)]? {
        var items:[(itemCategory: String, itemName: String, itemDescription: String, itemLanguage: String)]? = []
        
        do {
            let parsedStrings = try MenuCSVParsing.parseCSVFile(contentsOfURL: contentsOfURL, delimiter: ";", encoding: encoding)
            for array in parsedStrings {
                guard array.count == 4 else { continue }
                let item = (itemCategory: array[0], itemName: array[1], itemDescription: array[2], itemLanguage: array[3])
                items?.append(item)
            }
            return items

        } catch {
            let message = "Unable to parse file. Error: \(error)"
            throw iCafeManagerError.ParsingError(message)
        }
    }
    
    class func parseExportedMenuCSVFile (contentsOfURL: URL, encoding: String.Encoding) throws -> [MenuItem]? {
    var items: [MenuItem] = []
        
        do {
            let parsedStrings = try MenuCSVParsing.parseCSVFile(contentsOfURL: contentsOfURL, delimiter: ";", encoding: encoding)
            for array in parsedStrings {
                guard array.count == 4 else { continue }
                let price = array[3].getFloatNumber() ?? 0
//                let menuItem = MenuStruct(itemName: array[0], itemDescription: array[1], itemPrice: price, itemCategory: array[2])
//                items.append(menuItem)
            }
            return items
            
        } catch {
            let message = "Unable to process parsed data from CSV file \(error)"
            print (message)
            throw iCafeManagerError.ParsingError(message)
        }
    }
}
