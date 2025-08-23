@Model
final class Ingredient {
    @Attribute(.unique) var id: UUID
    var name: String
    var unit: IngredientUnit
    var currentStock: Double
    var minimumStock: Double
    var pricePerUnit: Double
    var lastUpdated: Date
    
    // 관계
    @Relationship(deleteRule: .cascade, inverse: \RecipeIngredient.ingredient)
    var recipeIngredients: [RecipeIngredient] = []
    
    init(
        id: UUID = UUID(),
        name: String,
        unit: IngredientUnit,
        currentStock: Double = 0,
        minimumStock: Double = 0,
        pricePerUnit: Double = 0,
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.unit = unit
        self.currentStock = currentStock
        self.minimumStock = minimumStock
        self.pricePerUnit = pricePerUnit
        self.lastUpdated = lastUpdated
    }
    
    // 재고 부족 여부 확인
    var isLowStock: Bool {
        return currentStock <= minimumStock
    }
}