//
//  SemVer.swift
//  SemVer
//
//  Created by devedbox on 2018/3/12.
//

public enum Release: String {
  case releaseToWeb = ""
  case generalAvailability = "ga"
  case releaseToManufacturing = "rtm"
  case releaseGandidate = "rc"
  case openBeta = "open_beta"
  case beta = "beta"
  case closedBeta = "closed_beta"
  case alpha = "alpha"
  case preAlpha = "pre_alpha"
}

extension Release: CustomStringConvertible {
  public var description: String {
    switch self {
    case .releaseToWeb:
      return rawValue
    default:
      return "-" + rawValue
    }
  }
}

// MARK: - SemanticVersionable.

public protocol SemanticVersionable: CustomStringConvertible {
  var major: UInt { get }
  var minor: UInt { get }
  var patch: UInt { get }
  
  var release: Release { get }
  var build: UInt { get }
}

extension SemanticVersionable {
  public var description: String {
    return "\(major).\(minor).\(patch)\(release.description).\(build)"
  }
}
