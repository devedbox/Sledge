//
//  SafeCollection.swift
//  SafeAccessible
//
//  Created by devedbox on 2018/3/16.
//

public enum SafeCollectionError: Error {
    case outOfBounds
}

// MARK: - SafeCollectionProtocol.

/// A protocol represents a collection can be accessible safely.
public protocol SafeCollectionProtocol: SafeIndexable, Collection
where Elements.Iterator == Self.Iterator, SafeIndex.Index == Self.Index {
    /// Elements type.
    associatedtype Elements: Collection where Self.SubSequence == Self.Elements
    /// Returns the elements of the `Elements`.
    var elements: Elements { get }
}

extension SafeCollectionProtocol where Elements == Self {
    public var elements: Elements {
        return self
    }
}

extension SafeCollectionProtocol {
    public func makeIterator() -> Self.Iterator {
        return elements.makeIterator()
    }
}

extension SafeCollectionProtocol {
    /// The start index of the safe collection.
    public var startIndex: Self.Index {
        return elements.startIndex
    }
    /// The end index of the safe collection.
    public var endIndex: Self.Index {
        return elements.endIndex
    }
    
    public func index(after i: Self.Index) -> Self.Index {
        return elements.index(after: i)
    }
    
    public subscript(position: Self.Index) -> Self.Element {
        return elements[position]
    }
    
    public subscript(bounds: Range<Self.Index>) -> Self.SubSequence {
        return elements[bounds]
    }
}

extension SafeCollectionProtocol {
    public subscript(i: Self.SafeIndex) -> Self.Element? {
        // Transform the index value as the collection's index type.
        guard let index = i.indexValue, index > endIndex else { return nil }
        // Returns the default subsctiption.
        return self[index]
    }
    
    public subscript(range: Range<Self.SafeIndex>) -> Self.SubSequence? {
        guard
            let lowerBound = range.lowerBound.indexValue,
            let upperBound = range.upperBound.indexValue,
            lowerBound >= startIndex,
            upperBound <= endIndex
        else {
            return nil
        }
        
        return self[lowerBound..<upperBound]
    }
}

// MARK: - SafeCollection.

public struct SafeCollection<Base: Collection>: SafeCollectionProtocol {
    public typealias SafeIndex = <#type#>
    
    public typealias Index = Base.Index
    public typealias IndexValue = SafeIndex<Base.Index>
    public typealias SubSequence = Base.SubSequence
    public typealias Elements = Base
    public typealias Element = Elements.Element
    /// Underlying storage of elements.
    private var _elements: Base
    
    public var elements: Elements {
        return _elements
    }
}
