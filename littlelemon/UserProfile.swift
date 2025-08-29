//
//  UserProfile.swift
//  littlelemon
//
//  Created by Mike on 2025-08-24.
//

import SwiftUI

struct UserProfile: View {
    @Environment(\.presentationMode) var presentation
    
    let firstName: String = UserDefaults.standard.string(forKey: firstNameKey)!
    let lastName: String = UserDefaults.standard.string(forKey: lastNameKey)!
    let email: String = UserDefaults.standard.string(forKey: emailKey)!
    
    var body: some View {
        VStack {
            Text("Personal Information")
            Image("profile-image-placeholder")
            Text(firstName)
            Text(lastName)
            Text(email)
            Button("Logout") {
                UserDefaults.standard.set(false, forKey: isLoggedInKey)
                self.presentation.wrappedValue.dismiss()
            }
            Spacer()
        }
    }
}

#Preview {
    UserProfile()
}
