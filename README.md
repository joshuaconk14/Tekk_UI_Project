# TekkAI Soccer App Frontend

TekkAI is an intelligent soccer coaching application that leverages the power of the Llama3 model to provide personalized tutorials and advice to soccer enthusiasts. The frontend of this application is built using SwiftUI, providing a seamless and interactive user experience for engaging with the TekkAI chatbot.

## Features

- **Interactive Chat Interface:** A user-friendly chat interface that allows users to interact with the TekkAI bot in real-time.
- **Real-Time Soccer Coaching:** The frontend sends user queries to the FastAPI backend and displays personalized responses from the Llama3 model.
- **Responsive Design:** The app is designed to run smoothly on iOS devices, offering a consistent experience across different screen sizes.

## Getting Started

### Prerequisites

- **Xcode**: Ensure that you have Xcode installed on your macOS machine.
- **iOS Device or Simulator**: You can run the app on an iOS device or use the Xcode simulator.

### Installation

1. **Clone the Frontend Repository:**
    ```bash
    git clone https://github.com/jordanconklin/Tekk_frontend.git
    cd Tekk_frontend
    ```

2. **Open the Project in Xcode:**
    - Double-click on the `Tekk-frontend.xcodeproj` file to open the project in Xcode.

3. **Connect to the Backend:**
    - Ensure that the FastAPI backend is running locally. Follow the backend setup guide [here](https://github.com/jordanconklin/Tekk-app.git).

4. **Set Up the API URL:**
    - In the `ContentView.swift` file, update the `URL(string: "http://127.0.0.1:8000/generate_tutorial/")` to match the URL where your FastAPI backend is running (leave alone if running FastAPI locally).

### Running the App

1. **Build and Run the Project:**
    - Select your target device or simulator in Xcode.
    - Click the "Run" button (or press `Cmd + R`) to build and run the app.

2. **Interact with TekkAI:**
    - Use the chat interface to ask soccer-related questions, and receive real-time advice from the Llama3 model.