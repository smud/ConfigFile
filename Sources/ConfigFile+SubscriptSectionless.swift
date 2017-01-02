//
// ConfigFile+SubscriptSectionless.swift
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
    subscript (field: String) -> String? {
        get { return self["", field] }
        set { self["", field] = newValue }
    }

    subscript (field: String) -> Int? {
        get { return self["", field] }
        set { self["", field] = newValue }
    }

    subscript (field: String) -> Int8? {
        get { return self["", field] }
        set { self["", field] = newValue }
    }
    
    subscript (field: String) -> Int16? {
        get { return self["", field] }
        set { self["", field] = newValue }
    }
    
    subscript (field: String) -> Int32? {
        get { return self["", field] }
        set { self["", field] = newValue }
    }

    subscript (field: String) -> Int64? {
        get { return self["", field] }
        set { self["", field] = newValue }
    }

    subscript (field: String) -> UInt? {
        get { return self["", field] }
        set { self["", field] = newValue }
    }
    
    subscript (field: String) -> UInt8? {
        get { return self["", field] }
        set { self["", field] = newValue }
    }
    
    subscript (field: String) -> UInt16? {
        get { return self["", field] }
        set { self["", field] = newValue }
    }
    
    subscript (field: String) -> UInt32? {
        get { return self["", field] }
        set { self["", field] = newValue }
    }
    
    subscript (field: String) -> UInt64? {
        get { return self["", field] }
        set { self["", field] = newValue }
    }

    subscript (field: String) -> Bool? {
        get { return self["", field] }
        set { self["", field] = newValue }
    }

    subscript (field: String) -> Double? {
        get { return self["", field] }
        set { self["", field] = newValue }
    }

    subscript (field: String) -> Float? {
        get { return self["", field] }
        set { self["", field] = newValue }
    }

    subscript (field: String) -> Character? {
        get { return self["", field] }
        set { self["", field] = newValue }
    }
}
