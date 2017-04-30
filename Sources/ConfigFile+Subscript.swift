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
    subscript (_ name: String) -> String? {
        get { return get(name) }
        set { set(name, newValue) }
    }
    
    subscript (_ name: String) -> Int? {
        get { return get(name) }
        set { set(name, newValue) }
    }
    
    subscript (_ name: String) -> Int8? {
        get { return get(name) }
        set { set(name, newValue) }
    }

    subscript (_ name: String) -> Int16? {
        get { return get(name) }
        set { set(name, newValue) }
    }

    subscript (_ name: String) -> Int32? {
        get { return get(name) }
        set { set(name, newValue) }
    }

    subscript (_ name: String) -> Int64? {
        get { return get(name) }
        set { set(name, newValue) }
    }

    subscript (_ name: String) -> UInt? {
        get { return get(name) }
        set { set(name, newValue) }
    }
    
    subscript (_ name: String) -> UInt8? {
        get { return get(name) }
        set { set(name, newValue) }
    }
    
    subscript (_ name: String) -> UInt16? {
        get { return get(name) }
        set { set(name, newValue) }
    }
    
    subscript (_ name: String) -> UInt32? {
        get { return get(name) }
        set { set(name, newValue) }
    }
    
    subscript (_ name: String) -> UInt64? {
        get { return get(name) }
        set { set(name, newValue) }
    }
    
    subscript (_ name: String) -> Bool? {
        get { return get(name) }
        set { set(name, newValue) }
    }

    subscript (_ name: String) -> Double? {
        get { return get(name) }
        set { set(name, newValue) }
    }

    subscript (_ name: String) -> Float? {
        get { return get(name) }
        set { set(name, newValue) }
    }

    subscript (_ name: String) -> Character? {
        get { return get(name) }
        set { set(name, newValue) }
    }
}
