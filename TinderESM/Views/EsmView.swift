//
//  EsmView.swift
//  TinderESM
//
//  Created by Yuki Inui on 2023/11/11.
//

import SwiftUI

struct EsmView: View {
    let apiService = APIService()
    let defaults = UserDefaults.standard
    
    
    @State var esm: [Esm] = []
    @Binding var esmState: Bool
    
    
    @State var ans: [String] = [""]
    @State var qidx = 0
    
    @State var selectedIndex = 0
    @State var selectOptions = ["1", "2", "3", "4", "5", "6", "7"]
    
    var body: some View {
        VStack{
            if esmState {
                if esm.count > 1 {
                    Text("Q\(esm[qidx].esm_id)")
                    Text(esm[qidx].content)
                }
                
                RadioSelectView(selectOptions: $selectOptions, selectedIndex: $selectedIndex)
                
                HStack{
                    if qidx != 0{
                        Button(action: {
                            qidx = qidx - 1
                            selectedIndex = 0
                        }) {
                            Text("back")
                        }
                        .padding()
                    }
                    
                    if qidx != esm.count - 1{
                        Button(action: {
                            ans[qidx] = selectOptions[selectedIndex]
                            print(ans)
                            qidx = qidx + 1
                            selectedIndex = 0
                        }) {
                            Text("next")
                        }
                        .padding()
                    } else {
                        Button(action: {
                            ans[qidx] = selectOptions[selectedIndex]
                            print(ans)
                            if !ans.contains(""){
                                print("submit")
                                send_label(userId: defaults.string(forKey: "userId")!, esmId: 1, labels: ans)
                                esmState = false
                                defaults.set(false, forKey: "esmState")
                            }else{
                                qidx = 0
                                ans =  Array(repeating: "", count: esm.count)
                            }
                        }) {
                            Text("submit")
                        }
                        .padding()
                    }
                }
            } else {
                Text("esmはありません")
            }
        }
        .onAppear{
            if esmState{
                fetchEsm()
            }
        }
        .onChange(of: esmState){
            if esmState{
                fetchEsm()
            }
        }
    }
    
    func fetchEsm(){
        apiService.fetchEsm { result in
            switch result {
            case .success(let data):
                print(data)
                esm = data
                ans = Array(repeating: "", count: esm.count)
            case .failure(let error):
                print("APIエラー: \(error)")
            }
        }
    }
    
    func send_label(userId: String, esmId: Int, labels: [String]){
        apiService.sendLabel(userId: userId, esmId: esmId, labels: labels) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print("APIエラー: \(error)")
            }
        }
    }
}
