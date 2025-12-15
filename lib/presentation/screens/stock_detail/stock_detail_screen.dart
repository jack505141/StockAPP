import 'package:flutter/material.dart';
import '../../../data/models/stock.dart';
import '../../../data/repositories/stock_repository.dart';
import '../../../app/routes/app_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/utils/formatter.dart';
import '../../widgets/loading_widget.dart';

/// Stock detail screen showing detailed stock information
class StockDetailScreen extends StatefulWidget {
  final Stock stock;

  const StockDetailScreen({
    super.key,
    required this.stock,
  });

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  final StockRepository _repository = StockRepository();
  late Stock _stock;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _stock = widget.stock;
  }

  Future<void> _refreshStock() async {
    setState(() {
      _isRefreshing = true;
    });

    try {
      final updatedStock = await _repository.refreshStockData(_stock);
      setState(() {
        _stock = updatedStock;
        _isRefreshing = false;
      });
    } catch (e) {
      setState(() {
        _isRefreshing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('更新失敗: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final changeColor = AppTheme.getChangeColor(_stock.changePrice);

    return Scaffold(
      appBar: AppBar(
        title: Text('${_stock.stockId} ${_stock.stockName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _refreshStock,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshStock,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Price Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '現價',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            Formatter.formatCurrency(_stock.currentPrice),
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(width: 16),
                          if (_isRefreshing)
                            const SmallLoadingWidget()
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Formatter.formatChange(_stock.changePrice),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: changeColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                Text(
                                  Formatter.formatPercent(_stock.changePercent),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: changeColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Market Data Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '市場資訊',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow('開盤', Formatter.formatCurrency(_stock.open)),
                      const Divider(),
                      _buildInfoRow('最高', Formatter.formatCurrency(_stock.high)),
                      const Divider(),
                      _buildInfoRow('最低', Formatter.formatCurrency(_stock.low)),
                      const Divider(),
                      _buildInfoRow('昨收', Formatter.formatCurrency(_stock.yesterdayClose)),
                      const Divider(),
                      _buildInfoRow('成交量', '${Formatter.formatVolume(_stock.volume)}張'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Update Time
              Center(
                child: Text(
                  '更新時間: ${Formatter.formatDateTime(_stock.updateTime)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
              ),

              const SizedBox(height: 24),

              // Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => AppRouter.goToTradePlan(context, _stock),
                  icon: const Icon(Icons.analytics),
                  label: const Text('建立交易計畫'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
