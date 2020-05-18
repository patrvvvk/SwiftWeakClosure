//
//  File.swift
//  
//
//  Created by Patryk Budzinski on 18/05/2020.
//

import Foundation

infix operator |>|

public func decisionClosure<T, E, P>(_ main: @escaping () -> Result<T, E>, onSuccess: @escaping (T) -> P, onFailure: @escaping (E) -> P?) -> () -> P? {
  return {
    switch main() {
      case .success(let result):
        return onSuccess(result)
      case .failure(let error):
        return onFailure(error)
    }
  }
}


