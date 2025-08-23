@Model
final class RecipeIngredient {
    @Attribute(.unique) var id: UUID
    var quantity: Double
    var notes: String?
    
    // 관계
    var recipe: Recipe?
    var ingredient: Ingredient?
    
    init(
        id: UUID = UUID(),
        quantity: Double,
        notes: String? = nil
    ) {
        self.id = id
        self.quantity = quantity
        self.notes = notes
    }
    
    // 계산된 속성: 이 재료의 총 비용
    var totalCost: Double {
        guard let ingredient = ingredient else { return 0 }
        return quantity * ingredient.pricePerUnit
    }
}