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
    
    func testSave() {
        let filename = "ConfigFileTestSave.txt"
        performSave(filename: filename)
    }
    
    func testLoad() {
        // Can't reuse testSave() because tests can be executed in parallel
        
        let filename = "ConfigFileTestLoad.txt"
        performSave(filename: filename)
        
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
    }
    
    func performSave(filename: String) {
        let configFile = ConfigFile()
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

    static var allTests : [(String, (ConfigFileTests) -> () throws -> Void)] {
        return [
            ("testSave", testSave),
            ("testLoad", testLoad),
            ("testParseErrors", testParseErrors),
        ]
    }
}
