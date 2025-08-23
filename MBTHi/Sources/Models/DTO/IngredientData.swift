// 데이터 생성 구조

struct IngredientData {
    let name: String
    let unit: IngredientUnit
    let currentStock: Double
    let minimumStock: Double
    let pricePerUnit: Double
}

struct RecipeData {
    let name: String
    let category: RecipeCategory
    let servingSize: Int
    let instructions: String?
    let ingredients: [RecipeIngredientData]
}

struct RecipeIngredientData {
    let ingredientName: String
    let quantity: Double
    let notes: String?
}

struct MenuOptionData {
    let recipeName: String
    let name: String
    let sellingPrice: Double
}

