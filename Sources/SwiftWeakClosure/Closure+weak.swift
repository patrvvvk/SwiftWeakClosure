//  Created by Patryk Budzinski on 18/05/2020.
//  Copyrights (c) 2020 Patryk Budzinski.
import Foundation

infix operator ?>

public func ?> <Instance: AnyObject>(_ onInstance: Instance?, _ closure: @escaping (Instance) -> ()) -> () -> () {
  return { [weak onInstance] in
    guard onInstance != nil else { return }
    closure(onInstance!)
  }
}
