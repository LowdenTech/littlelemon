//
//  Onboarding.swift
//  littlelemon
//
//  Created by Mike on 2025-08-24.
//

import SwiftUI

let firstNameKey: String = "firstName"
let lastNameKey: String = "lastName"
let emailKey: String = "email"
let isLoggedInKey: String = "isLoggedIn"

struct Onboarding: View {
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: Home(), isActive: $isLoggedIn) {
                    EmptyView()
                }
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
                TextField("Email", text: $email)
                Button("Register") {
                    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty) {
                        return
                    }
                    isLoggedIn = true
                    UserDefaults.standard.set(firstName, forKey: firstNameKey)
                    UserDefaults.standard.set(lastName, forKey: lastNameKey)
                    UserDefaults.standard.set(email, forKey: emailKey)
                    UserDefaults.standard.set(isLoggedIn, forKey: isLoggedInKey)
                }
            }
            .onAppear {
                isLoggedIn = UserDefaults.standard.bool(forKey: isLoggedInKey)
            }
        }
    }
}

#Preview {
    Onboarding()
}
