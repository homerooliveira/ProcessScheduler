//
//  Array+Calculation.swift
//  ProcessScheduler
//
//  Created by Homero Oliveira on 16/09/18.
//  Copyright © 2018 Homero Oliveira. All rights reserved.
//

import Foundation

extension Collection where Iterator.Element: BinaryFloatingPoint {
    var average: Element {
        return reduce(Element(0), +) / Element(count)
    }
} 

extension Sequence where Iterator.Element: Numeric {
    func sum(initialValue: Element = 0) -> Element {
        return reduce(initialValue, +)
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
