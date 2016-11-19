//
// OptionSet+Utils.swift
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

extension OptionSet where RawValue: UnsignedInteger {
    init(bitIndexes: [Int]) {
        let result = bitIndexes.reduce(UIntMax(0)) {
            $0 | 1 << UIntMax($1)
        }
        self.init(rawValue: RawValue(result))
    }
}

