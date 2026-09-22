# Android Studio Mobile Development Reference Guide

This reference provides modern Kotlin architecture guidelines, low-spec laptop optimizations, and physical device ADB runbooks for **Mobile App Development**.

---

## 1. Weak Laptop Survival Guide for Android Studio

Android Studio and Android Virtual Devices (AVD emulators) can easily consume 6–10GB of RAM. Follow these settings on your portable laptop:

### A. Tame Gradle Memory Consumption
Add the following to `~/.gradle/gradle.properties` or `<project-root>/gradle.properties`:
```properties
# Cap Gradle JVM heap to 2GB to prevent laptop swapping/freeze
org.gradle.jvmargs=-Xmx2048m -XX:MaxMetaspaceSize=512m -XX:+UseParallelGC

# Limit parallel tasks on low-core laptops
org.gradle.parallel=false
org.gradle.caching=true
org.gradle.vfs.watch=false
```

### B. Use Physical Android Phone Instead of Emulator
A physical Android device runs the application on its own hardware, requiring **0% emulator CPU/RAM** on your laptop!

#### Physical Phone via USB:
1. Enable Developer Options on phone: Tap **Settings > About Phone > Build Number** 7 times.
2. Enable **USB Debugging** in Developer Options.
3. Connect phone via USB cable and allow debugging permission popup.
4. Verify with: `adb devices`

#### Physical Phone via Wireless ADB (No Cable Needed!):
```bash
# 1. Connect phone via USB first, ensure laptop and phone are on same Wi-Fi
adb tcpip 5555

# 2. Find Phone IP (Settings > Wi-Fi > Network Details > IP Address)
adb connect 192.168.1.xxx:5555

# 3. Unplug USB cable! You can now deploy and debug over Wi-Fi
adb devices
```

---

## 2. Modern Android Architecture (MVVM + Compose)

```
app/src/main/java/com/example/app/
├── data/
│   ├── local/          # Room DB, DAOs, Entities
│   ├── remote/         # Retrofit API Services, DTOs
│   └── repository/     # Repository implementations
├── domain/
│   ├── model/          # Pure Kotlin business models
│   └── usecase/        # Optional Use Cases / Interactors
└── ui/
    ├── components/     # Reusable Compose widgets
    ├── theme/          # Color, Type, Shape, Theme
    └── screens/        # Screen composables + ViewModels
```

### ViewModel with UI State Flow Pattern
```kotlin
data class ProductUiState(
    val isLoading: Boolean = false,
    val products: List<Product> = emptyList(),
    val errorMessage: String? = null
)

class ProductViewModel(
    private val repository: ProductRepository
) : ViewModel() {

    private val _uiState = MutableStateFlow(ProductUiState(isLoading = true))
    val uiState: StateFlow<ProductUiState> = _uiState.asStateFlow()

    init {
        loadProducts()
    }

    fun loadProducts() {
        viewModelScope.launch {
            _uiState.update { it.copy(isLoading = true, errorMessage = null) }
            try {
                val data = repository.getProducts()
                _uiState.update { it.copy(isLoading = false, products = data) }
            } catch (e: Exception) {
                _uiState.update { it.copy(isLoading = false, errorMessage = e.localizedMessage) }
            }
        }
    }
}
```

---

## 3. Essential ADB Debugging Cheatsheet

```bash
# View real-time crash logs (filtered to FATAL and AndroidRuntime)
adb logcat *:E | grep -E "AndroidRuntime|FATAL EXCEPTION"

# Clear logcat buffer
adb logcat -c

# Install debug APK directly
adb install -r app/build/outputs/apk/debug/app-debug.apk

# Capture screenshot from device for report/presentation
adb exec-out screencap -p > report_screenshot.png

# Grant runtime permission via CLI
adb shell pm grant com.example.app android.permission.CAMERA
```
