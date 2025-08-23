@Model
final class Order {
    @Attribute(.unique) var id: UUID
    var orderNumber: String
    var customerName: String?
    var orderDate: Date
    var status: OrderStatus
    var totalAmount: Double
    var notes: String?
    
    // 관계
    @Relationship(deleteRule: .cascade, inverse: \OrderItem.order)
    var items: [OrderItem] = []
    
    init(
        id: UUID = UUID(),
        orderNumber: String,
        customerName: String? = nil,
        orderDate: Date = Date(),
        status: OrderStatus = .pending,
        totalAmount: Double = 0,
        notes: String? = nil
    ) {
        self.id = id
        self.orderNumber = orderNumber
        self.customerName = customerName
        self.orderDate = orderDate
        self.status = status
        self.totalAmount = totalAmount
        self.notes = notes
    }
}