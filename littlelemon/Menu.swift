//
//  Menu.swift
//  littlelemon
//
//  Created by Mike on 2025-08-24.
//

import SwiftUI

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var searchText: String = ""
    
    var body: some View {
        VStack {
            Text("Little Lemon")
            Text("Ontario")
            Text("Little Lemon App created for Meta iOS Development Course")
            TextField("Search Menu", text: $searchText)
            FetchedObjects(
                predicate: buildPredicate(),
                sortDescriptors: buildSortDescriptors()
            ) { (dishes: [Dish]) in
                List {
                    ForEach(dishes) { dish in
                        HStack {
                            Text(dish.title! + " " + dish.price!)
                            AsyncImage(url: URL(string: dish.image!)!)
                        }
                    }
                }
            }
        }
        .onAppear {
            getMenuData()
        }
    }
    
    func getMenuData() {
        PersistenceController.shared.clear()
        let serverUrl: String = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        let url: URL = URL(string: serverUrl)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let menu = try! JSONDecoder().decode(MenuList.self, from: data)
                for item in menu.menu {
                    let dish = Dish(context: viewContext)
                    dish.desc = item.description
                    dish.category = item.category
                    dish.id = Int16(item.id)
                    dish.image = item.image
                    dish.price = item.price
                }
                try? viewContext.save()
            }
        }
        task.resume()
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [
            NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare))
        ]
    }
    
    func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            return NSPredicate(value: true)
        }
        return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
    }
}

#Preview {
    Menu()
}
