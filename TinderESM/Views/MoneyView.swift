//
//  MoneyView.swift
//  TinderESM
//
//  Created by Yuki Inui on 2023/12/11.
//

import SwiftUI

struct MoneyView: View {
    let defaults = UserDefaults.standard
    var body: some View {
        Text("\(defaults.integer(forKey: "totalReward"))円")
    }
}

#Preview {
    MoneyView()
}
