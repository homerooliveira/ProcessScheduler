//
//  Array+Calculation.swift
//  ProcessScheduler
//
//  Created by Homero Oliveira on 16/09/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation

extension Sequence where Iterator.Element: BinaryFloatingPoint {
    var average: Element {
        return reduce(Element(0), +) / Element(underestimatedCount)
    }
}

extension Sequence where Iterator.Element: Numeric {
    var sum: Element {
        return reduce(0, +)
    }
}

extension Sequence {
    func eachPair() -> AnySequence<(Iterator.Element, Iterator.Element)> {
        return AnySequence(zip(self.dropFirst(), self))
    }
}

extension Collection {
    
    func chunked(by distance: Int) -> [SubSequence] {
        precondition(distance > 0, "distance must be greater than 0") // prevents infinite loop
        
        var index = startIndex
        let iterator = AnyIterator({ () -> Self.SubSequence? in
            let newIndex = self.index(index, offsetBy: distance, limitedBy: self.endIndex) ?? self.endIndex
            defer { index = newIndex }
            let range = index ..< newIndex
            return index != self.endIndex ? self[range] : nil
        })
        
        return Array(iterator)
    }
    
}
