//
//  File.swift
//  
//
//  Created by Patryk Budzinski on 18/05/2020.
//

import Foundation

postfix operator >|

public postfix func >| (_ closure: @escaping () -> Any) -> () -> Void {
  return {
    closure()
  }
}
