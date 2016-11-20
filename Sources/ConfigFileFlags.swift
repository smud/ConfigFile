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

struct ConfigFileFlags: OptionSet {
    let rawValue: Int
    
    static let sortSections  = ConfigFileFlags(rawValue: 1 << 0)
    static let sortFields = ConfigFileFlags(rawValue: 1 << 1)
    
    static let defaults: ConfigFileFlags = []
}
