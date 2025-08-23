@Model
final class Recipe {
    @Attribute(.unique) var id: UUID
    var name: String
    var category: RecipeCategory
    var servingSize: Int
    var instructions: String?
    var isActive: Bool
    var createdDate: Date
    var lastModified: Date
    
    // 관계
    @Relationship(deleteRule: .cascade, inverse: \RecipeIngredient.recipe)
    var ingredients: [RecipeIngredient] = []
    
    @Relationship(deleteRule: .cascade, inverse: \MenuOption.recipe)
    var menuOptions: [MenuOption] = []
    
    init(
        id: UUID = UUID(),
        name: String,
        category: RecipeCategory,
        servingSize: Int = 1,
        instructions: String? = nil,
        isActive: Bool = true,
        createdDate: Date = Date(),
        lastModified: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.servingSize = servingSize
        self.instructions = instructions
        self.isActive = isActive
        self.createdDate = createdDate
        self.lastModified = lastModified
    }
    
    // 계산된 속성들
    var totalCost: Double {
        return ingredients.reduce(0) { $0 + $1.totalCost }
    }
    
    var costPerServing: Double {
        guard servingSize > 0 else { return 0 }
        return totalCost / Double(servingSize)
    }
    
    // 레시피 제작 가능 여부 확인
    var canMake: Bool {
        return ingredients.allSatisfy { recipeIngredient in
            guard let ingredient = recipeIngredient.ingredient else { return false }
            return ingredient.currentStock >= recipeIngredient.quantity
        }
    }
    
    // 최대 제작 가능 수량
    var maxPossibleQuantity: Int {
        let minRatio = ingredients.compactMap { recipeIngredient -> Double? in
            guard let ingredient = recipeIngredient.ingredient,
                  recipeIngredient.quantity > 0 else { return nil }
            return ingredient.currentStock / recipeIngredient.quantity
        }.min() ?? 0
        
        return Int(minRatio)
    }
}