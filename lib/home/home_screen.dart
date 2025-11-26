// Import Flutter's Material Design library for UI components
import 'package:flutter/material.dart';
// Import the Tic Tac Toe game screen
import '../games/tic_tac_toe/tic_tac_toe_screen.dart';
// Import the Memory Cards game screen
import '../games/memory/memory_screen.dart';
// Import the Snake game screen
import '../games/snake/snake_screen.dart';
// Import the Reaction Test game screen
import '../games/reaction/reaction_screen.dart';
// Import the Avoid the Blocks game screen
import '../games/avoid_blocks/avoid_blocks_screen.dart';

// Main home screen widget that displays the game menu
class HomeScreen extends StatefulWidget {
  // Constructor with const keyword for performance optimization
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Current selected index for bottom navigation
  int _selectedIndex = 0;

  // List of game data for easy management
  final List<GameData> _games = [
    GameData(
      title: 'Tic Tac Toe',
      icon: Icons.grid_3x3,
      color: Colors.blue,
      description: 'Play against an unbeatable AI',
      screen: const TicTacToeScreen(),
    ),
    GameData(
      title: 'Memory Cards',
      icon: Icons.memory,
      color: Colors.purple,
      description: 'Match pairs of cards',
      screen: const MemoryScreen(),
    ),
    GameData(
      title: 'Snake',
      icon: Icons.settings_ethernet,
      color: Colors.green,
      description: 'Classic snake game',
      screen: const SnakeScreen(),
    ),
    GameData(
      title: 'Reaction Test',
      icon: Icons.timer,
      color: Colors.orange,
      description: 'Test your reaction time',
      screen: const ReactionScreen(),
    ),
    GameData(
      title: 'Avoid the Blocks',
      icon: Icons.block,
      color: Colors.red,
      description: 'Dodge falling blocks',
      screen: const AvoidBlocksScreen(),
    ),
  ];

