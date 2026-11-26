
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/data%20sources/auth_remote_data_source.dart';
import 'package:frontend/data/data%20sources/coin_details_remote_data_source.dart';

import 'package:frontend/data/data%20sources/market_remote_data_source.dart';
import 'package:frontend/data/data%20sources/portfolio_local_data_source.dart';
import 'package:frontend/data/data%20sources/profile_remote_data_source.dart';
import 'package:frontend/data/data%20sources/watchlist_remote_data_source.dart';
import 'package:frontend/data/repository_impl/auth_repository_impl.dart';
import 'package:frontend/data/repository_impl/coin_details_repository_impl.dart';
import 'package:frontend/data/repository_impl/market_repository_impl.dart';
import 'package:frontend/data/repository_impl/portfolio_repository_impl.dart';
import 'package:frontend/data/repository_impl/watchlist_repository_impl.dart';
import 'package:frontend/domain/repository/auth_repository.dart';
import 'package:frontend/domain/repository/coin_details_repository.dart';
import 'package:frontend/domain/repository/market_repository.dart';
import 'package:frontend/domain/repository/portfolio_repository.dart';
import 'package:frontend/domain/repository/watchlist_repository.dart';
import 'package:frontend/domain/usecase/auth/login_usecase.dart';
import 'package:frontend/domain/usecase/coin/get_coin_chart_usecase.dart';
import 'package:frontend/domain/usecase/coin/get_coin_details_usecase.dart';
import 'package:frontend/domain/usecase/market/get_global_market_stats_usecase.dart';
import 'package:frontend/domain/usecase/market/get_market_coins_by_ids_usecase.dart';
import 'package:frontend/domain/usecase/market/get_market_coins_usecase.dart';
import 'package:frontend/domain/usecase/watchlist/add_to_watchlist_usecase.dart';
import 'package:frontend/domain/usecase/watchlist/get_watchlist_usecase.dart';
import 'package:frontend/domain/usecase/watchlist/remove_from_watchlist_usecase.dart';
import 'package:frontend/presentation/viewmodels/auth_state.dart';
import 'package:frontend/presentation/viewmodels/auth_viewmodel.dart';
import 'package:frontend/presentation/viewmodels/coin_details_state.dart';
import 'package:frontend/presentation/viewmodels/coin_details_viewmodel.dart';
import 'package:frontend/presentation/viewmodels/dashboard_state.dart';
import 'package:frontend/presentation/viewmodels/dashboard_viewmodel.dart';
import 'package:frontend/presentation/viewmodels/market_state.dart';
import 'package:frontend/presentation/viewmodels/market_viewmodel.dart';
import 'package:frontend/presentation/viewmodels/portfolio_state.dart';
import 'package:frontend/presentation/viewmodels/portfolio_viewmodel.dart';
import 'package:frontend/presentation/viewmodels/profile_state.dart';
import 'package:frontend/presentation/viewmodels/profile_viewmodel.dart';
import 'package:frontend/presentation/viewmodels/watchlist_state.dart';
import 'package:frontend/presentation/viewmodels/watchlist_viewmodel.dart';
import 'package:frontend/providers/storage_providers.dart';
import 'package:hive/hive.dart';

import '../core/constants/market_config.dart';
import 'api_service_provider.dart';

final authRemoteDataSourceProvider =
Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(
    ref.watch(apiServiceProvider),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(tokenStorageProvider),
  );
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(
    ref.watch(authRepositoryProvider),
  );
});

final authViewModelProvider =
NotifierProvider<AuthViewModel, AuthState>(
  AuthViewModel.new,
);




final marketRemoteDataSourceProvider =
Provider<MarketRemoteDataSource>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return MarketRemoteDataSource(apiService);
});

final marketRepositoryProvider = Provider<MarketRepository>((ref) {
  final remoteDataSource = ref.watch(marketRemoteDataSourceProvider);
  return MarketRepositoryImpl(remoteDataSource);
});

final getGlobalMarketStatsUseCaseProvider =
Provider<GetGlobalMarketStatsUseCase>((ref) {
  return GetGlobalMarketStatsUseCase(
    ref.watch(marketRepositoryProvider),
  );
});

final getMarketCoinsUseCaseProvider =
Provider<GetMarketCoinsUseCase>((ref) {
  return GetMarketCoinsUseCase(
    ref.watch(marketRepositoryProvider),
  );
});

