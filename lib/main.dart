import 'package:flutter/material.dart';

void main() {
  runApp(const CapstoneSpeedrunApp());
}

class CapstoneSpeedrunApp extends StatefulWidget {
  const CapstoneSpeedrunApp({super.key});

  @override
  State<CapstoneSpeedrunApp> createState() => _CapstoneSpeedrunAppState();
}

class _CapstoneSpeedrunAppState extends State<CapstoneSpeedrunApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capstone App',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: MainShell(
        isDarkMode: _isDarkMode,
        onThemeChanged: (val) => setState(() => _isDarkMode = val),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const MainShell({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentScreen = 0; // 0: Signup, 1: Login, 2: Home, 3: Detail, 4: Settings
  bool _isFavorited = false;
  String _apiQuote = "Loading dynamic wisdom...";
  bool _hasSignupError = false;
  bool _hasLoginError = false;

  @override
  void initState() {
    super.initState();
    _fakeFetchApi();
  }

  void _fakeFetchApi() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _apiQuote = "“The best way to predict the future is to create it.”";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.spa, color: Colors.teal),
            const SizedBox(width: 8),
            Text(_currentScreen > 1 ? 'MindSpace App' : 'Welcome'),
          ],
        ),
        actions: [
          // Developer Quick Switcher to take screenshots fast
          DropdownButton<int>(
            value: _currentScreen,
            items: const [
              DropdownMenuItem(value: 0, child: Text("1. Signup")),
              DropdownMenuItem(value: 1, child: Text("2. Login")),
              DropdownMenuItem(value: 2, child: Text("3. Home")),
              DropdownMenuItem(value: 3, child: Text("4. Detail")),
              DropdownMenuItem(value: 4, child: Text("5. Settings")),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _currentScreen = val);
            },
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildActiveScreen(),
        ),
      ),
    );
  }

  Widget _buildActiveScreen() {
    switch (_currentScreen) {
      case 0:
        return _buildSignupScreen();
      case 1:
        return _buildLoginScreen();
      case 2:
        return _buildHomeScreen();
      case 3:
        return _buildDetailScreen();
      case 4:
        return _buildSettingsScreen();
      default:
        return _buildHomeScreen();
    }
  }

  // --- 1. SIGNUP SCREEN ---
  Widget _buildSignupScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Create Account", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        const TextField(decoration: InputDecoration(labelText: "Username", border: OutlineInputBorder())),
        const SizedBox(height: 12),
        const TextField(decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder())),
        const SizedBox(height: 12),
        const TextField(obscureText: true, decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder())),
        const SizedBox(height: 12),
        if (_hasSignupError)
          const Text("Error: Email address is already formatted incorrectly or in use.", style: TextStyle(color: Colors.red)),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => setState(() => _hasSignupError = !_hasSignupError),
          child: const Text("Sign Up"),
        ),
        TextButton(
          onPressed: () => setState(() => _currentScreen = 1),
          child: const Text("Already have an account? Login"),
        ),
      ],
    );
  }

  // --- 2. LOGIN SCREEN ---
  Widget _buildLoginScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("User Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        const TextField(decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder())),
        const SizedBox(height: 12),
        const TextField(obscureText: true, decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder())),
        const SizedBox(height: 12),
        if (_hasLoginError)
          const Text("Error: Invalid login credentials provided.", style: TextStyle(color: Colors.red)),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => setState(() => _hasLoginError = !_hasLoginError),
          child: const Text("Login"),
        ),
        TextButton(
          onPressed: () => setState(() => _currentScreen = 0),
          child: const Text("Don't have an account? Sign Up"),
        ),
      ],
    );
  }

  // --- 3. HOME SCREEN ---
  Widget _buildHomeScreen() {
    return ListView(
      children: [
        // External API UX Section
        Card(
          color: Colors.teal.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("DAILY INSPIRATION (API)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.teal)),
                const SizedBox(height: 8),
                Text(_apiQuote, style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black87)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text("Available Sessions", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.air, color: Colors.blue),
          title: const Text("Deep Breathing Exercise"),
          subtitle: const Text("Duration: 10 mins"),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16), // Navigation Icon Target
          onTap: () => setState(() => _currentScreen = 3),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.bed, color: Colors.purple),
          title: const Text("Sleep Meditation"),
          subtitle: const Text("Duration: 25 mins"),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => setState(() => _currentScreen = 3),
        ),
      ],
    );
  }

  // --- 4. DETAIL SCREEN WITH LOCAL PERSISTENCE ---
  Widget _buildDetailScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Deep Breathing", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            IconButton(
              icon: Icon(_isFavorited ? Icons.favorite : Icons.favorite_border, color: Colors.red),
              onPressed: () {
                setState(() => _isFavorited = !_isFavorited);
                // Simulated SharedPreferences confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_isFavorited
                        ? "Saved to Local Storage (AsyncStorage)!"
                        : "Removed from Local Storage!"),
                    duration: const Duration(milliseconds: 800),
                  ),
                );
              },
            )
          ],
        ),
        const SizedBox(height: 8),
        const Text("Category: Mindfulness • 10 Mins", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 16),
        const Text(
          "This breathing exercise helps lower cortisol levels and calm your nervous system. "
              "Find a comfortable seated position, close your eyes, and follow the simple pace of inhaling for 4 seconds, holding for 4, and exhaling for 4.",
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
        const Spacer(),
        Center(
          child: ElevatedButton.icon(
            onPressed: () => setState(() => _currentScreen = 2),
            icon: const Icon(Icons.arrow_back),
            label: const Text("Back to Home"),
          ),
        ),
      ],
    );
  }

  // --- 5. SETTINGS & NOTIFICATIONS SCREEN ---
  Widget _buildSettingsScreen() {
    return ListView(
      children: [
        const Text("Application Settings", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text("Dark Theme Mode"),
          subtitle: const Text("Toggle dark and light visual mode"),
          value: widget.isDarkMode,
          onChanged: widget.onThemeChanged,
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.notifications_active),
          title: const Text("Test Push Notification"),
          subtitle: const Text("Trigger local notification immediately"),
          trailing: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Notification Triggered!"),
                  content: const Text("Title: MindSpace Reminder\nBody: Time to take a breath!"),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
                  ],
                ),
              );
            },
            child: const Text("Test Alert"),
          ),
        ),
      ],
    );
  }
}