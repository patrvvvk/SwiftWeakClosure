//  Copyrights (c) 2020 Patryk Budzinski.
import XCTest
@testable import SwiftWeakClosure

final class TestClassWithSingleProperty {
  
  var sample: String
  var closure: () -> () = { }
  var observerForDeinit: DeinitializationObserver
  
  init(_ str: String, observer: DeinitializationObserver, shouldContainRetainCycle: Bool = false) {
    self.sample = str
    self.observerForDeinit = observer
    
    if shouldContainRetainCycle {
      
      self.closure = {
        print(self.sample)
      }
      
    } else {
      self.closure = self ?> {
        print($0.sample)
      }
    }
    
    observerForDeinit.didInit()
  }
  
  
  deinit {
    observerForDeinit.deinit()
    print("TestClassWithSingleProperty has been deinitialized.")
  }
}

final class SwiftWeakClosureTests: XCTestCase, DeinitializationObserver {
  
  var cycleCounter: Int = 0
  func `deinit`() {
    cycleCounter -= 1
  }
  
  func didInit() {
    cycleCounter += 1
  }
  
  override func setUp() {
    super.setUp()
    cycleCounter = 0
  }
  
  //MARK: - Tests
  
  func testRetainCycleForWeak() {
    var instance: TestClassWithSingleProperty? = TestClassWithSingleProperty("Hello", observer: self, shouldContainRetainCycle: false)
    instance = nil // deinit
    var instance2: TestClassWithSingleProperty? = TestClassWithSingleProperty("Hello", observer: self, shouldContainRetainCycle: true)
    instance2 = nil
    XCTAssertEqual(self.cycleCounter, 1)
  }
  
  func testInstanceIsNilAtTheMomentOfExecution() {
    var instance: TestClassWithSingleProperty? = TestClassWithSingleProperty("Hello", observer: self)
    var instance2: TestClassWithSingleProperty = TestClassWithSingleProperty("Hello", observer: self)
    
    //    This would cause a fatal error
    //    instance2.closureThatRefersToSelf = {
    //      instance2.sample = instance!.sample
    //    }
    
    instance2.closure = instance ?> { instance in
      instance2.sample = instance.sample
    }
    
    instance = nil
    instance2.closure()
    XCTAssertEqual(self.cycleCounter, 1)
  }
  
  func testZippedInstancesInClosure() {
    var instance: TestClassWithSingleProperty? = TestClassWithSingleProperty("Hello", observer: self)
    var instance2: TestClassWithSingleProperty? = TestClassWithSingleProperty("Another Hello", observer: self)
    var instance3: TestClassWithSingleProperty = TestClassWithSingleProperty("Sample Text", observer: self)
    
    instance3.closure = (instance, instance2) &> { ins1, ins2 in
      ins2.sample = ins1.sample
    }
    instance3.closure()
    XCTAssertEqual(instance2?.sample, "Hello")
    
    instance3.closure = (instance3, instance2) &> { ins3, ins2 in
      ins3.sample = ins2.sample
    }
    instance2 = nil
    instance3.closure()
    XCTAssertEqual(instance3.sample, "Sample Text")
    XCTAssertEqual(self.cycleCounter, 2)
    instance = nil
    XCTAssertEqual(self.cycleCounter, 1)
  }
  
  static var allTests = [
    ("testRetainCycleForWeak", testRetainCycleForWeak),
    ("testInstanceIsNilAtTheMomentOfExecution", testInstanceIsNilAtTheMomentOfExecution),
    ("testZippedInstancesInClosure", testZippedInstancesInClosure)
  ]
}

func logSeparator() {
  print(Array(repeating: "=", count: 10).joined())
}

protocol DeinitializationObserver {
  func `deinit`() -> Void
  func didInit() -> Void
}
