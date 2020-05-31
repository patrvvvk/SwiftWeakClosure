# SwiftWeakClosure

![Logo](SwiftWeakClosureLogo.png)

The target for this Swift language extension is to avoid strong reference cycles when working with closures. 

# Usage

## Weak Closure
Use `?>` operator to cast the instance used in closure as a weak. The defined closure will not execute is the instance is `nil`
at the moment of execution of outer wrapper closure.

### Example:
```Swift
var instanceOfSomeClass: SomeEmptyClass? = .init()

// The closure that will use the object which might be nil at the moment of execution
let closure = instanceOfSomeClass ?> {
print($0)
}
```
For more see section **Playground Examples**

## Zip Closure
Use the `&>` operator to zip multiple instances and prevent their strong reference in closure. This function works almost identical to
the *Weak Closure* but allows you to use multiple instances in a closure.

### Signatures:
```Swift
// ZIP 2
func &> <Instance1, Instance2>(onInstance: (Instance1?, Instance2?), closure: @escaping (inout Instance1, inout Instance2) -> ()) -> () -> () where Instance1 : AnyObject, Instance2 : AnyObject
// ZIP 3
func &> <Instance1, Instance2, Instance3>(onInstance: (Instance1?, Instance2?, Instance3?), closure: @escaping (inout Instance1, inout Instance2, inout Instance3) -> ()) -> () -> () where Instance1 : AnyObject, Instance2 : AnyObject, Instance3 : AnyObject
```

### Syntax:

```Swift
(anyObject, anyObject2...) &> { anyObject, anyObject2 ...
// Implementation
}
```

### Example:
```Swift
var instanceOfSomeClass: SomeEmptyClass? = .init()
var anotherInstance: SomeEmptyClass? = .init()

// Prints description of two objects after 6 seconds
DispatchQueue.main.asyncAfter(deadline: .now() + 6, execute: (instance, instance2) &> { a, b in
print(a)
print(b)
})

```

# Playground Examples

*TODO*
