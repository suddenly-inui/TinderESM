//
//  ProfileView.swift
//  TinderESM
//
//  Created by Yuki Inui on 2023/09/27.
//

import SwiftUI

struct ProfileView: View {
    let defaults = UserDefaults.standard
    @State var a = ""
    var body: some View {
        VStack{
            Text("\(defaults.string(forKey: "userId")!)")
            Text("\(defaults.string(forKey: "username")!)")
        }
    }
}

#Preview {
    ProfileView()
}
