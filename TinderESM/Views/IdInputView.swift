import SwiftUI
import Combine

struct IdInputView: View {
    @State private var _id: String = ""
    @State private var _username: String = ""
    @Binding var id_username_set: Bool
    @Binding var showModal: Bool

    @State var curveType = ""
    
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
                    apiService.sendUser(userId: _id, userName: _username, device_id: defaults.string(forKey: "deviceId")!){result in
                        switch result {
                        case .success(let data):
                            let japanTZ = TimeZone(identifier: "Asia/Tokyo")!
                            let startedDate = getCurrentDateWithTimeZone(timeZone: japanTZ)
                            let endDate = addDaysToDate(dateString: startedDate, timeZone: japanTZ, add: 21)
                            defaults.set(startedDate, forKey: "startedDate")
                            defaults.set(endDate!, forKey: "endDate")
                            defaults.set(_id, forKey: "userId")
                            defaults.set(_username, forKey: "username")
                            id_username_set = true
                            
                            let userId = defaults.string(forKey: "userId")!
                            if userId.starts(with: "0"){
                                curveType = "up"
                            }else if userId.starts(with: "1"){
                                curveType = "dn"
                            }else if userId.starts(with: "2"){
                                curveType = "mid"
                            }else if userId.starts(with: "3"){
                                curveType = "line"
                            }else {
                                curveType = "error"
                                showModal = true
                            }
                            
                            defaults.set(curveType, forKey: "curveType")
                            
                            print("ユーザー情報を送信：id: \(data.user_id), username: \(data.user_id), deviceId: \(data.device_id), success: \(data.success)")
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
    

    func getCurrentDateWithTimeZone(timeZone: TimeZone) -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: currentDate)
    }
    
    func addDaysToDate(dateString: String, timeZone: TimeZone, add: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let inputDate = dateFormatter.date(from: dateString) {
            // Add 10 days to the input date
            if let resultDate = Calendar.current.date(byAdding: .day, value: add, to: inputDate) {
                let finalDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: resultDate)
                return dateFormatter.string(from: finalDate!)
            }
        }
        
        return nil
    }
}
