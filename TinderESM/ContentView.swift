import SwiftUI

struct ContentView: View {
    @State private var serverEsmState: Bool = false
    @State private var esmState: Bool = false
    @State private var esmShownFlag: Bool = false
    @State private var selectedTab: Int = 2
    
    let apiService = APIService()
    let defaults = UserDefaults.standard
    let notificationService = NotificationService()
    
    @Environment(\.scenePhase) private var scenePhase
    var body: some View {
        ZStack{
            NavigationView {
                TabView(selection: $selectedTab) {
                    // ここに各タブのコンテンツを追加します
                    VStack{
                        Text("serverEsmState: \(String(serverEsmState))")
                        Text("esmState: \(String(esmState))")
                    }
                        .tabItem {
                            Image(systemName: "1.square.fill")
                            Text("タブ1")
                        }
                        .tag(1)
                    
                    CardStackView(esmState: $esmState, selectedTab: $selectedTab)
                        .tabItem {
                            Image(systemName: "2.square.fill")
                            Text("タブ2")
                        }
                        .tag(2)
                    
                    Text("ゲーミフィケーションの何か")
                        .tabItem {
                            Image(systemName: "3.square.fill")
                            Text("タブ3")
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