  // Handle bottom navigation bar item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Navigate to a specific game
  void _navigateToGame(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // Override the build method to define the widget's UI
  @override
  Widget build(BuildContext context) {
    // Return a Scaffold which provides the basic app structure
    return Scaffold(
      // App bar at the top of the screen
      appBar: AppBar(
        // Enable elevation for a shadow effect
        elevation: 0,
        // Flexible space for gradient background
        flexibleSpace: Container(
          // Decorate with gradient background
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primaryContainer,
              ],
            ),
          ),
        ),
        // Title text displayed in the app bar
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App icon/logo
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.sports_esports,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // App title
            const Text(
              'Mini Game Collection',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        // Center the title horizontally
        centerTitle: true,
      ),
      // Navigation drawer (hamburger menu)
      drawer: _buildDrawer(),
      // Main body content of the screen
      body: Container(
        // Decorate with gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surfaceContainerHighest,
            ],
          ),
        ),
        child: Padding(
          // Add padding around all edges (16 pixels)
          padding: const EdgeInsets.all(16.0),
          // Create a grid layout for the game cards
          child: GridView.builder(
            // Number of columns in the grid (2 columns)
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            // Number of items in the grid
            itemCount: _games.length,
            // Builder function for each grid item
            itemBuilder: (context, index) {
              return _GameCard(
                game: _games[index],
                onTap: () => _navigateToGame(_games[index].screen),
              );
            },
          ),
        ),
      ),
      // Bottom navigation bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          // Current selected index
          currentIndex: _selectedIndex,
          // Handle item selection
          onTap: _onItemTapped,
          // Type of bottom navigation bar (fixed shows all labels)
          type: BottomNavigationBarType.fixed,
          // Selected item color
          selectedItemColor: Theme.of(context).colorScheme.primary,
          // Unselected item color
          unselectedItemColor: Colors.grey,
          // Selected label style
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          // Unselected label style
          unselectedLabelStyle: const TextStyle(
            fontSize: 11,
          ),
          // Items in the bottom navigation bar
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.games),
              label: 'Games',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'About',
            ),
          ],
        ),
      ),
    );
  }

  // Build the navigation drawer
  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer header
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // App icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.sports_esports,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // App name
                  const Text(
                    'Mini Game Collection',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // App subtitle
                  Text(
                    '5 Fun Games to Play',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Menu items
            _buildDrawerItem(
              icon: Icons.home,
              title: 'Home',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              icon: Icons.games,
              title: 'All Games',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            // Game list in drawer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Games',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            // List of games in drawer
            ..._games.map((game) => _buildDrawerGameItem(game)),
            const Divider(),
            _buildDrawerItem(
              icon: Icons.info,
              title: 'About',
              onTap: () {
                Navigator.pop(context);
                _showAboutDialog();
              },
            ),
            _buildDrawerItem(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Build a drawer menu item
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
      hoverColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }

  // Build a game item in the drawer
  Widget _buildDrawerGameItem(GameData game) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: game.color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(game.icon, color: game.color),
      ),
      title: Text(game.title),
      subtitle: Text(
        game.description,
        style: TextStyle(fontSize: 12),
      ),
      onTap: () {
        Navigator.pop(context);
        _navigateToGame(game.screen);
      },
    );
  }

  // Show about dialog
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About'),
        content: const Text(
          'Mini Game Collection\n\n'
          'A collection of 5 fun mini games:\n'
          '• Tic Tac Toe\n'
          '• Memory Cards\n'
          '• Snake\n'
          '• Reaction Test\n'
          '• Avoid the Blocks\n\n'
          'Enjoy playing!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Data class for game information
class GameData {
  final String title;
  final IconData icon;
  final Color color;
  final String description;
  final Widget screen;

  GameData({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
    required this.screen,
  });
}

// Private widget class for individual game cards (underscore prefix makes it private)
class _GameCard extends StatelessWidget {
  // Game data object
  final GameData game;
  // Callback function to execute when the card is tapped
  final VoidCallback onTap;

  // Constructor with required parameters
  const _GameCard({
    required this.game,
    required this.onTap,
  });

  // Override the build method to define the card's UI
  @override
  Widget build(BuildContext context) {
    // Return a Card widget with rounded corners
    return Card(
      // Elevation for shadow effect
      elevation: 4,
      // Clip child widgets to the card's rounded corners
      clipBehavior: Clip.antiAlias,
      // Shape with rounded corners
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      // Make the card tappable with ripple effect
      child: InkWell(
        // Execute the onTap callback when card is tapped
        onTap: onTap,
        // Container for the card's content
        child: Container(
          // Decorate the container with a gradient background
          decoration: BoxDecoration(
            // Create a linear gradient from top-left to bottom-right
            gradient: LinearGradient(
              // Starting point of the gradient (top-left corner)
              begin: Alignment.topLeft,
              // Ending point of the gradient (bottom-right corner)
              end: Alignment.bottomRight,
              // List of colors for the gradient
              colors: [
                // First color: base color with 70% opacity (lighter)
                game.color.withOpacity(0.8),
                // Second color: base color with 90% opacity (darker)
                game.color.withOpacity(0.95),
              ],
            ),
          ),
          // Column layout for vertical arrangement of icon and text
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              // Center all children vertically within the column
              mainAxisAlignment: MainAxisAlignment.center,
              // List of child widgets in the column
              children: [
                // Icon container with background
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    // Icon data to display
                    game.icon,
                    // Size of the icon (40 pixels)
                    size: 40,
                    // Color of the icon (white)
                    color: Colors.white,
                  ),
                ),
                // Add vertical spacing between icon and text (16 pixels)
                const SizedBox(height: 16),
                // Display the game title text
                Text(
                  // Text content to display
                  game.title,
                  // Text styling configuration
                  style: const TextStyle(
                    // Text color (white)
                    color: Colors.white,
                    // Font size (16 pixels)
                    fontSize: 16,
                    // Font weight (bold)
                    fontWeight: FontWeight.bold,
                  ),
                  // Center align the text horizontally
                  textAlign: TextAlign.center,
                  // Maximum number of lines
                  maxLines: 2,
                  // Handle text overflow
                  overflow: TextOverflow.ellipsis,
                ),
                // Add vertical spacing
                const SizedBox(height: 8),
                // Display game description
                Text(
                  game.description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
