import SwiftUI

struct CardView: View {
    @State private var offset: CGSize = .zero
    @State private var isSwiping = false
    
    @Binding var esm: Esm
    @Binding var esmState: Bool
    let isLast: Bool
    
    let apiService = APIService()
    let defaults = UserDefaults.standard
    
    var body: some View {
        Text("\(esm.title)")
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offset = gesture.translation
                    }
                    .onEnded { gesture in
                        withAnimation(.linear(duration: 0.2)) {
                            print(gesture.translation.width)
                            print(gesture.translation.height)
                            if gesture.translation.width > 100 && gesture.translation.height > 100 {
                                offset.width = 500
                                offset.height = 500
                                send_label(userId: "999", esmId: esm.esm_id, label: "rd")
                                whenLastCard(isLast: isLast)
                            } else if gesture.translation.width < -100 && gesture.translation.height > 100 {
                                offset.width = -500
                                offset.height = 500
                                send_label(userId: "999", esmId: esm.esm_id, label: "ld")
                                whenLastCard(isLast: isLast)
                            } else if gesture.translation.width > 100 {
                                offset.width = 500 // 右にスワイプ
                                send_label(userId: "999", esmId: esm.esm_id, label: "r")
                                whenLastCard(isLast: isLast)
                            } else if gesture.translation.width < -100 {
                                offset.width = -500 // 左にスワイプ
                                send_label(userId: "999", esmId: esm.esm_id, label: "l")
                                whenLastCard(isLast: isLast)
                            }else if gesture.translation.height > 100 {
                                offset.height = 500
                                send_label(userId: "999", esmId: esm.esm_id, label: "d")
                                whenLastCard(isLast: isLast)
                            } else {
                                offset = .zero // もとに戻す
                            }
                        }
                    }
            )
    }
    
    func send_label(userId: String, esmId: Int, label: String){
        apiService.sendLabel(userId: userId, esmId: esmId, label: label) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print("APIエラー: \(error)")
            }
        }
    }
    
    func whenLastCard(isLast: Bool){
        if isLast{
            esmState = false
            defaults.set(false, forKey: "esmState")
            print("last")
        }
    }
}
