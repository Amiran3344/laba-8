import Foundation

// Лабораторная работа №8

//  A. Transport 
class Transport {
    let name: String
    init(name: String) { self.name = name }
    func describe() -> String { return "Транспорт: \(name)" }
    func move() -> String { return "\(name) движется" }
}

class Car: Transport {
    let horsepower: Int
    init(name: String, horsepower: Int) {
        self.horsepower = horsepower
        super.init(name: name)
    }
    override func describe() -> String { return "Автомобиль: \(name), \(horsepower) л.с." }
    override func move() -> String { return "\(name) едет со скоростью до \(horsepower / 2) км/ч" }
}

class ElectricCar: Car {
    var batteryLevel: Int
    init(name: String, horsepower: Int, batteryLevel: Int) {
        self.batteryLevel = batteryLevel
        super.init(name: name, horsepower: horsepower)
    }
    override func describe() -> String {
        return "\(super.describe()), батарея: \(batteryLevel)%"
    }
    override func move() -> String {
        return batteryLevel > 0 ? "\(name) едет бесшумно" : "\(name) не может ехать: батарея разряжена"
    }
}

let t = Transport(name: "Повозка")
let c = Car(name: "Toyota Camry", horsepower: 200)
let e = ElectricCar(name: "Tesla Model 3", horsepower: 283, batteryLevel: 85)

let vehicles: [Transport] = [t, c, e]
for v in vehicles {
    print(v.describe())
    print(v.move())
}

//  B. BankAccount 
class BankAccount {
    let owner: String
    var balance: Double

    init(owner: String, balance: Double) { self.owner = owner; self.balance = balance }
    convenience init(owner: String) { self.init(owner: owner, balance: 0) }

    func deposit(_ amount: Double) {
        guard amount > 0 else { return }
        balance += amount
    }
    func withdraw(_ amount: Double) -> Bool {
        guard amount > 0, balance >= amount else { return false }
        balance -= amount
        return true
    }
    func transfer(to other: BankAccount, amount: Double) -> Bool {
        guard withdraw(amount) else { return false }
        other.deposit(amount)
        return true
    }
}

class SavingsAccount: BankAccount {
    let interestRate: Double
    init(owner: String, balance: Double, interestRate: Double) {
        self.interestRate = interestRate
        super.init(owner: owner, balance: balance)
    }
    func addInterest() { balance += balance * interestRate }
}

let acc = BankAccount(owner: "Алиса")
acc.deposit(10000)
print(acc.balance)

let savings = SavingsAccount(owner: "Борис", balance: 50000, interestRate: 0.05)
savings.addInterest()
print(savings.balance)

let checking = BankAccount(owner: "Иван", balance: 3000)
let saving = SavingsAccount(owner: "Иван", balance: 10000, interestRate: 0.03)
print(checking.transfer(to: saving, amount: 1500))
print(checking.balance)
print(saving.balance)

// C. Shape
class Shape {
    func area() -> Double { return 0 }
}
class Circle: Shape {
    let radius: Double
    init(radius: Double) { self.radius = radius }
    override func area() -> Double { return Double.pi * radius * radius }
}
class RectangleShape: Shape {
    let width: Double, height: Double
    init(width: Double, height: Double) { self.width = width; self.height = height }
    override func area() -> Double { return width * height }
}
class Triangle: Shape {
    let base: Double, height: Double
    init(base: Double, height: Double) { self.base = base; self.height = height }
    override func area() -> Double { return 0.5 * base * height }
}

let shapes: [Shape] = [
    Circle(radius: 5), RectangleShape(width: 4, height: 6),
    Triangle(base: 3, height: 8), Circle(radius: 3),
    RectangleShape(width: 10, height: 2)
]

let circles = shapes.filter { $0 is Circle }.count
let rects = shapes.filter { $0 is RectangleShape }.count
let triangles = shapes.filter { $0 is Triangle }.count
print("Кругов: \(circles), Прямоугольников: \(rects), Треугольников: \(triangles)")

let totalCircleArea = shapes.compactMap { $0 as? Circle }.map { $0.area() }.reduce(0, +)
let totalAreaFormatted = String(format: "%.2f", totalCircleArea)
print("Суммарная площадь кругов: \(totalAreaFormatted)")

