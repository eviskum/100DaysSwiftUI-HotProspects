//
//  Prospect.swift
//  HotProspects
//
//  Created by Esben Viskum on 21/05/2021.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    let id: UUID
    let timeStamp: Date
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
    
    init() {
        id = UUID()
        timeStamp = Date()
    }
}

class Prospects: ObservableObject {
    enum SortOrder {
        case byName, byDate
    }
    
    @Published private(set) var people: [Prospect]
    
    static let saveKey = "SavedData2"
    
    var sortOrder = SortOrder.byDate {
        didSet {
            print("change sort order")
            sort()
            save()
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                self.people = decoded
                return
            }
        }
        
        self.people = []
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        sort()
        save()
    }
    
    func sort() {
        if sortOrder == .byDate {
            print("sort by date")
            people.sort { lhs, rhs in
                lhs.timeStamp < rhs.timeStamp
            }
        } else if sortOrder == .byName {
            print("sort by name")
            people.sort { lhs, rhs in
                lhs.name < rhs.name
            }
        }
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}
