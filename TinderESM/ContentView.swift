import SwiftUI

struct ContentView: View {
    @State private var serverEsmState: Bool = false
    @State private var esmState: Bool = false
    @State private var esmShownFlag: Bool = false
    @State private var selectedTab: Int = 2
    @State private var id_username_set = false
    
    let apiService = APIService()
    let defaults = UserDefaults.standard
    let notificationService = NotificationService()
    
    @Environment(\.scenePhase) private var scenePhase
    var body: some View {
        if !id_username_set && (defaults.string(forKey: "userId") == "" || defaults.string(forKey: "username") == "") {
            IdInputView(id_username_set: $id_username_set)
        }else{
            ZStack{
                NavigationView {
                    TabView(selection: $selectedTab) {
                        // ここに各タブのコンテンツを追加します
                        ProfileView()
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                        .tag(1)
                        
                        CardStackView(esmState: $esmState, selectedTab: $selectedTab)
                            .tabItem {
                                Image(systemName: "lanyardcard.fill")
                                Text("ESM")
                            }
                            .tag(2)
                        
                        Text("ゲーミフィケーションの何か")
                            .tabItem {
                                Image(systemName: "dollarsign")
                                Text("Progress")
                            }
                            .tag(3)
                    }
                    .navigationBarTitle("Tinder ESM")
                    .navigationBarItems(
                        trailing:
                            Button(action: {
                                fetchEsmState()
                            }) {
                                Image(systemName: "arrow.triangle.2.circlepath")
                            }
                    )
                }
            }
            
            
            .onAppear{
                print("\nApp")
                notificationService.requestNotificationPermission()
                
                if defaults.object(forKey: "init") == nil {
                    defaults.set(false, forKey: "esmState")
                    defaults.set("", forKey: "userId")
                    defaults.set("", forKey: "username")
                    defaults.set(false, forKey: "esmShownFlag")
                    defaults.set(true, forKey: "init")
                }
            }
            .onChange(of: scenePhase) {
                if scenePhase == .active {
                    fetchEsmState()
                }
            }
            .onChange(of: selectedTab) {
                fetchEsmState()
            }
        }
    }
    
    func fetchEsmState(){
        apiService.fetchEsmState { result in
            switch result {
            case .success(let data):
                print(data)
                serverEsmState = data.active
                if serverEsmState {
                    if !defaults.bool(forKey: "esmShownFlag") {
                        esmState = true
                        esmShownFlag = true
                        defaults.set(true, forKey: "esmState")
                        defaults.set(true, forKey: "esmShownFlag")
                    } else {
                        esmState = defaults.bool(forKey: "esmState")
                    }
                } else {
                    esmState = false
                    esmShownFlag = false
                    defaults.set(false, forKey: "esmState")
                    defaults.set(false, forKey: "esmShownFlag")
                }
            case .failure(let error):
                print("APIエラー: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}