func describeShape(_ shape: Shape) -> String {
    switch shape {
    case let c as Circle:
        let a = String(format: "%.2f", c.area())
        return "Круг с радиусом \(c.radius), площадь: \(a)"
    case let r as RectangleShape:
        return "Прямоугольник \(r.width)×\(r.height), площадь: \(r.area())"
    case let t as Triangle:
        return "Треугольник \(t.base)×\(t.height), площадь: \(t.area())"
    default:
        return "Неизвестная фигура"
    }
}
print(describeShape(Circle(radius: 5)))
print(describeShape(RectangleShape(width: 4, height: 6)))

// D. Logger 
class Logger {
    let label: String
    init(label: String) { self.label = label; print("[\(label)] Логгер создан") }
    deinit { print("[\(label)] Логгер уничтожен") }
    func log(_ message: String) { print("[\(label)] \(message)") }
}

do {
    let logger = Logger(label: "App")
    logger.log("Приложение запущено")
    logger.log("Обработка данных")
}

class Resource {
    let name: String
    init(name: String) { self.name = name }
    deinit { print("[\(name)] Ресурс освобождён") }
}
var resources: [Resource?] = [
    Resource(name: "БД"), Resource(name: "Файл"), Resource(name: "Сеть")
]
resources[1] = nil
resources[0] = nil
resources[2] = nil

// E. Notifications 
class Notification {
    let msg: String
    init(msg: String) { self.msg = msg }
    func send() { print("Уведомление: \(msg)") }
}
class EmailNotification: Notification {
    let email: String
    init(msg: String, email: String) { self.email = email; super.init(msg: msg) }
    override func send() { print("Email на \(email): \(msg)") }
}
class SMSNotification: Notification {
    let phone: String
    init(msg: String, phone: String) { self.phone = phone; super.init(msg: msg) }
    override func send() { print("SMS на \(phone): \(msg)") }
}
let notifications: [Notification] = [
    Notification(msg: "Привет"),
    EmailNotification(msg: "Отчёт готов", email: "user@mail.ru"),
    SMSNotification(msg: "Код: 1234", phone: "+79001234567")
]
for n in notifications { n.send() }

// F. Сотрудники 
class Employee {
    let name: String
    let id: Int
    var salary: Double
    init(name: String, id: Int, salary: Double) {
        self.name = name; self.id = id; self.salary = salary
    }
    func describe() -> String { return "Сотрудник: \(name), зарплата: \(salary)" }
    func bonus() -> Double { return 0 }
}

class Manager: Employee {
    let department: String
    init(name: String, id: Int, salary: Double, department: String) {
        self.department = department
        super.init(name: name, id: id, salary: salary)
    }
    override func bonus() -> Double { return salary * 0.2 }
    override func describe() -> String {
        return "Менеджер: \(name), отдел: \(department), зарплата: \(salary)"
    }
}

class Developer: Employee {
    let language: String
    let level: String
    init(name: String, id: Int, salary: Double, language: String, level: String) {
        self.language = language; self.level = level
        super.init(name: name, id: id, salary: salary)
    }
    override func bonus() -> Double {
        switch level {
        case "junior": return salary * 0.05
        case "middle": return salary * 0.10
        case "senior": return salary * 0.15
        default: return 0
        }
    }
    override func describe() -> String {
        return "Разработчик: \(name), \(language) (\(level)), зарплата: \(salary)"
    }
}

final class Intern: Employee {
    let mentor: Employee?
    init(name: String, id: Int, salary: Double, mentor: Employee?) {
        self.mentor = mentor
        super.init(name: name, id: id, salary: salary)
    }
    override func describe() -> String { return "Стажёр: \(name), зарплата: \(salary)" }
}

let team: [Employee] = [
    Manager(name: "Алиса", id: 1, salary: 150000, department: "iOS"),
    Developer(name: "Борис", id: 2, salary: 120000, language: "Swift", level: "senior"),
    Developer(name: "Виктор", id: 3, salary: 90000, language: "Python", level: "middle"),
    Intern(name: "Дарья", id: 4, salary: 40000, mentor: nil),
    Manager(name: "Евгений", id: 5, salary: 160000, department: "Backend")
]
for m in team { print(m.describe()) }

let devCount = team.filter { $0 is Developer }.count
print("Разработчиков: \(devCount)")

let totalBonus = team.map { $0.bonus() }.reduce(0, +)
print("Общий фонд бонусов: \(totalBonus)")

let languages = team.compactMap { ($0 as? Developer)?.language }
print("Языки: \(languages)")