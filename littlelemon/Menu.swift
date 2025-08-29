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
                .font(.title)
            Text("Ontario")
                .foregroundStyle(.gray)
            Text("Little Lemon Restaurant App")
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
            TextField("Search Menu", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .padding()
            FetchedObjects(
                predicate: buildPredicate(),
                sortDescriptors: buildSortDescriptors()
            ) { (dishes: [Dish]) in
                List {
                    ForEach(dishes, id: \.title) { dish in
                        HStack {
                            Text(dish.title! + " - $" + dish.price!)
                            Spacer()
                            AsyncImage(url: URL(string: dish.image!)) { image in
                                if let image = image.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 150)
                                }
                            }
                        }
                    }
                }
            }
        }
        .task {
            await getMenuData()
        }
    }
    
    func getMenuData() async {
        PersistenceController.shared.clear()
        let serverUrl: String = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        let url: URL = URL(string: serverUrl)!
        let request = URLRequest(url: url)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let menu = try JSONDecoder().decode(MenuList.self, from: data)
            for item in menu.menu {
                addDish(item: item)
            }
        } catch {}
    }
    
    func addDish(item: MenuItem) {
        let dish = Dish(context: viewContext)
        dish.title = item.title
        dish.image = item.image
        dish.price = item.price
        try? viewContext.save()
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
