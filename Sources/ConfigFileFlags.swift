//
// ConfigFileFlags.swift
//
// This source file is part of the SMUD open source project
//
// Copyright (c) 2016 SMUD project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.txt for license information
// See AUTHORS.txt for the list of SMUD project authors
//

public struct ConfigFileFlags: OptionSet {
    public let rawValue: Int
    
    public static let sortSections  = ConfigFileFlags(rawValue: 1 << 0)
    public static let sortFields = ConfigFileFlags(rawValue: 1 << 1)
    
    public static let defaults: ConfigFileFlags = []

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