class MarketCurrencyNotifier extends Notifier<String> {
  @override
  String build() {
    return MarketConfig.defaultCurrency;
  }

  void changeCurrency(String currency) {
    final normalizedCurrency = currency.toLowerCase();

    if (!MarketConfig.supportedCurrencies
        .contains(normalizedCurrency)) {
      return;
    }

    state = normalizedCurrency;
  }
}

final marketCurrencyProvider =
NotifierProvider<MarketCurrencyNotifier, String>(
  MarketCurrencyNotifier.new,
);

final dashboardViewModelProvider =
AsyncNotifierProvider<DashboardViewModel, DashboardData>(
  DashboardViewModel.new,
);
final marketExplorerProvider =
AsyncNotifierProvider<MarketViewModel, MarketState>(
  MarketViewModel.new,
);
final getMarketCoinsByIdsUseCaseProvider =
Provider<GetMarketCoinsByIdsUseCase>((ref) {
  return GetMarketCoinsByIdsUseCase(
    ref.watch(marketRepositoryProvider),
  );
});

final coinDetailsRemoteDataSourceProvider =
Provider<CoinDetailsRemoteDataSource>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return CoinDetailsRemoteDataSource(apiService);
});

final coinDetailsRepositoryProvider =
Provider<CoinDetailsRepository>((ref) {
  final remoteDataSource =
  ref.watch(coinDetailsRemoteDataSourceProvider);

  return CoinDetailsRepositoryImpl(remoteDataSource);
});

final getCoinDetailsUseCaseProvider =
Provider<GetCoinDetailsUseCase>((ref) {
  return GetCoinDetailsUseCase(
    ref.watch(coinDetailsRepositoryProvider),
  );
});

final getCoinChartUseCaseProvider =
Provider<GetCoinChartUseCase>((ref) {
  return GetCoinChartUseCase(
    ref.watch(coinDetailsRepositoryProvider),
  );
});

final coinDetailsViewModelProvider = AsyncNotifierProvider
    .family<CoinDetailsViewModel, CoinDetailsState, String>(
  CoinDetailsViewModel.new,
);




final watchlistRemoteDataSourceProvider =
Provider<WatchlistRemoteDataSource>((ref) {
  return WatchlistRemoteDataSource(
    ref.watch(apiServiceProvider),
  );
});

final watchlistRepositoryProvider =
Provider<WatchlistRepository>((ref) {
  return WatchlistRepositoryImpl(
    ref.watch(watchlistRemoteDataSourceProvider),
  );
});

final getWatchlistUseCaseProvider =
Provider<GetWatchlistUseCase>((ref) {
  return GetWatchlistUseCase(
    ref.watch(watchlistRepositoryProvider),
  );
});

final addToWatchlistUseCaseProvider =
Provider<AddToWatchlistUseCase>((ref) {
  return AddToWatchlistUseCase(
    ref.watch(watchlistRepositoryProvider),
  );
});

final removeFromWatchlistUseCaseProvider =
Provider<RemoveFromWatchlistUseCase>((ref) {
  return RemoveFromWatchlistUseCase(
    ref.watch(watchlistRepositoryProvider),
  );
});

final watchlistViewModelProvider =
NotifierProvider<WatchlistViewModel, WatchlistState>(
  WatchlistViewModel.new,
);

final portfolioLocalDataSourceProvider =
Provider<PortfolioLocalDataSource>((ref) {
  return PortfolioLocalDataSource(
    Hive.box<String>('portfolio_holdings'),
  );
});

final portfolioRepositoryProvider =
Provider<PortfolioRepository>((ref) {
  return PortfolioRepositoryImpl(
    ref.watch(portfolioLocalDataSourceProvider),
  );
});

final portfolioViewModelProvider =
NotifierProvider<PortfolioViewModel, PortfolioState>(
  PortfolioViewModel.new,
);

final profileRemoteDataSourceProvider =
Provider<ProfileRemoteDataSource>((ref) {
  return ProfileRemoteDataSource(
    ref.watch(apiServiceProvider),
  );
});

final profileViewModelProvider =
NotifierProvider<ProfileViewModel, ProfileState>(
  ProfileViewModel.new,
);