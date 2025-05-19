
# Smart Yoga Mat Mobile App

## Project Overview

The Smart Yoga Mat Mobile App is a cross-platform React Native application designed to connect with a smart yoga mat device. It offers real-time connectivity via Bluetooth or Wi-Fi, control over mat functions, relaxing sound options, product showcases, OTA firmware updates, and user analytics—all to elevate the yoga experience.

---

## Features

- Home Screen: Overview of the smart yoga mat with feature highlights and a clear “Connect to Mat” button.
- Device Connection: Connect/disconnect via Bluetooth or Wi-Fi; connection status displayed.
- Control Panel: Two functional modes (“Start Warm-Up” and “Begin Relaxation Mode”) with user feedback.
- Music & Sound: Play/pause relaxing sounds like ocean waves, ambient music, and breathing exercises.
- Product & Feature Showcase: Dynamic list of new products and features with images and info links.
- OTA Updates: Check current firmware version and update if a new version is available.
- Analytics Overview (Optional): Basic stats such as total yoga sessions and frequently used mat functions.

---

## Technology Stack

- React Native for cross-platform app development (iOS and Android).
- Firebase for backend services:
  - Authentication
  - Firestore database
  - Storage for media assets
  - Analytics (optional)
- Bluetooth & Wi-Fi APIs for device connectivity.

---

## Prerequisites

- Node.js (>=14.x)
- npm or yarn
- React Native CLI
- Android Studio or Xcode (for emulators/simulators)
- A Firebase account and project

---

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/smart-yoga-mat-app.git
cd smart-yoga-mat-app
```

### 2. Install Dependencies

```bash
npm install
# or
yarn install
```

### 3. Configure Firebase

- Create a Firebase project in the Firebase Console (https://console.firebase.google.com/).
- Enable Authentication (Email/Anonymous sign-in).
- Create a Firestore database in test mode.
- Setup Storage for media assets (optional).
- Download the configuration files:
  - For Android: google-services.json → Place it in android/app/
  - For iOS: GoogleService-Info.plist → Add it to the Xcode project.

### 4. Configure Firebase in React Native

Install Firebase dependencies:

```bash
npm install @react-native-firebase/app @react-native-firebase/auth @react-native-firebase/firestore @react-native-firebase/storage
```

For Bluetooth, install appropriate packages like:

```bash
npm install react-native-ble-plx
```

### 5. Run on Android

```bash
npx react-native run-android
```

### 6. Run on iOS

```bash
cd ios
pod install
cd ..
npx react-native run-ios
```

---

## Folder Structure

/android          # Android native code
/ios              # iOS native code
/src
  /components     # React Native components (Home, Control Panel, etc.)
  /screens        # App screens
  /services       # Firebase and device connectivity logic
  /assets         # Images, sounds, fonts
  /navigation     # React Navigation setup
/App.js           # App entry point

---

## Key Files

- App.js – Initializes Firebase and sets up navigation
- /services/firebase.js – Firebase config and helper functions
- /services/bluetooth.js – Bluetooth connection logic
- /screens/HomeScreen.js – Home screen UI and connection status
- /screens/ControlPanel.js – Control mat functions and play sounds
- /screens/ProductShowcase.js – Dynamic rendering of products/features
- /screens/OtaUpdate.js – Check and update firmware

---

## Challenges & Solutions

- Bluetooth & Wi-Fi Integration: Handled asynchronous device scanning and connection using react-native-ble-plx.
- OTA Updates: Simulated firmware updates via Firestore data and download URLs.
- Dynamic Product Showcases: Fetched product info/images dynamically from Firestore for easy updates.
- Smooth Navigation: Used React Navigation with stack and tab navigators for intuitive UX.

---

## Future Improvements

- Add user authentication and personalized settings.
- Implement real-time mat sensor data monitoring.
- Integrate with AWS IoT or similar for real OTA updates.
- Expand analytics with detailed session tracking.

---

## License

This project is licensed under the MIT License.
