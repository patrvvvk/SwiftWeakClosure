//
//  Closure+append.swift
//  
//
//  Created by Patryk Budzinski on 18/05/2020.
//
import Foundation
infix operator +>

public func +> (_ closure: @escaping () -> (), _ appending: @escaping () -> ()) -> () -> () {
  return {
    closure()
    appending()
  }
}
