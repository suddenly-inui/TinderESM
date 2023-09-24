import SwiftUI

class CardViewModel: ObservableObject {
    @Published var cards: [String] = ["Card 1", "Card 2", "Card 3"] // 仮のカードデータ
}
