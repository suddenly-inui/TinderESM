//
//  ProfileView.swift
//  TinderESM
//
//  Created by Yuki Inui on 2023/09/27.
//

import SwiftUI

struct ProfileView: View {
    let defaults = UserDefaults.standard
    
    @State var totalReward = 0
    var body: some View {
        VStack{
            Text("\(defaults.string(forKey: "userId")!)")
            Text("\(defaults.string(forKey: "username")!)")
            Text("\(defaults.string(forKey: "deviceId")!)")
            Text("Started at \(defaults.string(forKey: "startedDate")!)")
            Text("Ends at \(defaults.string(forKey: "endDate")!)")
            Text("Your Reward: \(totalReward)")
        }
        .onAppear{
            totalReward = defaults.integer(forKey: "totalReward")
            print("reward updated")
        }
    }
}

