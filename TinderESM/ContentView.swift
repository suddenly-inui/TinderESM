import SwiftUI

struct ContentView: View {
    @State private var serverEsmState: Bool = false
    @State private var esmState: Bool = false
    @State private var esmShownFlag: Bool = false
    @State private var selectedTab: Int = 2
    @State private var id_username_set = false
    @State private var showModal = false
    
    let apiService = APIService()
    let defaults = UserDefaults.standard
    let notificationService = NotificationService()
    
    @Environment(\.scenePhase) private var scenePhase
    var body: some View {
        if !id_username_set && (defaults.string(forKey: "userId") == "" || defaults.string(forKey: "username") == "") {
            IdInputView(id_username_set: $id_username_set, showModal: $showModal)
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
                        
                        EsmView(esmState: $esmState)
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
                    .navigationBarTitle("ESM")
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
            .sheet(isPresented: $showModal) {
                        Text("ユーザーIDを確認後、アプリをダウンロードし直してください。")
                            .interactiveDismissDisabled()
                            .padding()
                    }
            .onAppear{
                print("\nApp")
                notificationService.requestNotificationPermission()
                
                if defaults.object(forKey: "init") == nil {
                    defaults.set(false, forKey: "esmState")
                    defaults.set("", forKey: "userId")
                    defaults.set("", forKey: "username")
                    defaults.set(false, forKey: "esmShownFlag")
                    defaults.set("", forKey: "curveType")
                    defaults.set(true, forKey: "init")
                }
            }
            .onChange(of: scenePhase) {
                if scenePhase == .active {
                    fetchEsmState()
                    if selectedTab == 2 {
                        deleteNotificationBadge()
                    }
                }
            }
            .onChange(of: selectedTab) {
                fetchEsmState()
                if selectedTab == 2 {
                    deleteNotificationBadge()
                }
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
    
    func deleteNotificationBadge(){
        UNUserNotificationCenter.current().setBadgeCount(0, withCompletionHandler: { error in
            if let error = error {
                // エラーハンドリングを行う
                print("バッジを削除しました：\(error.localizedDescription)")
            } else {
                // バッジの設定が成功した場合の処理を行う
                print("バッジを削除できませんでした")
            }
        })
    }
}
