//
//  Home.swift
//  littlelemon
//
//  Created by Mike on 2025-08-24.
//

import SwiftUI

struct Home: View {
    
    let persistence = PersistenceController.shared
    
    var body: some View {
        TabView {
            Menu()
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }
            UserProfile()
                .tabItem {
                    Label("Profile", systemImage: "square.and.pencil")
                }
        }
        .navigationBarBackButtonHidden(true)
        .environment(\.managedObjectContext, persistence.container.viewContext)
    }
}

#Preview {
    Home()
}
