//
// ConfigFile.swift
//
// This source file is part of the SMUD open source project
//
// Copyright (c) 2016 SMUD project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.txt for license information
// See AUTHORS.txt for the list of SMUD project authors
//

import Foundation
import CollectionUtils
import StringUtils
import ScannerUtils

public class ConfigFile {
    // DEBUG
    static let logFields = false
    
    typealias Fields = OrderedDictionary<String, String>
    typealias Sections = OrderedDictionary<String, Fields>
    
    var flags: ConfigFileFlags
    var filename: String?
    var scanner: Scanner?
    var sections = Sections()

    let whitespacesAndNewlines = CharacterSet.whitespacesAndNewlines
    let decimalDigits = CharacterSet.decimalDigits
    
    public var sectionNames: [String] { return sections.orderedKeys }
    public var isEmpty: Bool { return sections.isEmpty }

    public init(flags: ConfigFileFlags = .defaults) {
        self.flags = flags
    }
    
    public convenience init(fromFile filename: String, flags: ConfigFileFlags = .defaults) throws {
        self.init(flags: flags)
        try load(fromFile: filename)
    }

    public convenience init(fromString string: String, flags: ConfigFileFlags = .defaults) throws {
        self.init(flags: flags)
        try load(fromString: string)
    }

    public func load(fromFile filename: String) throws {
        self.filename = filename

        let contents = try String(contentsOfFile: filename, encoding: .utf8)
        try load(fromString: contents)
    }

    public func load(fromString string: String) throws {
        let scanner = Scanner(string: string
            .replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: "\r", with: "\n"))
        self.scanner = scanner
        self.sections.removeAll(keepingCapacity: true)
        
