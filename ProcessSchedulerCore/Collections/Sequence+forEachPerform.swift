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
    
    func log(_ identifier: String = "") -> Self {
        forEach { (element) in
            print("\(identifier) - \(element)")
        }
        return self
    }
}

extension LazySequenceProtocol {
    func onEach(_ body: @escaping (Element) -> ())
        -> LazyForEachSequence<Self>
    {
        return LazyForEachSequence(base: self,
                                   perform: body)
    }
}

struct LazyForEachIterator<Base: IteratorProtocol>
    : IteratorProtocol
{
    mutating func next() -> Base.Element? {
        guard let nextElement = base.next() else {
            return nil
        }
        perform(nextElement)
        return nextElement
    }
    var base: Base
    let perform: (Base.Element) -> ()
}

struct LazyForEachSequence<Base: Sequence>
    : LazySequenceProtocol
{
    func makeIterator()
        -> LazyForEachIterator<Base.Iterator>
    {
        return LazyForEachIterator(
            base: base.makeIterator(),
            perform: perform)
    }
    let base: Base
    let perform: (Base.Element) -> ()
}
