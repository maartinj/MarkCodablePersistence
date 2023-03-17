//
// Created for MarkCodable Persistence
// by  Stewart Lynch on 2022-12-22
// Using Swift 5.0
// Running on macOS 13.1
// 
// Folllow me on Mastodon: @StewartLynch@iosdev.space
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch

import Foundation

class DataStore: ObservableObject {
    @Published var parents: [Parent] = []
    @Published var entity: Entity?
    
    init() {
        loadFamilies()
    }

    func addChild(_ child: String, for parent: Parent) {
        if let index = parents.firstIndex(where: { $0.id == parent.id }) {
            parents[index].children.append(child)
            save()
        }
    }

    func addFamily(parent: Parent) {
        parents.append(parent)
        save()
    }

    func deleteFamily(parent: Parent) {
        if let index = parents.firstIndex(where: { $0.id == parent.id }) {
            parents.remove(at: index)
            save()
        }
    }

    func deleteChild(child: String, for parent: Parent) {
        if let index = parents.firstIndex(where: { $0.id == parent.id }) {
            if let childIndex = parents[index].children.firstIndex(where: { $0 == child}) {
                parents[index].children.remove(at: childIndex)
                save()
            }
        }
    }
    
    func save() {
        // JSON
        do {
            let jsonURL = URL.documentsDirectory.appending(path: "Family.json")
            let parentsData = try JSONEncoder().encode(parents)
            try parentsData.write(to: jsonURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadFamilies() {
        // JSON
        let jsonURL = URL.documentsDirectory.appending(path: "Family.json")
        if FileManager().fileExists(atPath: jsonURL.path) {
            do {
                let jsondata = try Data(contentsOf: jsonURL)
                parents = try JSONDecoder().decode([Parent].self, from: jsondata)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
