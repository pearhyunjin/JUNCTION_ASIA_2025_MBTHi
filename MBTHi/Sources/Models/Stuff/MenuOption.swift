@Model
final class MenuOption {
    @Attribute(.unique) var id: UUID
    var name: String
    var sellingPrice: Double
    var isAvailable: Bool
    
    // 관계
    var recipe: Recipe?
    
    init(
        id: UUID = UUID(),
        name: String,
        sellingPrice: Double,
        isAvailable: Bool = true
    ) {
        self.id = id
        self.name = name
        self.sellingPrice = sellingPrice
        self.isAvailable = isAvailable
    }
    
    // 이 옵션의 실제 원가
    var actualCost: Double {
        guard let recipe = recipe else { return 0 }
        return recipe.costPerServing
    }
    
    // 수익률
    var profitMargin: Double {
        guard sellingPrice > 0 else { return 0 }
        return ((sellingPrice - actualCost) / sellingPrice) * 100
    }
}