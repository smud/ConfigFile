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
        
        XCTAssertEqual(intValue, configFile.get(".fieldWithoutSection1"))
        XCTAssertEqual(intValue, configFile.get("fieldWithoutSection2"))
        XCTAssertEqual(intValue, configFile.get(".fieldName.withDot"))
        
        XCTAssertEqual(value1, configFile.get("MAIN.TEST1"))
        XCTAssertEqual(value2, configFile.get("MAIN.TEST2"))
        XCTAssertEqual(value3, configFile.get("MAIN.TEST3"))
        XCTAssertEqual(value4, configFile.get("MAIN.TEST4"))
        XCTAssertEqual(value5, configFile.get("MAIN.TEST5"))
        XCTAssertEqual(value6, configFile.get("MAIN.TEST6"))
        XCTAssertEqual(value7, configFile.get("MAIN.TEST7"))
        XCTAssertEqual(value8, configFile.get("MAIN.TEST8"))
        XCTAssertEqual(value9, configFile.get("MAIN.TEST9"))
        XCTAssertEqual(value10, configFile.get("MAIN.TEST10"))
        XCTAssertEqual(value11, configFile.get("MAIN.TEST11"))
        XCTAssertEqual(value12, configFile.get("MAIN.TEST12"))
        XCTAssertEqual(value13, configFile.get("MAIN.TEST13"))
        XCTAssertEqual(value14, configFile.get("MAIN.TEST14"))
        
        XCTAssertTrue(intValue == configFile.get("TYPES.int"))
        XCTAssertTrue(int8Value == configFile.get("TYPES.int8"))
        XCTAssertTrue(int16Value == configFile.get("TYPES.int16"))
        XCTAssertTrue(int32Value == configFile.get("TYPES.int32"))
        XCTAssertTrue(int64Value == configFile.get("TYPES.int64"))
        XCTAssertTrue(uintValue == configFile.get("TYPES.uint"))
        XCTAssertTrue(uint8Value == configFile.get("TYPES.uint8"))
        XCTAssertTrue(uint16Value == configFile.get("TYPES.uint16"))
        XCTAssertTrue(uint32Value == configFile.get("TYPES.uint32"))
        XCTAssertTrue(uint64Value == configFile.get("TYPES.uint64"))
        XCTAssertTrue(boolTrueValue == configFile.get("TYPES.boolTrue"))
        XCTAssertTrue(boolFalseValue == configFile.get("TYPES.boolFalse"))
        XCTAssertTrue(doubleValue == configFile.get("TYPES.double"))
        XCTAssertTrue(floatValue == configFile.get("TYPES.float"))
        XCTAssertTrue(characterValue == configFile.get("TYPES.character"))
        XCTAssertTrue(uint8Set == configFile.get("TYPES.uint8Set"))
        XCTAssertTrue(uint64Set == configFile.get("TYPES.uint64Set"))
        
        XCTAssertEqual(configFile.sectionNames, ["", "MAIN", "TYPES", "A", "C", "B", "D"])
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

        
        XCTAssertEqual(configFile.sectionNames, ["", "A", "B", "C", "D", "MAIN", "TYPES"])
        XCTAssertEqual(configFile.fieldNames(section: "A"), ["a", "b", "c", "d"])
    }
    
    func performSave(filename: String, flags: ConfigFileFlags = .defaults) {
        let configFile = ConfigFile()
        configFile.flags = flags
        
        configFile.set(".fieldWithoutSection1", intValue)
        configFile.set("fieldWithoutSection2", intValue)
        configFile.set(".fieldName.withDot", intValue)
        
        configFile.set("MAIN.TEST1", value1)
        configFile.set("MAIN.TEST2", value2)
        configFile.set("MAIN.TEST3", value3)
        configFile.set("MAIN.TEST4", value4)
        configFile.set("MAIN.TEST5", value5)
        configFile.set("MAIN.TEST6", value6)
        configFile.set("MAIN.TEST7", value7)
        configFile.set("MAIN.TEST8", value8)
        configFile.set("MAIN.TEST9", value9)
        configFile.set("MAIN.TEST10", value10)
        configFile.set("MAIN.TEST11", value11)
        configFile.set("MAIN.TEST12", value12)
        configFile.set("MAIN.TEST13", value13)
        configFile.set("MAIN.TEST14", value14)
        
        configFile.set("TYPES.int", intValue)
        configFile.set("TYPES.int8", int8Value)
        configFile.set("TYPES.int16", int16Value)
        configFile.set("TYPES.int32", int32Value)
        configFile.set("TYPES.int64", int64Value)
        configFile.set("TYPES.uint", uintValue)
        configFile.set("TYPES.uint8", uint8Value)
        configFile.set("TYPES.uint16", uint16Value)
        configFile.set("TYPES.uint32", uint32Value)
        configFile.set("TYPES.uint64", uint64Value)
        configFile.set("TYPES.boolTrue", boolTrueValue)
        configFile.set("TYPES.boolFalse", boolFalseValue)
        configFile.set("TYPES.double", doubleValue)
        configFile.set("TYPES.float", floatValue)
        configFile.set("TYPES.character", characterValue)
        configFile.set("TYPES.uint8Set", uint8Set)
        configFile.set("TYPES.uint64Set", uint64Set)
        
        // Test order preservation
        configFile.set("A.a", "A.a")
        configFile.set("A.c", "A.c")
        configFile.set("A.b", "A.b")
        configFile.set("A.d", "A.d")
        configFile.set("C.a", "C.a")
        configFile.set("B.a", "B.a")
        configFile.set("D.a", "D.a")
        
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
        configFile.set("UnicodeScalars.allScalars", testString)
        
        let filename = "ConfigFileTestUnicodeScalars.txt"
        do {
            try configFile.save(toFile: filename)
        } catch {
            XCTFail("Unable to save ConfigFile: \(error)")
        }

        let configFile2: ConfigFile
        do {
            try configFile2 = ConfigFile(fromFile: filename)
            let inString = configFile2.get("UnicodeScalars.allScalars") ?? ""
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
