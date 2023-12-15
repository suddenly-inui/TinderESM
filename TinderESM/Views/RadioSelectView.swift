//
//  RadioSelectView.swift
//  TinderESM
//
//  Created by Yuki Inui on 2023/11/11.
//

import SwiftUI

struct RadioSelectView: View {
    @Binding var esm: Esm
    @Binding var selectOptions: [String]
    @Binding var selectedIndex: Int
    
    var body: some View {
        HStack{
            Text(esm.max_label)
            ForEach(0..<selectOptions.count, id: \.self, content: { index in
                VStack {
                    Text(selectOptions[index])
                    Image(systemName: selectedIndex == index ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(.blue)
                }
                .frame(height: 40)
                .onTapGesture {
                    selectedIndex = index
                }
            })
            Text(esm.min_label)
        }
    }
}


