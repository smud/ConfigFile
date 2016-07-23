//
// ConfigFile.swift
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

class ConfigFile {
    // DEBUG
    private static let logFields = false
    
    typealias Fields = [String: String]
    typealias Sections = [String: Fields]
    
    var filename: String?
    private var scanner: Scanner?
    private var sections = Sections()

    let whitespacesAndNewlines = CharacterSet.whitespacesAndNewlines
    let decimalDigits = CharacterSet.decimalDigits
    
    func load(fromFile filename: String) throws {
        self.filename = filename

        let contents = try String(contentsOfFile: filename, encoding: .utf8)
        try load(fromString: contents)
    }

    func load(fromString string: String) throws {
        let scanner = Scanner(string: string)
        self.scanner = scanner
        
        while !scanner.isAtEnd {
            try scanNextSection()
        }
    }
    
    func save(toFile filename: String) throws {
        var out = ""
        
        let sortedSections = sections.sorted {
            $0.0.compare($1.0, options: .numeric) == .orderedAscending
        }
        for section in sortedSections {
            out += "[\(section.key)]\n"
            let fields = section.value
        
            let sortedFields = fields.sorted {
                $0.0.compare($1.0, options: .numeric) == .orderedAscending
            }
            for field in sortedFields {
                let name = field.key
                let value = field.value
                var isHeredoc = false
                
                if !value.isEmpty {
                    if let firstScalar = value.unicodeScalars.first, whitespacesAndNewlines.contains(firstScalar) {
                        isHeredoc = true
                    } else if let lastScalar = value.unicodeScalars.last, whitespacesAndNewlines.contains(lastScalar) {
                        isHeredoc = true
                    } else if value.contains("\n") {
                        isHeredoc = true
                    }
                }
                
                switch isHeredoc {
                case true:
                    out += "\(name):\n"
                    value.enumerateLines { line, stop in
                        if !line.isEmpty && line.hasPrefix("$") {
                            out += "$";
                        }
                        out += "\(line)\n"
                    }
                    if value.hasSuffix("\n") {
                        out += "\n"
                    }
                    out += "$\n"
                case false:
                    out += "\(name) \(value)\n"
                }
            }
        }

        try out.write(toFile: filename, atomically: true, encoding: .utf8)
    }
    
    var isEmpty: Bool { return sections.isEmpty }

    func string(section: String, field: String) -> String? {
        return sections[section]?[field]
    }
    
    func int(section: String, field: String) -> Int? {
        guard let value = string(section: section, field: field) else { return nil }
        return Int(value)
    }

    func int8(section: String, field: String) -> Int8? {
        guard let value = string(section: section, field: field) else { return nil }
        return Int8(value)
    }

    func int16(section: String, field: String) -> Int16? {
        guard let value = string(section: section, field: field) else { return nil }
        return Int16(value)
    }

    func int32(section: String, field: String) -> Int32? {
        guard let value = string(section: section, field: field) else { return nil }
        return Int32(value)
    }

    func int64(section: String, field: String) -> Int64? {
        guard let value = string(section: section, field: field) else { return nil }
        return Int64(value)
    }

    func uint(section: String, field: String) -> UInt? {
        guard let value = string(section: section, field: field) else { return nil }
        return UInt(value)
    }
    
    func uint8(section: String, field: String) -> UInt8? {
        guard let value = string(section: section, field: field) else { return nil }
        return UInt8(value)
    }

    func uint16(section: String, field: String) -> UInt16? {
        guard let value = string(section: section, field: field) else { return nil }
        return UInt16(value)
    }

    func uint32(section: String, field: String) -> UInt32? {
        guard let value = string(section: section, field: field) else { return nil }
        return UInt32(value)
    }

    func uint64(section: String, field: String) -> UInt64? {
        guard let value = string(section: section, field: field) else { return nil }
        return UInt64(value)
    }

    func bool(section: String, field: String) -> Bool? {
        guard let value = int(section: section, field: field) else { return nil }
        return value != 0
    }

    func double(section: String, field: String) -> Double? {
        guard let value = string(section: section, field: field) else { return nil }
        // Replace all commas with dots in case they ended up in config file somehow
        return Double(value.replacingOccurrences(of: ",", with: "."))
    }

    func float(section: String, field: String) -> Float? {
        guard let value = string(section: section, field: field) else { return nil }
        // Replace all commas with dots in case they ended up in config file somehow
        return Float(value.replacingOccurrences(of: ",", with: "."))
    }
    
    func character(section: String, field: String) -> Character? {
        guard let value = string(section: section, field: field) else { return nil }
        return value.characters.first
    }

    private func bitIndexes(section: String, field: String) -> [Int]? {
        guard let value = string(section: section, field: field) else { return nil }
        
        var word: NSString?
        var result = [Int]()
        
        let scanner = Scanner(string: value)
        guard scanner.scanString("(", into: nil) else { return nil }
        while !scanner.scanString(")", into: nil) {
            guard scanner.scanCharacters(from: decimalDigits, into: &word), let word = word else { return nil }
            guard let bitIndex = Int(word as String) else { return nil }
            result.append(bitIndex)

            scanner.scanString(",", into: nil)
        }
        return result
    }
    
    func optionSet<T: OptionSet where T.RawValue: UnsignedInteger>(section: String, field: String) -> T? {
        guard let indexes = bitIndexes(section: section, field: field) else { return nil }
        return T(bitIndexes: indexes)
    }
    
