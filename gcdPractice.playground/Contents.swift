import UIKit


// serial and concurrent queue
let serialQueue = DispatchQueue(label: "serial")
let concurrentQueue = DispatchQueue(label: "concurrent", attributes: .concurrent)
type(of: serialQueue)
type(of: concurrentQueue)

serialQueue.async {
    for i in 1..<5 {
        print(i)
    }
}

concurrentQueue.async {
    for i in 15...20 {
        print(i)
    }
}


// initiallyInactive attribubte
let inactiveQueue = DispatchQueue(label: "concurrent", attributes: [.initiallyInactive, .concurrent])
inactiveQueue.async {
    print("done")
}
print("Not yet")
inactiveQueue.activate()
print("Now it's done")


// given time delay
let queueOne = DispatchQueue(label: "delay")
let timeDelay = DispatchTime.now() + 3.0 // 30 sec

queueOne.asyncAfter(deadline: timeDelay) {
    print("This should be delay")
}


//sync in order
let queueA = DispatchQueue(label: "A")
let queueB = DispatchQueue(label: "B")
let queueC = DispatchQueue(label: "C")
let queueX = DispatchQueue(label: "X")

queueA.sync {
    print(queueA.label)
}

queueX.sync {
    print(queueX.label)
}

queueB.sync {
    print(queueB.label)
}

queueX.sync {
    print(queueX.label)
}

queueC.sync {
    print(queueC.label)
}


// deadlock

//let serialQueueTwo = DispatchQueue(label: "serial")
//type(of: serialQueueTwo)
//serialQueueTwo.async {
//    serialQueueTwo.sync {
//        print("I'm inside sync")
//    }
//    print("I'm ourside async")
//}


// NSlock

class myClass: NSObject {

    var recursiveLock = NSRecursiveLock()

    func safeMethod() {
        recursiveLock.lock()
        print("safeMethod.lock")

        someFunction()

        recursiveLock.unlock()
        print("safeMethod.unlock")
    }

    func someFunction() {
        //run thread safe code from here
        recursiveLock.lock()
        print("someFunction.lock")

        recursiveLock.unlock()
        print("someFunction.unlock")
    }

}

var test = myClass()
test.safeMethod()
test.someFunction()


// resolving a deadlock

//let myQueue = DispatchQueue(label: "myLabel")
//myQueue.async {
//    myQueue.sync {
//    print("Inner block printed")
//  }
//  print("Outer block printed")
//}

// solution 1
let myQueue = DispatchQueue(label: "myLabel")
myQueue.async {
    myQueue.async {
    print("Inner block printed")
  }
  print("Outer block printed")
}

// solution 2
let myQueue2 = DispatchQueue(label: "myLabel", attributes: .concurrent)
myQueue2.async {
    myQueue2.sync {
    print("Inner block printed")
  }
  print("Outer block printed")
}


func serialQueueTest() {

    let customSerialQueue = DispatchQueue(label: "com.test.dipak")

    print("Step 1")
    customSerialQueue.async {
        print("Step 2")

        DispatchQueue.main.sync {
            print("Step 3: Inside main sync queue")
        }
    }

    print("Step 4")
    customSerialQueue.sync {
        print("Step 5: Inside Custom Serial Queue sync queue")
    }
}

serialQueueTest()


