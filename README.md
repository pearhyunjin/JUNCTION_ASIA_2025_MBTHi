# Scan & Stock

Hello, We are Team MBTHi.

This is a project that participated in the Solar Pro2 – LLM Technology Track by Upstage at Junction Asia 2025.

</br>

<img width="1920" height="1080" alt="image1" src="https://github.com/user-attachments/assets/57dbe690-7942-4f7e-95e1-abf96759725e" />

</br>
</br>

# The Problem We Aimed to Solve

The owner of a small dessert café ends each day by checking inventory. They manually confirm how much of each ingredient for drinks and desserts is left, jot down items that need to be reordered, or immediately add them to an online shopping cart via their phone. In this repetitive inventory check and ordering process, orders are sometimes missed.
For small businesses that are not large enough to introduce a dedicated inventory management system, performing daily inventory checks creates inefficiency in store operations. We therefore asked ourselves: how might small business owners manage inventory more easily without incurring additional costs?

</br>

# **Lighter Closings, Every Day**

POS systems commonly used by small business owners provide a daily sales slip at closing, which contains data on the items sold, quantities, and total sales. We came up with a solution where scanning this sales slip automatically reflects the corresponding decrease in inventory. With this, owners no longer need to open refrigerators or drawers one by one to count stock. They can quickly identify which ingredients are running low.

The changes this project brings are not dramatic. But by reducing the “small but daily burdens,” café owners can wrap up their day more lightly. It also lowers the chance of missing an order and scrambling the next morning.

</br>

# **Future Plans for Application**

### Refining Inventory Depletion Logic

- Define ingredient units required per menu item so that not only coffee beans, but also milk, cups, and other supplies are automatically deducted upon sale,
- Provide data that more closely reflects the actual inventory situation,

### Integration with Ordering Support

- Add a notification feature when inventory reaches a threshold,
- Explore simple integration that connects directly to preferred suppliers for quick ordering,

### Accumulating Data and Providing Insights

- Analyze sales and inventory data on a daily and monthly basis to identify weekday/seasonal patterns,
- Help reduce over-purchasing and support preparation for popular menu items in advance,

The ultimate goal of all these plans is to enable café owners to focus more on creating delicious food and delivering great service.

</br>

---

</br>

## **🎆 Screenshots**

| <img width="250" alt="홈화면" src="https://github.com/user-attachments/assets/c4c26045-c75b-4e9d-87bb-d38dd6a83bc3" /> | <img width="250" alt="재고 파악 - 영수증 촬영" src="https://github.com/user-attachments/assets/a5a2ba6b-fe7c-48e5-8785-25fa4f5e7b17" /> | <img width="250" alt="재고 파악 - 인식된 내용 확인" src="https://github.com/user-attachments/assets/ecb7a90f-487f-470f-96a2-f2eb40ba7192" /> |
| --- | --- | --- |


</br>

## 🛠 Skills & Functions

### Structure

- **Layer Separation**
    - **Service Layer**: Service objects such as *UpstageChatService* and *UpstageOCRService* are separated to handle communication with external APIs, improving reusability and testability.
    - **Manager**: Common functionalities used across the app (e.g., networking, mock data management) are centrally managed by objects like *NetworkManager* and *MockDataManager*.
- **Data Modeling**: Within the *Models* folder, DTOs, Enums, and SwiftData models are clearly separated to systematically manage the roles of each data type.

### Features

- **AI-based In-store Sales History Analysis**
    - **OCR (Optical Character Recognition)**: By capturing a receipt image with the camera or selecting one from the photo library, the *UpstageOCRService* calls Upstage AI’s OCR API to extract text.
    - **LLM (Large Language Model)**: The extracted text is sent to the *Solar* model through *UpstageChatService*. Using natural language processing, the data is structured into JSON format containing menu names and quantities.
    - **Implementation**: The feature is implemented as a pipeline: *SalesScanView → SalesScanViewModel → UpstageOCRService & UpstageChatService*.
- **Real-time Camera and Photo Library Integration**
    - **Camera**: Implements real-time camera preview and photo capture using the AVFoundation framework.
    - **Photo Library**: Uses the *PhotosPicker* from the PhotosUI framework to securely fetch images from the user’s photo library.
- **Data Management and Visualization**
    - **Local Database**: Core app data such as inventory, recipes, and orders are stored and managed on-device using SwiftData.
    - **Data Visualization**: Insights such as low-stock items or weekly sales forecasts are visualized through custom components like *WeeklyBarChart* and *LowStockCard* to enhance user experience.

### Technology

- **Networking**
    - Implements *NetworkManager* based on URLSession to handle all HTTP communications.
    - Supports JSON requests, multipart/form-data requests for image uploads, and real-time streaming responses for AI chat using *AsyncThrowingStream*.
- **External Services**
    - **Upstage AI API**: Powers the core AI functionalities of the project.
    - **Document AI**: Extracts information from document images, including OCR and receipt data extraction.
    - **Solar**: Handles natural language understanding and generation, analyzing and structuring text extracted by OCR.

</br>

## **🫂 Authors**

| <img src="https://github.com/pearhyunjin.png" width="150" /> | <img src="https://github.com/delightPIP.png" width="150" /> | <img src="https://github.com/yunsly.png" width="150" /> | <img src="https://github.com/JM0307.png" width="150" /> |
| --- | --- | --- | --- |
| @[**pearhyunjin**](https://github.com/pearhyunjin) | [@delightPIP](https://github.com/delightPIP) | [@yunsly](https://github.com/yunsly) | [@**jm0307**](https://github.com/JM0307) |
