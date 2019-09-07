//
//  main.swift
//  Organization
//
//  Created by 17 on 9/4/19.
//



class Employee: CustomStringConvertible {
    var description: String {
        let description = "\tname: \(name)\n\tgender: \(gender.rawValue)\n"
        
        return description
    }
    
    enum Gender: String {
        case woman
        case man
        case other
    }
    
    let name: String
    let gender: Gender
    weak var team: Team?
    
    init(name: String, gender: Gender) {
        self.name = name
        self.gender = gender
    }
    
    deinit {
        print("Employee \(self.name) was removed.")
    }
    
}

class Developer: Employee {
    enum Platform: String {
        case iOS
        case Android
        case Web
        case Windows
        case none
    }
    
    let platform: Platform
    
    init(name: String, gender: Gender, platform: Platform = .none) {
        self.platform = platform
        super.init(name: name, gender: gender)
    }
    
    func develop() {
        print("develop() was called")
    }
    
    override var description: String {
        var desc = super.description
        desc += "\tprofession: Developer\n\tplatform: \(platform.rawValue)\n"
        
        return desc
    }
}

class Designer: Employee {
    func design() {
        print("design() was called")
    }
}

class ProductManager: Employee {
    var project: String?
    
    init(name: String, gender: Employee.Gender, project: String? = nil) {
        self.project = project
        super.init(name: name, gender: gender)
    }
    
    func manage (project managedProject: String) {
        print("manage() was called. \(managedProject) is managed by \(self.name)")
    }
}

class Company {
    let name: String
    var employees: [Employee] = []
    var teams: [Team] = []
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, employees: [Employee]) {
        self.name = name
        self.employees = employees
    }
    
    func register(employee: Employee) {
        employees.append(employee)
    }
    
    func register(employees: [Employee]) {
        self.employees += employees
    }
    
    func createTeam(name: String, employees: [Employee] = []) -> Team {
        let team = Team(name: name, company: self, members: employees)
        teams.append(team)
        
        return team
    }
    
    deinit {
        print("The company \(self.name) was dissolved.")
    }
}

extension Company: CustomStringConvertible {
    var description: String {
        let companyDescription = "\(name)\nemployees: \(employees.count)\nTeams:\n"
        let teamsDescription = teams.map { $0.description }.joined(separator: "\n")
        let noTeamEmployeesDescription = "-----\nno team\n" + employees.filter { $0.team == nil }.map { $0.description }.joined(separator: "\n") + "-----\n"
        return companyDescription + teamsDescription + noTeamEmployeesDescription
    }
}

class Team {
    let name: String
    private var members: [Employee]
    unowned let company: Company
    
    init(name: String, company: Company, members: [Employee] = []) {
        self.name = name
        self.company = company
        self.members = members
    }
    
    func add(member: Employee) {
        members.append(member)
        member.team = self
        guard company.employees.first(where: { $0 === member }) == nil else {
            return
        }
        company.register(employee: member)
    }
    
    func add(members: [Employee]) {
        members.forEach { self.add(member: $0) }
    }
    
    func printMembers () {
        for i in 0..<members.count {
            print(members[i].description)
        }
    }
    
    deinit {
        print("Team \(self.name) was dissolved.")
    }
}

extension Team: CustomStringConvertible {
    var description: String {
        var desc = "--------\nteam: \(name)\n\n"
        desc += members.map { $0.description }.joined(separator: "\n")
        desc += "--------\n"
        return desc
    }
}





