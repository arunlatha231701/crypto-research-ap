import 'package:frontend/core/platform/app_icons.dart';
import 'package:frontend/presentation/screens/coins/coin_details_screen.dart';
import 'package:frontend/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:frontend/presentation/screens/market/market_screen.dart';
import 'package:frontend/presentation/screens/portfolio/portfolio_screen.dart';
import 'package:frontend/presentation/screens/profile/profile_screen.dart';
import 'package:frontend/presentation/screens/splash.dart';
import 'package:frontend/presentation/screens/watchlist/watchlist_screen.dart';
import 'package:frontend/providers/providers.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/presentation/screens/authentication/login_screen.dart';
import 'route_names.dart';
import 'route_paths.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authViewModelProvider);
  final router = GoRouter(
    initialLocation: RoutePaths.login,
    redirect: (context, state) {
      final isSplash = state.matchedLocation == RoutePaths.splash;
      final isLogin = state.matchedLocation == RoutePaths.login;

      if (authState.isInitializing) {
        return isSplash ? null : RoutePaths.splash;
      }

      if (!authState.isAuthenticated) {
        return isLogin ? null : RoutePaths.login;
      }

      if (isSplash || isLogin) {
        return RoutePaths.home;
      }

      return null;
    },

    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) =>  SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppNavigationShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.home,
                name: RouteNames.home,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.market,
                name: RouteNames.market,
                builder: (context, state) => const MarketScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.watchlist,
                name: RouteNames.watchlist,
                builder: (context, state) => const WatchlistScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.portfolio,
                name: RouteNames.portfolio,
                builder: (context, state) => const PortfolioScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.profile,
                name: RouteNames.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: RoutePaths.coinDetails,
        name: RouteNames.coinDetails,
        builder: (context, state) {
          final coinId = state.pathParameters['coinId']!;

          return CoinDetailsScreen(coinId: coinId);
        },
      ),

      GoRoute(
        path: RoutePaths.settings,
        name: RouteNames.settings,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Settings'))),
      ),

      GoRoute(
        path: RoutePaths.coinComparison,
        name: RouteNames.coinComparison,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Coin Comparison'))),
      ),
    ],
  );

  ref.onDispose(router.dispose);

  return router;
});

class AppNavigationShell extends StatelessWidget {
  const AppNavigationShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        height: 72,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: Icon(AppIcons.homeOutlined),
            selectedIcon: Icon(AppIcons.homeRounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(AppIcons.analyticsOutlined),
            selectedIcon: Icon(AppIcons.analyticsRounded),
            label: 'Markets',
          ),
          NavigationDestination(
            icon: Icon(AppIcons.bookmarkBorder),
            selectedIcon: Icon(AppIcons.bookmark),
            label: 'Watchlist',
          ),
          NavigationDestination(
            icon: Icon(AppIcons.accountBalanceWalletRounded),
            selectedIcon: Icon(AppIcons.accountBalanceWalletRounded),
            label: 'Portfolio',
          ),
          NavigationDestination(
            icon: Icon(AppIcons.personOutlineRounded),
            selectedIcon: Icon(AppIcons.personRounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
