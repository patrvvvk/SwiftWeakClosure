import Foundation

infix operator ?>

public func ?> <Instance: AnyObject>(_ onInstance: inout Instance?, _ closure: @escaping (inout Instance) -> ()) -> () -> () {
  return { [weak onInstance] in
    guard onInstance != nil else { return }
    closure(&onInstance!)
  }
}
