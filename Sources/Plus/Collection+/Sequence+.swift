//
//  Sequence+.swift
//  CollectionPlus
//
//  Created by devedbox on 2019/3/17.
//

extension Sequence {
  public func toArray() -> [Element] {
    return Array(self)
  }
}

extension Sequence where Element: Hashable {
  public func toSet() -> Set<Element> {
    return Set(self)
  }
}
