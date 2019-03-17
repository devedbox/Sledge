//
//  POSIX.swift
//  POSIX
//
//  Created by devedbox on 2019/3/17.
//

#if os(Linux)
@_exported import Glibc
#else
@_exported import Darwin.C
#endif
