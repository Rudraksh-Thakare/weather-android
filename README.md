<div align="center">

# 🌤️ Flutter Weather App

<img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
<img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white"/>
<img src="https://img.shields.io/badge/API-OpenWeatherMap-orange?style=for-the-badge&logo=cloud&logoColor=white"/>
<img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green?style=for-the-badge&logo=android&logoColor=white"/>
<img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge"/>

A beautiful, production-ready **mobile weather application** built with Flutter and Dart.  
Fetches real-time city-based weather data from the OpenWeatherMap REST API.

</div>

---

## ✨ Features

| Feature | Description |
|---|---|
| 🔍 **City Search** | Search weather by any city name in the world |
| 🌡️ **°C / °F Toggle** | Tap the temperature to instantly switch units |
| 💧 **Full Details** | Humidity, Wind Speed, Feels Like, Visibility |
| 🎨 **Dynamic Background** | Gradient changes based on weather condition |
| 🌙 **Dark Mode Toggle** | Manual dark/light mode switch in the header |
| 🌅 **Day / Night Detection** | Auto night theme from API icon metadata |
| 💾 **Last City Memory** | Remembers your last searched city on restart |
| 🔄 **Pull to Refresh** | Swipe down to refresh current city data |
| ⚠️ **Error Handling** | Friendly messages for invalid city / no internet |
| ✨ **Smooth Animations** | Fade-in transitions, animated gradient, icon swaps |

---

## 📱 Screenshots

> Run the app on your device/emulator to see the live UI.

| Clear Sky (Day) | Dark Mode | Error State |
|---|---|---|
| Blue gradient background | Deep dark purple gradient | Red inline error card |

---

## 🏗️ Project Architecture

```
lib/
├── main.dart                    # App entry, Material 3 theme, Google Fonts
├── models/
│   └── weather_model.dart       # Data class + fromJson() + unit conversions
├── services/
│   └── weather_service.dart     # Async API calls, error handling
├── screens/
│   └── home_screen.dart         # Main screen, state management, animations
└── widgets/
    ├── weather_card.dart        # Temperature, icon, condition display
    ├── search_bar_widget.dart   # Glassmorphism search input
    └── detail_chip.dart         # Reusable metric tile (humidity, wind, etc.)
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) `>=3.0.0`
- An Android device / emulator **or** iOS device / simulator
- A free [OpenWeatherMap API key](https://openweathermap.org/api)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/Rudraksh-Thakare/flutter-weather-app.git
cd flutter-weather-app

# 2. Install dependencies
flutter pub get

# 3. Add your API key
# Open lib/services/weather_service.dart and replace:
static const String _apiKey = 'YOUR_API_KEY_HERE';

# 4. Run the app
flutter run
```

---

## 🔑 API Configuration

This app uses the **OpenWeatherMap Current Weather API** (free tier).

1. Sign up at [https://openweathermap.org/api](https://openweathermap.org/api)
2. Go to **My API Keys** and copy your key
3. Open [`lib/services/weather_service.dart`](lib/services/weather_service.dart)
4. Replace the `_apiKey` value with your key

```dart
static const String _apiKey = 'your_key_here';
```

> ⚠️ **Note**: New API keys may take up to 2 hours to activate on the free tier.

---

## 📦 Dependencies

| Package | Version | Purpose |
|---|---|---|
| [`http`](https://pub.dev/packages/http) | `^1.2.1` | REST API calls |
| [`shared_preferences`](https://pub.dev/packages/shared_preferences) | `^2.2.3` | Last city persistence |
| [`google_fonts`](https://pub.dev/packages/google_fonts) | `^6.2.1` | Outfit font family |

---

## 🔌 API Response Parsing

The app uses `async/await` and `dart:convert` to handle JSON responses:

```dart
// weather_service.dart
Future<WeatherModel> fetchWeather(String city) async {
  final response = await http.get(url).timeout(Duration(seconds: 10));
  if (response.statusCode == 200) {
    return WeatherModel.fromJson(json.decode(response.body));
  } else if (response.statusCode == 404) {
    throw WeatherException('City "$city" not found.');
  }
  // ... more error cases
}

// weather_model.dart
factory WeatherModel.fromJson(Map<String, dynamic> json) {
  return WeatherModel(
    cityName:    json['name'],
    temperature: (json['main']['temp'] as num).toDouble(),   // Kelvin
    humidity:    json['main']['humidity'],
    windSpeed:   (json['wind']['speed'] as num).toDouble(),
    condition:   json['weather'][0]['main'],
    iconCode:    json['weather'][0]['icon'],
    // ...
  );
}
```

---

## 🎨 Dynamic Weather Themes

The background gradient automatically adapts to the current weather:

| Condition | Gradient |
|---|---|
| ☀️ Clear (day) | `#2980B9` → `#6DD5FA` (blue sky) |
| ☁️ Cloudy | `#4B79A1` → `#283E51` (steel blue) |
| 🌧️ Rain / Drizzle | `#2C3E50` → `#3498DB` (dark blue) |
| ⛈️ Thunderstorm | `#1a1a2e` → `#4a4e69` (near-black) |
| ❄️ Snow | `#83a4d4` → `#b6fbff` (icy light blue) |
| 🌫️ Mist / Haze / Fog | `#606c88` → `#3f4c6b` (grey-blue) |
| 🌙 Night (any) | `#0f0c29` → `#302b63` (deep purple) |
| 🌑 Dark Mode | `#0a0a1a` → `#1a1035` (darkest) |

---

## 📋 Error Handling

All error cases are caught and shown as friendly inline messages:

```
🔴 City "xyz123" not found. Please check the spelling and try again.
🔴 No internet connection. Please check your network and try again.
🔴 Invalid API key. Please check your configuration.
🔴 Request timed out. Please try again.
```

---

## 🛠️ Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

<div align="center">

Made with ❤️ using **Flutter** & **Dart**  
by [Rudraksh Thakare](https://github.com/Rudraksh-Thakare)

⭐ Star this repo if you found it helpful!

</div>
