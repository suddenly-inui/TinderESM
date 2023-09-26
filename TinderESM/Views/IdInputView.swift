import SwiftUI
import Combine

struct IdInputView: View {
    @State private var _id: String = ""
    @State private var _username: String = ""
    @Binding var id_username_set: Bool
    
    let defaults = UserDefaults.standard
    let apiService = APIService()
    
    var body: some View {
        VStack {
            Text("情報を入力してね")
            HStack{
                Text("ID: ")
                Spacer()
                TextField("ID", text: $_id)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 200, alignment: .trailing)
                    .onReceive(Just(_id)) { _ in
                            let textLimit = 3
                            if _id.count > textLimit {
                                _id = String(_id.prefix(textLimit))
                            }
                        }
            }
            .padding()
            
            HStack{
                Text("UserName: ")
                Spacer()
                TextField("username", text: $_username)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.default)
                    .frame(width: 200, alignment: .trailing)
                    .onReceive(Just(_username)) { _ in
                            let textLimit = 20
                            if _username.count > textLimit {
                                _username = String(_username.prefix(textLimit))
                            }
                        }

            }
            .padding()
            
            Button(action: {
                if _id != "" && _username != ""{
                    apiService.sendUser(userId: _id, userName: _username){result in
                        switch result {
                        case .success(let data):
                            defaults.set(_id, forKey: "userId")
                            defaults.set(_username, forKey: "username")
                            id_username_set = true
                            print("ユーザー情報を送信：id: \(data.user_id), username: \(data.user_id), success: \(data.success)")
                        case .failure(let error):
                            print("APIエラー: \(error)")
                        }
                    }
                }
            }){
                Text("送信")
            }
        }
    }
    

}
