//  Created by Patryk Budzinski on 18/05/2020.
//  Copyrights (c) 2020 Patryk Budzinski.
import Foundation

/*
 * Multiple instances in closure
 */
infix operator &> 

public func &><Instance1: AnyObject, Instance2: AnyObject>(_ onInstance:  (Instance1?,  Instance2?), _ closure: @escaping (inout Instance1, inout Instance2) -> ()) -> () -> () {
  let instance1 = onInstance.0
  let instance2 = onInstance.1
  return { [weak instance1, weak instance2] in
    guard instance1 != nil, instance2 != nil else { return }
    closure(&instance1!, &instance2!)
  }
}

public func &><Instance1: AnyObject, Instance2: AnyObject, Instance3: AnyObject>(_ onInstance:  (Instance1?,  Instance2?, Instance3?), _ closure: @escaping (inout Instance1, inout Instance2, inout Instance3) -> ()) -> () -> () {
  let instance1 = onInstance.0
  let instance2 = onInstance.1
  let instance3 = onInstance.2
  return { [weak instance1, weak instance2, weak instance3] in
    guard instance1 != nil, instance2 != nil, instance3 != nil else { return }
    closure(&instance1!, &instance2!, &instance3!)
  }
}

