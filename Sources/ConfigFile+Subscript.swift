//
// ConfigFile+Subscript.swift
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

public extension ConfigFile {
    subscript (section: String, field: String) -> String? {
        get { return string(section: section, field: field) }
        set { set(section: section, field: field, value: newValue) }
    }
    
    subscript (section: String, field: String) -> Int? {
        get { return int(section: section, field: field) }
        set { set(section: section, field: field, value: newValue) }
    }
    
    subscript (section: String, field: String) -> Int8? {
        get { return int8(section: section, field: field) }
        set { set(section: section, field: field, value: newValue) }
    }

    subscript (section: String, field: String) -> Int16? {
        get { return int16(section: section, field: field) }
        set { set(section: section, field: field, value: newValue) }
    }

    subscript (section: String, field: String) -> Int32? {
        get { return int32(section: section, field: field) }
        set { set(section: section, field: field, value: newValue) }
    }

    subscript (section: String, field: String) -> Int64? {
        get { return int64(section: section, field: field) }
        set { set(section: section, field: field, value: newValue) }
    }

    subscript (section: String, field: String) -> UInt? {
        get { return uint(section: section, field: field) }
        set { set(section: section, field: field, value: newValue) }
    }
    
    subscript (section: String, field: String) -> UInt8? {
        get { return uint8(section: section, field: field) }
        set { set(section: section, field: field, value: newValue) }
    }
    
    subscript (section: String, field: String) -> UInt16? {
        get { return uint16(section: section, field: field) }
        set { set(section: section, field: field, value: newValue) }
    }
    
    subscript (section: String, field: String) -> UInt32? {
        get { return uint32(section: section, field: field) }
        set { set(section: section, field: field, value: newValue) }
    }
    
    subscript (section: String, field: String) -> UInt64? {
        get { return uint64(section: section, field: field) }
        set { set(section: section, field: field, value: newValue) }
    }
    
    subscript (section: String, field: String) -> Bool? {
        get { return bool(section: section, field: field) }
        set { set(section: section, field: field, value: newValue) }
    }

    subscript (section: String, field: String) -> Double? {
        get { return double(section: section, field: field) }
        set { set(section: section, field: field, value: newValue) }
    }

    subscript (section: String, field: String) -> Float? {
        get { return float(section: section, field: field) }
        set { set(section: section, field: field, value: newValue) }
    }

    subscript (section: String, field: String) -> Character? {
        get { return character(section: section, field: field) }
        set { set(section: section, field: field, value: newValue) }
    }
}
