//
// ConfigFileTests.swift
//
// This source file is part of the SMUD open source project
//
// Copyright (c) 2016 SMUD project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SMUD project authors
//

import XCTest
@testable import ConfigFile
import Foundation

class ConfigFileTests: XCTestCase {
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    // XCTAssertEqual(ConfigFile().text, "Hello, World!")

    struct UInt8Set: OptionSet {
        let rawValue: UInt8
        init(rawValue: UInt8) { self.rawValue = rawValue }
        static let first = UInt8Set(rawValue: 1 << 0)
        static let middle = UInt8Set(rawValue: 1 << 4)
        static let hiddenValue = UInt8Set(rawValue: 1 << 5)
        static let last = UInt8Set(rawValue: 1 << 7)
    }

    struct UInt64Set: OptionSet {
        let rawValue: UInt64
        init(rawValue: UInt64) { self.rawValue = rawValue }
        static let first = UInt64Set(rawValue: 1 << 0)
        static let middle = UInt64Set(rawValue: 1 << 31)
        static let hiddenValue = UInt64Set(rawValue: 1 << 40)
        static let last = UInt64Set(rawValue: 1 << 63)
    }

    let value1 = ""
    let value2 = " "
    let value3 = "abcd"
    let value4 = "abcd\nefgh\nijkl"
    let value5 = "abcd\n$efgh\nijkl"
    let value6 = "abcd\n$efgh\nijkl$"
    let value7 = "abcd\nefgh\nijkl\n"
    let value8 = "abcd\nefgh\nijkl\n$"
    let value9 = "abcd\nefgh\nijkl\n\n"
    let value10 = "\nabcd\nefgh\nijkl\n\n"
    let value11 = "\n"
    let value12 = "\0"
    let value13 = "Zero in the mi\0ddle"
    let value14 = "Line1\nLine2\0\nLine3"
    
    let intValue: Int = -1234567
    let int8Value: Int8 = -123
    let int16Value: Int16 = -12345
    let int32Value: Int32 = -1234567
    let int64Value: Int64 = -1234567890
    let uintValue: UInt = 1234567
    let uint8Value: UInt8 = 123
    let uint16Value: UInt16 = 12345
    let uint32Value: UInt32 = 1234567
    let uint64Value: UInt64 = 1234567890
    let boolTrueValue: Bool = true
    let boolFalseValue: Bool = false
    let doubleValue: Double = 12345.12345
    let floatValue: Float = 123.123
    let characterValue: Character = "🐉"
    let uint8Set: UInt8Set = [.first, .middle, /* hiddenValue, */ .last]
    let uint64Set: UInt64Set = [.first, .middle, /* hiddenValue, */ .last]
    
    func testScannerNullCharacters() {
        let scanner = Scanner(string: "a\0b\0")
        let result = scanner.scanString("a\0")
        //print("result: \(result.debugDescription), scanner.string: \(scanner.string.debugDescription)")
        XCTAssertEqual(result, "a\0")
        XCTAssertEqual(scanner.string, "a\0b\0")
    }
    
