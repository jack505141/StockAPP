/// Chip data model for analyzing institutional holdings
class ChipData {
  /// 日期
  final DateTime date;
  
  /// 股票代號
  final String stockId;
  
  /// 外資買賣超 (張)
  final int foreignInvestorNetBuy;
  
  /// 投信買賣超 (張)
  final int investmentTrustNetBuy;
  
  /// 自營商買賣超 (張)
  final int dealerNetBuy;
  
  /// 融資增減 (張)
  final int marginPurchaseChange;
  
  /// 融券增減 (張)
  final int shortSaleChange;
  
  /// 總量 (張)
  final int totalVolume;

  const ChipData({
    required this.date,
    required this.stockId,
    required this.foreignInvestorNetBuy,
    required this.investmentTrustNetBuy,
    required this.dealerNetBuy,
    required this.marginPurchaseChange,
    required this.shortSaleChange,
    required this.totalVolume,
  });

  /// Create ChipData from JSON
  factory ChipData.fromJson(Map<String, dynamic> json) {
    return ChipData(
      date: DateTime.parse(json['date'] as String),
      stockId: json['stockId'] as String,
      foreignInvestorNetBuy: json['foreignInvestorNetBuy'] as int,
      investmentTrustNetBuy: json['investmentTrustNetBuy'] as int,
      dealerNetBuy: json['dealerNetBuy'] as int,
      marginPurchaseChange: json['marginPurchaseChange'] as int,
      shortSaleChange: json['shortSaleChange'] as int,
      totalVolume: json['totalVolume'] as int,
    );
  }

  /// Convert ChipData to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'stockId': stockId,
      'foreignInvestorNetBuy': foreignInvestorNetBuy,
      'investmentTrustNetBuy': investmentTrustNetBuy,
      'dealerNetBuy': dealerNetBuy,
      'marginPurchaseChange': marginPurchaseChange,
      'shortSaleChange': shortSaleChange,
      'totalVolume': totalVolume,
    };
  }

  /// Calculate total institutional net buy
  int get totalInstitutionalNetBuy {
    return foreignInvestorNetBuy + investmentTrustNetBuy + dealerNetBuy;
  }

  /// Check if chips are turning strong
  bool get isChipStrong {
    return totalInstitutionalNetBuy > 0 && 
           foreignInvestorNetBuy > 0;
  }

  @override
  String toString() {
    return 'ChipData(date: $date, stockId: $stockId, '
        'totalInstitutionalNetBuy: $totalInstitutionalNetBuy)';
  }
}