        while !scanner.isAtEnd {
            try scanNextSection()
        }
    }
    
    public func save(toFile filename: String, atomically: Bool = true) throws {
        var out = ""
        
        var sectionKeys = sections.orderedKeys
        if flags.contains(.sortSections) {
            sectionKeys.sort {
                $0.compare($1, options: .numeric) == .orderedAscending
            }
        }
        for sectionKey in sectionKeys {
            guard !sectionKey.contains("]") else {
                try throwError(.sectionNameShouldntContainBrackets)
            }
            if !out.isEmpty {
                out += "\n"
            }
            out += "[\(sectionKey)]\n"
            guard let fields = sections[sectionKey] else { continue }
        
            var fieldKeys = fields.orderedKeys
            if flags.contains(.sortFields) {
                fieldKeys.sort {
                    $0.compare($1, options: .numeric) == .orderedAscending
                }
            }
            
            for fieldKey in fieldKeys {
                guard let value = fields[fieldKey] else { continue }
                let name = fieldKey
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
                    value.forEachLine { line, stop in
                        if !line.isEmpty && line.hasPrefix("$") {
                            out += "$";
                        }
                        out += "\(line)\n"
                    }
                    //if value.hasSuffix("\n") {
                    //    out += "\n"
                    //}
                    out += "$\n"
                case false:
                    out += "\(name) \(value)\n"
                }
            }
        }

        try out.write(toFile: filename, atomically: atomically, encoding: .utf8)
    }
    
    public func fieldNames(section: String) -> [String] {
        return sections[section]?.orderedKeys ?? []
    }
    
    public func string(section: String, field: String) -> String? {
        return sections[section]?[field]
    }
    
    public func int(section: String, field: String) -> Int? {
        guard let value = string(section: section, field: field) else { return nil }
        return Int(value)
    }

    public func int8(section: String, field: String) -> Int8? {
        guard let value = string(section: section, field: field) else { return nil }
        return Int8(value)
    }

    public func int16(section: String, field: String) -> Int16? {
        guard let value = string(section: section, field: field) else { return nil }
        return Int16(value)
    }

    public func int32(section: String, field: String) -> Int32? {
        guard let value = string(section: section, field: field) else { return nil }
        return Int32(value)
    }

    public func int64(section: String, field: String) -> Int64? {
        guard let value = string(section: section, field: field) else { return nil }
        return Int64(value)
    }

    public func uint(section: String, field: String) -> UInt? {
        guard let value = string(section: section, field: field) else { return nil }
        return UInt(value)
    }
    
    public func uint8(section: String, field: String) -> UInt8? {
        guard let value = string(section: section, field: field) else { return nil }
        return UInt8(value)
    }

    public func uint16(section: String, field: String) -> UInt16? {
        guard let value = string(section: section, field: field) else { return nil }
        return UInt16(value)
    }

    public func uint32(section: String, field: String) -> UInt32? {
        guard let value = string(section: section, field: field) else { return nil }
        return UInt32(value)
    }

    public func uint64(section: String, field: String) -> UInt64? {
        guard let value = string(section: section, field: field) else { return nil }
        return UInt64(value)
    }

    public func bool(section: String, field: String) -> Bool? {
        guard let value = int(section: section, field: field) else { return nil }
        return value != 0
    }

    public func double(section: String, field: String) -> Double? {
        guard let value = string(section: section, field: field) else { return nil }
        // Replace all commas with dots in case they ended up in config file somehow
        return Double(value.replacingOccurrences(of: ",", with: "."))
    }

    public func float(section: String, field: String) -> Float? {
        guard let value = string(section: section, field: field) else { return nil }
        // Replace all commas with dots in case they ended up in config file somehow
        return Float(value.replacingOccurrences(of: ",", with: "."))
    }
    
    public func character(section: String, field: String) -> Character? {
        guard let value = string(section: section, field: field) else { return nil }
        return value.characters.first
    }

    func bitIndexes(section: String, field: String) -> [Int]? {
        guard let value = string(section: section, field: field) else { return nil }
        
        var result = [Int]()
        
        let scanner = Scanner(string: value)
        guard scanner.skipString("(") else { return nil }
        while !scanner.skipString(")") {
            guard let word = scanner.scanCharacters(from: decimalDigits) else { return nil }
            guard let bitIndex = Int(word as String) else { return nil }
            result.append(bitIndex)

            scanner.skipString(",")
        }
        return result
    }
    
    public func optionSet<T: OptionSet>(section: String, field: String) -> T? where T.RawValue: UnsignedInteger {
        guard let indexes = bitIndexes(section: section, field: field) else { return nil }
        return T(bitIndexes: indexes)
    }
    
    public func delete(section: String) {
        sections.removeValue(forKey: section)
    }
    
    public func set(section: String, field: String, value: String) {
        let fields = sections[section] ?? Fields()
        fields[field] = value
        sections[section] = fields
    }

    public func set(section: String, field: String, value: Bool) {
        set(section: section, field: field, value: value ? 1 : 0)
    }

    public func set(section: String, field: String, value: Character) {
        set(section: section, field: field, value: String(value))
    }

    public func set<T: FloatingPoint>(section: String, field: String, value: T) where T: LosslessStringConvertible {
        let value = String(value).replacingOccurrences(of: ",", with: ".")
        set(section: section, field: field, value: value)
    }

    public func set<T>(section: String, field: String, value: T) where T: Integer {
        set(section: section, field: field, value: String(describing: value))
    }
    
    // Maybe over complicated a bit: http://stackoverflow.com/questions/32102936/how-do-you-enumerate-optionsettype-in-swift-2
    public func set<T: OptionSet>(section: String, field: String, value: T) where T.RawValue: UnsignedInteger, T.Element == T {
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
    
    func scanNextSection() throws {
        guard let scanner = scanner else { return }
        
        guard scanner.skipString("[") else {
            try throwError(.expectedSectionStart)
        }

        guard let section = scanner.scanUpTo("]") else {
            try throwError(.expectedSectionName)
        }

        guard scanner.skipString("]") else {
            try throwError(.expectedSectionEnd)
        }
        
        if ConfigFile.logFields {
            print("[\(section)]")
        }

        let fields = Fields()
        
        while true {
            guard !scanner.isAtEnd else { break } // No more data
            
            let previousLocation = scanner.scanLocation
            guard !scanner.skipString("[") else {
                scanner.scanLocation = previousLocation
                break // Empty section (which is allowed)
            }
         
            guard var field = scanner.scanUpToCharacters(from: scanner.charactersToBeSkipped ?? CharacterSet.whitespacesAndNewlines) else {
                try throwError(.expectedFieldName)
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
    
    func scanLine() -> String? {
        guard let scanner = scanner else { return "" }

        let previousCharactersToBeSkipped = scanner.charactersToBeSkipped
        scanner.charactersToBeSkipped = nil
        defer { scanner.charactersToBeSkipped = previousCharactersToBeSkipped }
        
        // If at "\n" already, return empty string
        guard !scanner.skipString("\n") else {
            return ""
        }
        
        guard let line = scanner.scanUpTo("\n") else {
            return nil
        }
        scanner.skipString("\n")
        return line
    }
    
    func scanMultilineField() throws -> String {
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

    func throwError(_ kind: ConfigFileError.ErrorKind) throws -> Never  {
        throw ConfigFileError(kind: kind, line: scanner?.line(), column: scanner?.column())
    }
}
