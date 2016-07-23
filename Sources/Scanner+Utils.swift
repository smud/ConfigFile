//
// Scanner+Utils.swift
//
// This source file is part of the SMUD open source project
//
// Copyright (c) 2016 SMUD project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SMUD project authors
//

import Foundation

extension Scanner {
    var parsedText: String {
        return string.substring(to: string.index(string.startIndex, offsetBy: scanLocation))
    }
    
    var line: Int {
        var lineCount = 1
        for character in parsedText.characters {
            if character == "\n" { lineCount += 1 }
        }
        return lineCount
    }
    
    var column: Int {
        let text = parsedText
        if let range = text.range(of: "\n", options: .backwards) {
            return text.distance(from: range.upperBound, to: text.endIndex) + 1
        }
        return parsedText.characters.count + 1
    }
}
