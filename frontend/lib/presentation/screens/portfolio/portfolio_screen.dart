
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:frontend/domain/entity/portfolio_holding_entity.dart';
import 'package:frontend/presentation/viewmodels/portfolio_state.dart';
import 'package:frontend/providers/providers.dart';

class PortfolioScreen extends ConsumerWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(portfolioViewModelProvider);
    final currency = ref.watch(marketCurrencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Portfolio'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: state.isLoading
                ? null
                : () => ref
                .read(portfolioViewModelProvider.notifier)
                .refresh(),
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: state.isSaving
            ? null
            : () => _showHoldingForm(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add holding'),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref
            .read(portfolioViewModelProvider.notifier)
            .refresh(),
        child: _buildBody(context, ref, state, currency),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context,
      WidgetRef ref,
      PortfolioState state,
      String currency,
      ) {
    if (state.isLoading && state.holdings.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.holdings.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 100),
          Text(
            state.errorMessage!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => ref
                  .read(portfolioViewModelProvider.notifier)
                  .refresh(),
              child: const Text('Try again'),
            ),
          ),
        ],
      );
    }

    if (state.holdings.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: const [
          SizedBox(height: 100),
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 56,
          ),
          SizedBox(height: 20),
          Text(
            'Your portfolio is empty',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add your first cryptocurrency investment '
                'to start tracking its performance.',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 100),
        ],
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        _buildSummary(context, state, currency),

        if (state.marketDataError != null) ...[
          const SizedBox(height: 12),
          _messageBanner(
            'Live market prices are temporarily unavailable. '
                'Your saved investments are safe.',
          ),
        ],

        if (state.errorMessage != null) ...[
          const SizedBox(height: 12),
          _messageBanner(state.errorMessage!),
        ],

        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your holdings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${state.holdings.length} assets',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),

        const SizedBox(height: 12),

        ...state.holdings.map(
              (holding) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildHoldingCard(
              context,
              ref,
              holding,
              state,
              currency,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummary(
      BuildContext context,
      PortfolioState state,
      String currency,
      ) {
    final formatter = _currencyFormatter(currency);
    final profit = state.totalProfitLoss;
    final isPositive = profit >= 0;
    final color = isPositive
        ? Colors.green.shade700
        : Colors.red.shade700;

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total portfolio value',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              formatter.format(state.currentValue),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  isPositive
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  color: color,
                  size: 19,
                ),
                const SizedBox(width: 6),
                Text(
                  '${isPositive ? '+' : ''}${formatter.format(profit)} '
                      '(${state.totalProfitLossPercentage.toStringAsFixed(2)}%)',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const Divider(height: 28),
            Row(
              children: [
                Expanded(
                  child: _summaryItem(
                    'Invested amount',
                    formatter.format(state.totalInvested),
                  ),
                ),
                Expanded(
                  child: _summaryItem(
                    'Profit / Loss',
                    formatter.format(profit),
                    valueColor: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryItem(
      String label,
      String value, {
        Color? valueColor,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildHoldingCard(
      BuildContext context,
      WidgetRef ref,
      PortfolioHolding holding,
      PortfolioState state,
      String currency,
      ) {
    final coin = state.marketCoinsById[holding.coinId];
    final currentPrice = coin?.currentPrice;
    final currentValue = currentPrice == null
        ? holding.investedAmount
        : holding.currentValue(currentPrice);

    final profit = currentPrice == null
        ? null
        : holding.profitLoss(currentPrice);

    final formatter = _currencyFormatter(currency);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor:
                  Theme.of(context).colorScheme.primaryContainer,
                  backgroundImage: coin?.image != null
                      ? NetworkImage(coin!.image!)
                      : null,
                  child: coin?.image == null
                      ? Text(
                    holding.coinId.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coin?.name ?? _formatCoinId(holding.coinId),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        coin?.symbol.toUpperCase() ?? holding.coinId,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (action) {
                    if (action == 'edit') {
                      _showHoldingForm(
                        context,
                        ref,
                        holding: holding,
                      );
                    } else if (action == 'delete') {
                      _confirmDelete(context, ref, holding);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit holding'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete holding'),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _holdingDetail(
                  'Quantity',
                  '${holding.quantity} ${coin?.symbol.toUpperCase() ?? ''}',
                ),
                _holdingDetail(
                  'Current value',
                  formatter.format(currentValue),
                  alignment: CrossAxisAlignment.end,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _holdingDetail(
                  'Purchase price',
                  formatter.format(holding.purchasePrice),
                ),
                if (profit != null)
                  _holdingDetail(
                    'Profit / Loss',
                    '${profit >= 0 ? '+' : ''}${formatter.format(profit)}',
                    alignment: CrossAxisAlignment.end,
                    valueColor: profit >= 0
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  )
                else
                  _holdingDetail(
                    'Profit / Loss',
                    'Price unavailable',
                    alignment: CrossAxisAlignment.end,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _holdingDetail(
      String label,
      String value, {
        CrossAxisAlignment alignment = CrossAxisAlignment.start,
        Color? valueColor,
      }) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _messageBanner(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Future<void> _showHoldingForm(
      BuildContext context,
      WidgetRef ref, {
        PortfolioHolding? holding,
      }) async {
    final result = await showDialog<PortfolioHoldingFormResult>(
      context: context,
      builder: (_) => _PortfolioHoldingDialog(holding: holding),
    );

    if (result == null || !context.mounted) return;

    final notifier = ref.read(portfolioViewModelProvider.notifier);

    final success = holding == null
        ? await notifier.addHolding(
      coinId: result.coinId,
      quantity: result.quantity,
      purchasePrice: result.purchasePrice,
      purchaseDate: result.purchaseDate,
    )
        : await notifier.updateHolding(
      PortfolioHolding(
        id: holding.id,
        coinId: holding.coinId,
        quantity: result.quantity,
        purchasePrice: result.purchasePrice,
        purchaseDate: result.purchaseDate,
      ),
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? holding == null
              ? 'Investment added successfully'
              : 'Investment updated successfully'
              : ref.read(portfolioViewModelProvider).errorMessage ??
              'Unable to save investment',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context,
      WidgetRef ref,
      PortfolioHolding holding,
      ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete holding?'),
        content: Text(
          'Remove ${_formatCoinId(holding.coinId)} from your portfolio?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final success = await ref
        .read(portfolioViewModelProvider.notifier)
        .deleteHolding(holding.id);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Holding deleted' : 'Unable to delete holding',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  NumberFormat _currencyFormatter(String currency) {
    return NumberFormat.currency(
      name: currency.toUpperCase(),
      decimalDigits: 2,
    );
  }

  String _formatCoinId(String id) {
    return id
        .split('-')
        .map(
          (part) => part.isEmpty
          ? part
          : '${part[0].toUpperCase()}${part.substring(1)}',
    )
        .join(' ');
  }
}

class PortfolioHoldingFormResult {
  const PortfolioHoldingFormResult({
    required this.coinId,
    required this.quantity,
    required this.purchasePrice,
    required this.purchaseDate,
  });

  final String coinId;
  final double quantity;
  final double purchasePrice;
  final DateTime purchaseDate;
}

class _PortfolioHoldingDialog extends StatefulWidget {
  const _PortfolioHoldingDialog({this.holding});

  final PortfolioHolding? holding;

  @override
  State<_PortfolioHoldingDialog> createState() =>
      _PortfolioHoldingDialogState();
}

class _PortfolioHoldingDialogState
    extends State<_PortfolioHoldingDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _coinController;
  late final TextEditingController _quantityController;
  late final TextEditingController _priceController;

  late DateTime _purchaseDate;

  @override
  void initState() {
    super.initState();

    final holding = widget.holding;

    _coinController = TextEditingController(
      text: holding?.coinId ?? '',
    );
    _quantityController = TextEditingController(
      text: holding?.quantity.toString() ?? '',
    );
    _priceController = TextEditingController(
      text: holding?.purchasePrice.toString() ?? '',
    );

    _purchaseDate = holding?.purchaseDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _coinController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  String? _validateNumber(String? value) {
    final number = double.tryParse(value?.trim() ?? '');

    if (number == null || !number.isFinite || number <= 0) {
      return 'Enter a valid number greater than zero';
    }

    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      PortfolioHoldingFormResult(
        coinId: _coinController.text.trim().toLowerCase(),
        quantity: double.parse(_quantityController.text.trim()),
        purchasePrice: double.parse(_priceController.text.trim()),
        purchaseDate: _purchaseDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.holding != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit investment' : 'Add investment'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _coinController,
                readOnly: isEditing,
                textCapitalization: TextCapitalization.none,
                decoration: const InputDecoration(
                  labelText: 'Coin ID',
                  hintText: 'Example: bitcoin',
                  helperText: 'Use the CoinGecko ID, not the symbol.',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a coin ID';
                  }

                  if (!RegExp(r'^[a-zA-Z0-9-]+$')
                      .hasMatch(value.trim())) {
                    return 'Enter a valid coin ID';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _quantityController,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  hintText: 'Example: 0.05',
                ),
                validator: _validateNumber,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Purchase price',
                  hintText: 'Price per coin in selected currency',
                ),
                validator: _validateNumber,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: Text('Purchase date'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final selected = await showDatePicker(
                        context: context,
                        initialDate: _purchaseDate,
                        firstDate: DateTime(2009),
                        lastDate: DateTime.now(),
                      );

                      if (selected != null) {
                        setState(() => _purchaseDate = selected);
                      }
                    },
                    child: Text(
                      DateFormat('dd MMM yyyy').format(_purchaseDate),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(isEditing ? 'Save changes' : 'Add holding'),
        ),
      ],
    );
  }
}
