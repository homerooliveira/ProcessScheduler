//
//  Sequence+forEachPerform.swift
//  ProcessScheduler
//
//  Created by Homero Oliveira on 16/09/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation

extension Sequence {
    /// Perform a side effect for each element in `self`.
    @discardableResult
    func onEach(_ body: (Element) throws -> ())
        rethrows -> Self
    {
        try forEach(body)
        return self
    }
}