    func testFileNullCharacters() {
        let filename = "ConfigFileTestNull.txt"
        let string = "a\0b"
        do {
            try string.write(toFile: filename, atomically: true, encoding: .utf8)
            let result = try String(contentsOfFile: filename, encoding: .utf8)
            XCTAssert(string == result)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testSave() {
        let filename = "ConfigFileTestSave.txt"
        performSave(filename: filename)
    }
    
    func testLoad() {
        // Can't reuse testSave() because tests can be executed in parallel
        
        let filename = "ConfigFileTestLoad.txt"
        performSave(filename: filename, flags: .defaults)
        
        let configFile = ConfigFile()
        do {
            try configFile.load(fromFile: filename)
        } catch {
            XCTFail("Unable to load ConfigFile: \(error)")
        }
        
        XCTAssertEqual(value1, configFile.string(section: "MAIN", field: "TEST1"))
        XCTAssertEqual(value2, configFile.string(section: "MAIN", field: "TEST2"))
        XCTAssertEqual(value3, configFile.string(section: "MAIN", field: "TEST3"))
        XCTAssertEqual(value4, configFile.string(section: "MAIN", field: "TEST4"))
        XCTAssertEqual(value5, configFile.string(section: "MAIN", field: "TEST5"))
        XCTAssertEqual(value6, configFile.string(section: "MAIN", field: "TEST6"))
        XCTAssertEqual(value7, configFile.string(section: "MAIN", field: "TEST7"))
        XCTAssertEqual(value8, configFile.string(section: "MAIN", field: "TEST8"))
        XCTAssertEqual(value9, configFile.string(section: "MAIN", field: "TEST9"))
        XCTAssertEqual(value10, configFile.string(section: "MAIN", field: "TEST10"))
        XCTAssertEqual(value11, configFile.string(section: "MAIN", field: "TEST11"))
        XCTAssertEqual(value12, configFile.string(section: "MAIN", field: "TEST12"))
        XCTAssertEqual(value13, configFile.string(section: "MAIN", field: "TEST13"))
        XCTAssertEqual(value14, configFile.string(section: "MAIN", field: "TEST14"))
        
        XCTAssertTrue(intValue == configFile.get(section: "TYPES", field: "int"))
        XCTAssertTrue(int8Value == configFile.get(section: "TYPES", field: "int8"))
        XCTAssertTrue(int16Value == configFile.get(section: "TYPES", field: "int16"))
        XCTAssertTrue(int32Value == configFile.get(section: "TYPES", field: "int32"))
        XCTAssertTrue(int64Value == configFile.get(section: "TYPES", field: "int64"))
        XCTAssertTrue(uintValue == configFile.get(section: "TYPES", field: "uint"))
        XCTAssertTrue(uint8Value == configFile.get(section: "TYPES", field: "uint8"))
        XCTAssertTrue(uint16Value == configFile.get(section: "TYPES", field: "uint16"))
        XCTAssertTrue(uint32Value == configFile.get(section: "TYPES", field: "uint32"))
        XCTAssertTrue(uint64Value == configFile.get(section: "TYPES", field: "uint64"))
        XCTAssertTrue(boolTrueValue == configFile.get(section: "TYPES", field: "boolTrue"))
        XCTAssertTrue(boolFalseValue == configFile.get(section: "TYPES", field: "boolFalse"))
        XCTAssertTrue(doubleValue == configFile.get(section: "TYPES", field: "double"))
        XCTAssertTrue(floatValue == configFile.get(section: "TYPES", field: "float"))
        XCTAssertTrue(characterValue == configFile.get(section: "TYPES", field: "character"))
        XCTAssertTrue(uint8Set == configFile.get(section: "TYPES", field: "uint8Set"))
        XCTAssertTrue(uint64Set == configFile.get(section: "TYPES", field: "uint64Set"))
        
        XCTAssertEqual(configFile.sectionNames, ["MAIN", "TYPES", "A", "C", "B", "D"])
        XCTAssertEqual(configFile.fieldNames(section: "A"), ["a", "c", "b", "d"])
    }
    
    func testLoadSorted() {
        let filename = "ConfigFileTestLoadSorted.txt"
        performSave(filename: filename, flags: [.sortSections, .sortFields])

        let configFile = ConfigFile()
        do {
            try configFile.load(fromFile: filename)
        } catch {
            XCTFail("Unable to load ConfigFile: \(error)")
        }

        
        XCTAssertEqual(configFile.sectionNames, ["A", "B", "C", "D", "MAIN", "TYPES"])
        XCTAssertEqual(configFile.fieldNames(section: "A"), ["a", "b", "c", "d"])
    }
    
    func performSave(filename: String, flags: ConfigFileFlags = .defaults) {
        let configFile = ConfigFile()
        configFile.flags = flags
        configFile.set(section: "MAIN", field: "TEST1", value: value1)
        configFile.set(section: "MAIN", field: "TEST2", value: value2)
        configFile.set(section: "MAIN", field: "TEST3", value: value3)
        configFile.set(section: "MAIN", field: "TEST4", value: value4)
        configFile.set(section: "MAIN", field: "TEST5", value: value5)
        configFile.set(section: "MAIN", field: "TEST6", value: value6)
        configFile.set(section: "MAIN", field: "TEST7", value: value7)
        configFile.set(section: "MAIN", field: "TEST8", value: value8)
        configFile.set(section: "MAIN", field: "TEST9", value: value9)
        configFile.set(section: "MAIN", field: "TEST10", value: value10)
        configFile.set(section: "MAIN", field: "TEST11", value: value11)
        configFile.set(section: "MAIN", field: "TEST12", value: value12)
        configFile.set(section: "MAIN", field: "TEST13", value: value13)
        configFile.set(section: "MAIN", field: "TEST14", value: value14)
        
        configFile.set(section: "TYPES", field: "int", value: intValue)
        configFile.set(section: "TYPES", field: "int8", value: int8Value)
        configFile.set(section: "TYPES", field: "int16", value: int16Value)
        configFile.set(section: "TYPES", field: "int32", value: int32Value)
        configFile.set(section: "TYPES", field: "int64", value: int64Value)
        configFile.set(section: "TYPES", field: "uint", value: uintValue)
        configFile.set(section: "TYPES", field: "uint8", value: uint8Value)
        configFile.set(section: "TYPES", field: "uint16", value: uint16Value)
        configFile.set(section: "TYPES", field: "uint32", value: uint32Value)
        configFile.set(section: "TYPES", field: "uint64", value: uint64Value)
        configFile.set(section: "TYPES", field: "boolTrue", value: boolTrueValue)
        configFile.set(section: "TYPES", field: "boolFalse", value: boolFalseValue)
        configFile.set(section: "TYPES", field: "double", value: doubleValue)
        configFile.set(section: "TYPES", field: "float", value: floatValue)
        configFile.set(section: "TYPES", field: "character", value: characterValue)
        configFile.set(section: "TYPES", field: "uint8Set", value: uint8Set)
        configFile.set(section: "TYPES", field: "uint64Set", value: uint64Set)
        
        // Test order preservation
        configFile.set(section: "A", field: "a", value: "A.a")
        configFile.set(section: "A", field: "c", value: "A.c")
        configFile.set(section: "A", field: "b", value: "A.b")
        configFile.set(section: "A", field: "d", value: "A.d")
        configFile.set(section: "C", field: "a", value: "C.a")
        configFile.set(section: "B", field: "a", value: "B.a")
        configFile.set(section: "D", field: "a", value: "D.a")
        
        do {
            try configFile.save(toFile: filename)
        } catch {
            XCTFail("Unable to save ConfigFile: \(error)")
        }
    }
    
    func testParseErrors() {
        let configFile = ConfigFile()
        var foundSyntaxError1 = false
        do {
            try configFile.load(fromString: "[MAIN]\n[SECOND")
        } catch {
            print("Syntax error (as expected): \(error)")
            foundSyntaxError1 = true
        }
        XCTAssert(foundSyntaxError1)
    }
    
    func testBinaryFile() {
        let filename = "ConfigFileTestBinaryFile.txt"
        let testString = getAllUnicodeScalarsAsString()
        
        do {
            try testString.write(toFile: filename, atomically: true, encoding: .utf8)
        } catch {
            XCTFail("Unable to save binary file: \(error)")
        }

        do {
            let inString = try String(contentsOfFile: filename, encoding: .utf8)
            compareCharacterByCharacter(testString, inString)
            XCTAssertTrue(inString == testString)
        } catch {
            XCTFail("Unable to read binary file: \(error)")
        }
    }
    
    func testUnicodeScalars() {
        // Newlines are normalized on load, so exclude them from test
        let testString = getAllUnicodeScalarsAsString()
            .replacingOccurrences(of: "\r\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
        
        let configFile = ConfigFile()
        configFile.set(section: "UnicodeScalars", field: "allScalars", value: testString)
        
        let filename = "ConfigFileTestUnicodeScalars.txt"
        do {
            try configFile.save(toFile: filename)
        } catch {
            XCTFail("Unable to save ConfigFile: \(error)")
        }

        let configFile2: ConfigFile
        do {
            try configFile2 = ConfigFile(fromFile: filename)
            let inString = configFile2.string(section: "UnicodeScalars", field: "allScalars") ?? ""
            compareCharacterByCharacter(testString, inString)
            XCTAssertTrue(testString == inString)
        } catch {
            XCTFail("Unable to load ConfigFile: \(error)")
        }
    }
    
    func getAllUnicodeScalarsAsString() -> String {
        var string = ""
        var c = UnicodeScalar(0)!
        while true {
            string.append(String(c))
            // Unicode scalars are [0 - D7FF] inclusive
            guard c.value < 0xD7FF else { break }
            c = UnicodeScalar(c.value + 1)!
        }
        return string
    }
    
    func compareCharacterByCharacter(_ s1: String, _ s2: String) {
        let s1Length = s1.characters.count
        let s2Length = s2.characters.count
        print("s1 length: \(s1Length), s2 length: \(s2Length)")
        if s1 != s2 && s1Length == s2Length {
            var index = 0
            for (c1, c2) in zip(s1.characters, s2.characters) {
                if c1 != c2 {
                    print("Character mismatch at index \(index): '\(c1)' vs '\(c2)'; \(String(c1).unicodeScalars.first!.value), \(String(c2).unicodeScalars.first!.value)")
                }
                index += 1
            }
        }
    }

    static var allTests : [(String, (ConfigFileTests) -> () throws -> Void)] {
        return [
            ("testScannerNullCharacters", testScannerNullCharacters),
            ("testFileNullCharacters", testFileNullCharacters),
            ("testSave", testSave),
            ("testLoad", testLoad),
            ("testParseErrors", testParseErrors),
        ]
    }
}
