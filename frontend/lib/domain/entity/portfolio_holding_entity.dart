
class PortfolioHolding {
  const PortfolioHolding({
    required this.id,
    required this.coinId,
    required this.quantity,
    required this.purchasePrice,
    required this.purchaseDate,
  });

  final String id;
  final String coinId;
  final double quantity;
  final double purchasePrice;
  final DateTime purchaseDate;

  double get investedAmount => quantity * purchasePrice;

  double currentValue(double currentPrice) {
    return quantity * currentPrice;
  }

  double profitLoss(double currentPrice) {
    return currentValue(currentPrice) - investedAmount;
  }

  double profitLossPercentage(double currentPrice) {
    if (investedAmount <= 0) return 0;

    return (profitLoss(currentPrice) / investedAmount) * 100;
  }
}