    func delete(section: String) {
        sections.removeValue(forKey: section)
    }
    
    func set(section: String, field: String, value: String) {
        var fields = sections[section] ?? Fields()
        fields[field] = value
        sections[section] = fields
    }

    func set(section: String, field: String, value: Bool) {
        set(section: section, field: field, value: value ? 1 : 0)
    }

    func set(section: String, field: String, value: Character) {
        set(section: section, field: field, value: String(value))
    }

    func set<T: FloatingPoint>(section: String, field: String, value: T) {
        let value = String(value).replacingOccurrences(of: ",", with: ".")
        set(section: section, field: field, value: value)
    }

    func set<T>(section: String, field: String, value: T) {
        set(section: section, field: field, value: String(value))
    }
    
    // Maybe over complicated a bit: http://stackoverflow.com/questions/32102936/how-do-you-enumerate-optionsettype-in-swift-2
    func set<T: OptionSet where T.RawValue: UnsignedInteger, T.Element == T>(section: String, field: String, value: T) {
        var out = "("
        var first = true
        
        var rawValue = T.RawValue(1)
        var index = 0
        while rawValue != 0 {
            let candidate = T(rawValue: rawValue)
            if value.contains(candidate) {
                switch first {
                case true: first = false
                case false: out += ", "
                }
                out += String(index)
            }
            rawValue = rawValue &* 2
            index += 1
        }
        out += ")"

        set(section: section, field: field, value: out)
    }
    
    private func scanNextSection() throws {
        guard let scanner = scanner else { return }
        
        guard scanner.scanString("[", into: nil) else {
            try throwError(.expectedSectionStart)
        }

        var sectionName: NSString?
        guard scanner.scanUpTo("]", into: &sectionName) else {
            try throwError(.expectedSectionName)
        }

        guard scanner.scanString("]", into: nil) else {
            try throwError(.expectedSectionEnd)
        }
        
        if ConfigFile.logFields {
            print("[\(sectionName)]")
        }

        var fields = Fields()
        
        guard let section = sectionName as? String else {
            try throwError(.invalidSectionName)
        }
        
        while true {
            guard !scanner.isAtEnd else { break } // No more data
            
            let previousLocation = scanner.scanLocation
            guard !scanner.scanString("[", into: nil) else {
                scanner.scanLocation = previousLocation
                break // Empty section (which is allowed)
            }
         
            var fieldName: NSString?
            guard scanner.scanUpToCharacters(from: scanner.charactersToBeSkipped ?? CharacterSet.whitespacesAndNewlines, into: &fieldName) else {
                try throwError(.expectedFieldName)
            }
            
            guard var field = fieldName as? String else {
                try throwError(.invalidFieldName)
            }
            
            guard !field.isEmpty else {
                try throwError(.emptyFieldName)
            }
            
            var value: String
            if field.characters.last != ":" {
                // Normal field
                value = scanLine()?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
                
            } else {
                // Multiline field
                field = field.substring(to: field.index(before: field.endIndex))

                value = try scanMultilineField()
            }
            
            if ConfigFile.logFields {
                print("  \(field)=\(value)")
            }
            
            fields[field] = value
        }
        
        
        sections[section] = fields
    }
    
    private func scanLine() -> String? {
        guard let scanner = scanner else { return "" }

        let previousCharactersToBeSkipped = scanner.charactersToBeSkipped
        scanner.charactersToBeSkipped = nil
        defer { scanner.charactersToBeSkipped = previousCharactersToBeSkipped }
        
        // If at "\n" already, return empty string
        guard !scanner.scanString("\n", into: nil) else {
            return ""
        }
        
        var nsline: NSString?
        guard scanner.scanUpTo("\n", into: &nsline) else {
            return nil
        }
        scanner.scanString("\n", into: nil)
        guard var line = nsline as? String else {
            return nil
        }
        if line.hasSuffix("\r") {
            line = line.substring(to: line.index(before: line.endIndex))
        }
        return line
    }
    
    private func scanMultilineField() throws -> String {
        // There should be nothing after ':'
        guard let line = scanLine() else {
            try throwError(.expectedNewlineInMultilineField)
        }
        guard line.isEmpty else {
            try throwError(.invalidCharacterInMultilineField)
        }
        
        // Read the value terminated by '$' on a newline.
        // '$$' is an escape character.
        var value = ""
        var multilineBlockTerminated = false
        var firstLine = true
        while var line = scanLine() {
            switch firstLine {
            case true: firstLine = false
            case false: value += "\n"
            }
            if line.characters.first == "$" {
                let count = line.characters.count
                if count == 1 {
                    multilineBlockTerminated = true
                    break
                } else if line.hasPrefix("$$") {
                    line.remove(at: line.startIndex)
                } else {
                    try throwError(.invalidEscapeSequenceInMultilineField)
                }
            }
            value += line
        }
        if !multilineBlockTerminated {
            try throwError(.unterminatedMultilineField)
        }
        if value.hasSuffix("\n") {
            value = value.substring(to: value.index(before: value.endIndex))
        }
        return value
    }

    @noreturn
    private func throwError(_ kind: ConfigFileError.ErrorKind) throws {
        throw ConfigFileError(kind: kind, line: scanner?.line, column: scanner?.column)
    }
}
