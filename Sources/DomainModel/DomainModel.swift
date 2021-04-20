struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    
  public var amount : Int
  public var currency : String
  
  public func convert(_ to: String) -> Money {
    
    var value : Money = Money(amount: 0, currency: "USD");
    
    if (self.currency == "GBP") {
        
        if to == "USD" {
            value.amount = (self.amount * 2)
        } else if to == "EUR" {
            value.amount = (((self.amount * 2) * 3) / 2)
        } else if to == "CAN" {
            value.amount = (((self.amount * 2) * 5) / 4)
        }
        
       
        
    } else if (self.currency == "USD") {
        
        if to == "GBP" {
            value.amount = (self.amount / 2)
        } else if to == "EUR" {
            value.amount = ((self.amount * 3) / 2)
        } else if to == "CAN" {
            value.amount = ((self.amount * 5) / 4)
        }
        
    } else if (self.currency == "CAN") {
        
        if to == "USD" {
            value.amount = ((self.amount * 4) / 5)
        } else if to == "GBP" {
            value.amount = (((self.amount * 4) / 5) / 2)
        } else if to == "EUR" {
            value.amount = ((((self.amount * 4) / 5) * 3) / 2)
        }
        
        
        
    } else if (self.currency == "EUR") {
        
        if to == "USD" {
            value.amount = ((self.amount * 2) / 3)
        } else if to == "GBP" {
            value.amount = (((self.amount * 2) / 3) / 2)
        } else if to == "CAN" {
            value.amount = ((((self.amount * 2) / 3) * 5) / 4)
        }
        
    }
    
    value.currency = to;
    return value;
    
  }
  
  public func add(_ to: Money) -> Money {
    
    var value : Money
    if (self.currency != to.currency) {
        
        let temp1 : Money = self.convert(to.currency)
        value = Money(amount: temp1.amount + to.amount, currency: to.currency)
        
    } else {
        
        value = Money(amount: self.amount + to.amount, currency: to.currency)
        
    }
    return value;
    
  }
    
  public func subtract(_ from: Money) -> Money {
    
    let temp1 : Money = self.convert(from.currency)
    let value : Money = Money(amount: from.amount - temp1.amount, currency: from.currency)
    return value;
    
  }
}

////////////////////////////////////
// Job
//
public class Job {
    fileprivate var title : String
    fileprivate var type : JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    public init(title : String, type : JobType) {
            self.title = title
            self.type = type
    }
    
    open func calculateIncome(_ hours: UInt) -> UInt {
        switch type {
            case let .Hourly(hourly): return UInt(Double(hourly) * Double(hours))
            case let .Salary(salary): return salary
        }
    }
    
    public func raise(byAmount : Double) {
        switch type {
            case let .Hourly(hourly):
                self.type = .Hourly(hourly + byAmount)
            case let .Salary(salary):
                self.type = .Salary(UInt(salary + UInt(byAmount)))
        }
    }
    
    public func raise(byPercent : Double) {
        switch type {
            case let .Hourly(hourly):
                self.type = .Hourly(hourly + (hourly * byPercent))
            case let .Salary(salary):
                self.type = .Salary(salary + UInt(Double(salary) * byPercent))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    
    fileprivate var _job : Job? = nil
    open var job : Job? {
        get {
            return _job
        }
        set(value) {
            if age > 15 {
                self._job = value
            }
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get {
            return _spouse
        }
        set(value) {
            if (spouse == nil) && (age > 18) {
                self._spouse = value
            }
            
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    open func toString() -> String {
        let job : String = _job?.title ?? "nil"
        let spouse : String = _spouse?.firstName ?? "nil"
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job) spouse:\(spouse)]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    fileprivate var members : [Person] = []
    
    public init(spouse1: Person, spouse2: Person) {
        spouse1._spouse = spouse2
        spouse2._spouse = spouse1
        members.append(contentsOf: [spouse1, spouse2])
    }
    
    open func haveChild(_ child: Person) -> Bool {
        for p in members {
            if p._spouse != nil && p.age >= 21 {
                members.append(contentsOf: [child])
                return true
                
            }
            
        }
        return false
    }
    
    open func householdIncome() -> Int {
        var sum : Int = 0
        for person in members {
            if let job = person._job {
                sum = sum + Int(job.calculateIncome(2000))
                
            }
            
        }
        return sum
    }
}
