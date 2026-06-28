import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/weather_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final WeatherService _weatherService = WeatherService();

  WeatherModel? _weather;
  String? _errorMessage;
  bool _isLoading = false;
  bool _isCelsius = true;
  bool _isDarkMode = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _loadLastCity();
  }

  Future<void> _loadLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCity = prefs.getString('last_city') ?? 'London';
    _searchController.text = lastCity;
    await _fetchWeather(lastCity);
  }

  Future<void> _saveLastCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_city', city);
  }

  Future<void> _fetchWeather(String city) async {
    if (city.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _fadeController.reset();

    try {
      final weather = await _weatherService.fetchWeather(city.trim());
      if (mounted) {
        setState(() {
          _weather = weather;
          _isLoading = false;
        });
        await _saveLastCity(city.trim());
        _fadeController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _onSearch() {
    FocusScope.of(context).unfocus();
    _fetchWeather(_searchController.text);
  }

  List<Color> _getGradientColors() {
    // Manual dark mode overrides everything
    if (_isDarkMode) {
      return [const Color(0xFF0a0a1a), const Color(0xFF1a1035)];
    }
    if (_weather == null) {
      return [const Color(0xFF1a1a2e), const Color(0xFF16213e)];
    }
    final condition = _weather!.condition.toLowerCase();
    final isNight = _weather!.isNight;

    if (isNight) {
      return [const Color(0xFF0f0c29), const Color(0xFF302b63)];
    }
    switch (condition) {
      case 'clear':
        return [const Color(0xFF2980B9), const Color(0xFF6DD5FA)];
      case 'clouds':
        return [const Color(0xFF4B79A1), const Color(0xFF283E51)];
      case 'rain':
      case 'drizzle':
        return [const Color(0xFF2C3E50), const Color(0xFF3498DB)];
      case 'thunderstorm':
        return [const Color(0xFF1a1a2e), const Color(0xFF4a4e69)];
      case 'snow':
        return [const Color(0xFF83a4d4), const Color(0xFFb6fbff)];
      case 'mist':
      case 'fog':
      case 'haze':
        return [const Color(0xFF606c88), const Color(0xFF3f4c6b)];
      default:
        return [const Color(0xFF2980B9), const Color(0xFF6DD5FA)];
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = _getGradientColors();

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => _fetchWeather(_searchController.text),
            backgroundColor: Colors.white.withValues(alpha: 0.15),
            color: Colors.white,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      children: [
                        // App title row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Weather',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 2,
                                  ),
                                ),
                                const Text(
                                  'Forecast',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    height: 1.1,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() => _isDarkMode = !_isDarkMode);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _isDarkMode
                                      ? Colors.indigo.withValues(alpha: 0.4)
                                      : Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: _isDarkMode
                                        ? Colors.indigo.shade300.withValues(alpha: 0.6)
                                        : Colors.white.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: Icon(
                                    _isDarkMode
                                        ? Icons.dark_mode_rounded
                                        : Icons.light_mode_rounded,
                                    key: ValueKey(_isDarkMode),
                                    color: _isDarkMode
                                        ? Colors.indigo.shade200
                                        : Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Search bar
                        SearchBarWidget(
                          controller: _searchController,
                          onSearch: _onSearch,
                          isLoading: _isLoading,
                        ),

                        const SizedBox(height: 32),

                        // Error message
                        if (_errorMessage != null) _buildErrorWidget(),

                        // Weather content
                        if (_weather != null && !_isLoading)
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: WeatherCard(
                              weather: _weather!,
                              isCelsius: _isCelsius,
                              onToggleUnit: () {
                                setState(() => _isCelsius = !_isCelsius);
                              },
                            ),
                          ),

                        // Initial loading state
                        if (_isLoading && _weather == null)
                          _buildInitialLoading(),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded,
              color: Colors.red.shade300, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.red.shade200,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialLoading() {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2,
            ),
            const SizedBox(height: 20),
            Text(
              'Fetching weather data...',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
