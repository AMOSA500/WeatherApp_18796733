# 🚀 Mobile Development Coursework - University of Westminster (iOS, SwiftUI, MVVM)

### Built by **Nafiu T. Amosa**  
*Software Engineering Student • iOS Developer • AI & Systems Design Enthusiast*

RaleeySky is a location-aware iOS application designed to help commuters check the weather and see places of interest in their location. The app integrates **MapKit**, **CoreLocation**, **SwiftData**, **MVVM architecture**, and **AI-powered search** to deliver a fast, modern, and intuitive tourist experience.

This repository showcases my understanding of **iOS development**, **mobile system architecture**, and **real-world app engineering**.



## 🔧 Tech Stack (Project-Specific)

### 📱 iOS & Mobile
- Swift  
- SwiftUI  
- MVVM Architecture  
- SwiftData (Persistence)

### 🗺️ Mapping & Location
- MapKit (iOS 17+ Map API)  
- CoreLocation  
- MKLocalSearch (Tourist POIs)

### ⚙️ App Infrastructure
- Async/Await  
- NavigationStack / NavigationSplitView  
- Dependency Injection  
- Error Handling & Clean State Management  

### ☁️ Cloud Integrations (Current & Future)
- Firebase  
- Persistent Data Storage

---

## 📍 Project Overview

RaleeySky connects commuters/tourists to places of interest and provides the  current weather and forecast

The app supports:

- 🔍 **Location Search** (typed address → geocoded coordinates)  
- 🗺️ **Interactive Maps** using the new iOS 17 Map API  
- 📌 **Automatic Tourist Points (POIs)** fetched with MKLocalSearch  
- 📚 **Search History Persistence** stored using SwiftData  
- 🎯 **Default Region** (London on first launch)  
- ⛑️ **Error-Safe Search** for invalid or missing locations  
- 🧭 **Clean MVVM** with strong separation between UI, logic, and persistence  
- 📱 **Adaptive UI** with NavigationSplitView for iPad and Mac Catalyst



## 🗂️ Key Project Structure

### 🧱 Model Layer
- `Location.swift` — Represents saved search locations  
- `POI.swift` — Represents nearby points of interest  

### 🧠 ViewModel Layer
- `LocationViewModel.swift` — Handles:  
  - geocoding  
  - map camera updates  
  - POI fetching  
  - SwiftData persistence  
  - UI state and error handling  

### 🎨 View Layer
- `RootSplitView.swift` — Main entry UI with side navigation  
- `MapSearchView.swift` — Search interface + map preview  
- `MapDetailView.swift` — Detailed view of a selected location and its POIs  

### 📦 App Entry Point
- `MapApp.swift` — SwiftData container setup + ViewModel injection



## 🧪 Unit Testing

This project includes simple but effective tests using an **in-memory SwiftData container**, ensuring isolated, fast, and deterministic test runs.

Test coverage includes:

- Validation of default map region  
- Validation of `updateMap()` logic  
- ViewModel initialisation behaviour



## 📈 What I Learned Building Raleey

- Deep understanding of **MapKit’s new iOS 17 APIs**  
- Clean MVVM architecture for scalable iOS apps  
- How to combine CoreLocation + MKLocalSearch + SwiftData  
- How to design robust, testable ViewModels  
- Strong knowledge in `@Published`, `@Query`, `ModelContext`, and async programming  
- Best practices for user-friendly and error-safe UI  



## 📚 What I’m Improving Next

- Integrating Core ML for intelligent ride matching  
- Designing the backend API for Raleey  
- Improving SwiftData model relationships (1-to-many POIs per Location)  
- Live map tracking & geofencing  
- Testing async and map-related behaviours  



## 📬 Contact Me

**Email:** naf.amosa@gmail.com  
**LinkedIn:** https://linkedin.com/in/amosa500  

If you're a recruiter, developer, or collaborator interested in iOS, mapping, or intelligent transit systems, feel free to reach out.

