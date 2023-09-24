import SwiftUI

struct CardStackView: View {
    @ObservedObject var cardViewModel = CardViewModel()
    
    @State var esm: [Esm] = []
    
    @Binding var esmState: Bool
    @Binding var selectedTab: Int
    
    let apiService = APIService()
    
    var body: some View {
        ZStack {
            if esmState {
                ForEach(esm.indices, id: \.self) { index in
                    if index == esm.indices.last{
                        CardView(esm: $esm[index], esmState: $esmState, isLast: true )
                            .zIndex(Double(-index))
                    } else {
                        CardView(esm: $esm[index], esmState: $esmState, isLast: false )
                            .zIndex(Double(-index))
                    }
                }
            } else {
                Text("no esm.")
            }
        }
        .onAppear{
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
            case .failure(let error):
                print("APIエラー: \(error)")
            }
        }
    }
    
    
}
