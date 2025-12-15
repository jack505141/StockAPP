import 'package:flutter/material.dart';
import '../../../data/models/stock.dart';
import '../../../data/models/strategy.dart';
import '../../../data/models/trade_plan.dart';
import '../../../domain/use_cases/trade_calculator.dart';
import '../../../core/utils/formatter.dart';
import '../../../app/theme/app_theme.dart';
import '../../widgets/loading_widget.dart';

/// Trade plan screen for creating and viewing trade plans
class TradePlanScreen extends StatefulWidget {
  final Stock stock;

  const TradePlanScreen({
    super.key,
    required this.stock,
  });

  @override
  State<TradePlanScreen> createState() => _TradePlanScreenState();
}

class _TradePlanScreenState extends State<TradePlanScreen> {
  final _investAmountController = TextEditingController(text: '100000');
  final _riskPercentController = TextEditingController(text: '2');
  
  Strategy _selectedStrategy = Strategy.getMaSupport();
  TradePlan? _tradePlan;
  bool _isCalculating = false;

  @override
  void dispose() {
    _investAmountController.dispose();
    _riskPercentController.dispose();
    super.dispose();
  }

  void _calculatePlan() {
    final investAmount = double.tryParse(_investAmountController.text) ?? 0;
    final riskPercent = double.tryParse(_riskPercentController.text) ?? 0;

    if (investAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('請輸入有效的投資金額')),
      );
      return;
    }

    if (riskPercent <= 0 || riskPercent > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('風險容忍度應介於 0.1% 至 10% 之間')),
      );
      return;
    }

    setState(() {
      _isCalculating = true;
    });

    // Simulate calculation delay
    Future.delayed(const Duration(milliseconds: 500), () {
      final plan = TradeCalculator.calculateTradePlan(
        stock: widget.stock,
        strategy: _selectedStrategy,
        investAmount: investAmount,
        riskPercent: riskPercent,
      );

      setState(() {
        _tradePlan = plan;
        _isCalculating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('建立交易計畫'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stock Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.stock.stockId} ${widget.stock.stockName}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Formatter.formatCurrency(widget.stock.currentPrice),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Strategy Selection
            Text(
              '選擇策略',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: DropdownButtonFormField<Strategy>(
                  value: _selectedStrategy,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: '策略',
                  ),
                  items: Strategy.getAllStrategies()
                      .map((strategy) => DropdownMenuItem(
                            value: strategy,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  strategy.strategyName,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  strategy.description,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedStrategy = value;
                        _tradePlan = null; // Reset plan
                      });
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Investment Parameters
            Text(
              '投資參數',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _investAmountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: '投資金額 (NT$)',
                        border: OutlineInputBorder(),
                        prefixText: 'NT\$ ',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _riskPercentController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: '風險容忍度 (%)',
                        border: OutlineInputBorder(),
                        suffixText: '%',
                        helperText: '建議範圍: 1-5%',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Calculate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isCalculating ? null : _calculatePlan,
                icon: _isCalculating
                    ? const SmallLoadingWidget()
                    : const Icon(Icons.calculate),
                label: Text(_isCalculating ? '計算中...' : '計算交易計畫'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),

            // Result Display
            if (_tradePlan != null) ...[
              const SizedBox(height: 32),
              Text(
                '計算結果',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              _buildResultCard(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    if (_tradePlan == null) return const SizedBox.shrink();

    final plan = _tradePlan!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResultRow(
              '建議買入價',
              Formatter.formatCurrency(plan.suggestedBuyPrice),
              Colors.blue,
            ),
            const Divider(height: 24),
            _buildResultRow(
              '止損價',
              Formatter.formatCurrency(plan.stopLossPrice),
              AppTheme.negativeColor,
            ),
            const Divider(height: 24),
            _buildTakeProfitSection(plan),
            const Divider(height: 24),
            _buildResultRow(
              '可買張數',
              Formatter.formatShares(plan.maxShares),
              Colors.black,
            ),
            const Divider(height: 24),
            _buildResultRow(
              '總成本',
              Formatter.formatCurrency(plan.totalCost),
              Colors.black,
            ),
            const Divider(height: 24),
            _buildResultRow(
              '風險金額',
              Formatter.formatCurrency(plan.riskAmount),
              AppTheme.negativeColor,
            ),
            const Divider(height: 24),
            _buildResultRow(
              '風險報酬比',
              Formatter.formatRiskRewardRatio(plan.riskRewardRatio),
              AppTheme.positiveColor,
            ),
            const Divider(height: 24),
            _buildResultRow(
              '預期報酬',
              Formatter.formatPercent(plan.expectedReturn),
              AppTheme.positiveColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, Color? valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
        ),
      ],
    );
  }

  Widget _buildTakeProfitSection(TradePlan plan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '停利目標',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ...plan.takeProfitPrices.asMap().entries.map((entry) {
          final index = entry.key;
          final price = entry.value;
          final percent = ((price - plan.suggestedBuyPrice) / 
                          plan.suggestedBuyPrice) * 100;
          
          return Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '停利${index + 1}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  '${Formatter.formatCurrency(price)} (${Formatter.formatPercent(percent)})',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.positiveColor,
                      ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
