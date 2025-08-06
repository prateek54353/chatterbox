# Chatterbox

A general-purpose AI assistant built with Flutter, providing diverse AI-powered chat functionalities.

## Table of Contents

-   [About / Overview](#about--overview)
-   [Features](#features)
-   [Installation & Setup](#installation--setup)
-   [Usage](#usage)
-   [Project Structure](#project-structure)
-   [Development](#development)
-   [API Integration](#api-integration)
-   [License](#license)

## About / Overview

Chatterbox is an early-stage, cross-platform mobile application developed using Flutter. It aims to be a versatile AI assistant, offering various AI-powered chat experiences. The application is designed with a modular architecture, separating UI (screens, widgets), data models, and AI service integrations.

### Technologies Used

-   **Flutter:** UI Toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
-   **Dart:** Programming language for Flutter.
-   **http:** For making HTTP requests to external APIs.
-   **flutter_markdown:** For rendering Markdown in chat responses.
-   **url_launcher:** For launching URLs.
-   **shared_preferences:** For persisting simple data key-value pairs.
-   **uuid:** For generating unique IDs.
-   **flutter_launcher_icons:** For generating launcher icons for different platforms.

## Features

Chatterbox currently offers the following AI-powered chat functionalities:

-   **AI Translator:** Translate text accurately and naturally between languages.
-   **AI Code Tutor:** Get clear, concise, and helpful code explanations and solutions.
-   **AI Image Generator:** Generate images based on textual prompts.
-   **AI Text Writer:** Generate creative text formats, like poems, code, scripts, musical pieces, email, letters, etc.

## Installation & Setup

### Prerequisites

-   Flutter SDK installed (version 3.8.1 or higher).
-   Android Studio with Flutter plugin for Android development.
-   A modern web browser for web development.

### Steps

1.  **Clone the Repository:**

    ```bash
    git clone https://github.com/your-username/chatterbox.git
    cd chatterbox
    ```

2.  **Get Dependencies:**

    ```bash
    flutter pub get
    ```

3.  **Run on Web:**

    ```bash
    flutter run -d chrome
    ```

4.  **Run on Android:**

    Ensure you have an Android device connected or an emulator running.

    ```bash
    flutter run
    ```

## Usage

Interact with the AI by selecting the desired chat functionality from the home screen. Type your prompts or questions, and the AI will respond accordingly.

## Project Structure

The project follows a standard Flutter application structure:

-   `lib/main.dart`: The main entry point of the application, handling initial setup, routing, and theme.
-   `lib/models/`: Contains data models like `chat_session.dart`, `ai_model.dart`, and `message.dart`.
-   `lib/screens/`: Houses the different UI pages of the application, including various AI chat screens and utility screens (e.g., settings, about).
-   `lib/services/`: Contains the business logic and AI integration services (e.g., `ai_translator_service.dart`, `ai_code_tutor_service.dart`).
-   `lib/widgets/`: Reusable UI components used across the application (e.g., `chat_bubble.dart`, `typing_indicator.dart`).
-   `assets/`: Stores application assets, such as `chatterbox_logo.png`.
-   `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/`: Platform-specific configurations and build files.

## Development

### Running Tests

If there are tests available, you can run them using:

```bash
flutter test
```

### Contribution Guidelines

Contributions are welcome via pull requests. Please ensure your code adheres to the project's coding style and includes appropriate tests.

## API Integration

Chatterbox utilizes the following public, no-key-required endpoints from Pollinations.ai for its AI functionalities:

-   **Text API (for Translator, Code Tutor, Text Writer):** `https://text.pollinations.ai/openai`
-   **Image API (for Image Generator):** `https://image.pollinations.ai/prompt/{prompt}`

No API key setup is required to run the application.

## License

This project is open-source. Please refer to the `LICENSE` file for more details.

