import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/utils/app_scope.dart';

class PlaceBidSheet extends StatefulWidget {
  const PlaceBidSheet({super.key, required this.auctionId, this.mode});

  final String auctionId;
  final String? mode;

  @override
  State<PlaceBidSheet> createState() => _PlaceBidSheetState();
}

class _PlaceBidSheetState extends State<PlaceBidSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _autoController = TextEditingController();
  bool _loading = false;
  double? _minAcceptable;

  @override
  void dispose() {
    _amountController.dispose();
    _autoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final controller = AppScope.of(context).auctionsController;
    controller.getById(widget.auctionId).then((auction) {
      if (!mounted || auction == null) return;
      setState(() {
        _minAcceptable = auction.currentBid + auction.minIncrement;
        _amountController.text = _minAcceptable!.toStringAsFixed(0);
      });
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_minAcceptable == null) return;
    final amount = double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;
    final autoMax = widget.mode == 'auto'
        ? double.tryParse(_autoController.text.replaceAll(',', ''))
        : null;
    final deps = AppScope.of(context);
    setState(() => _loading = true);
    final updated = await deps.auctionsController.placeBid(
      auctionId: widget.auctionId,
      amount: amount,
      autoMax: autoMax,
    );
    setState(() => _loading = false);
    if (!mounted) return;
    Navigator.of(context).pop(updated);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).t('auctions.bidPlaced'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final minAcceptable = _minAcceptable;
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(strings.t('auctions.placeBid'), style: Theme.of(context).textTheme.titleLarge),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: strings.t('auctions.currentBid'),
                    helperText: minAcceptable == null
                        ? strings.t('general.loading')
                        : '${strings.t('auctions.minIncrement')}: ${minAcceptable.toStringAsFixed(0)}',
                  ),
                  validator: (value) {
                    if (minAcceptable == null) return strings.t('general.loading');
                    final parsed = double.tryParse(value ?? '');
                    if (parsed == null || parsed < minAcceptable) {
                      return '>= ${minAcceptable.toStringAsFixed(0)}';
                    }
                    return null;
                  },
                ),
                if (widget.mode == 'auto') ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _autoController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Auto max'),
                    validator: (value) {
                      if (minAcceptable == null) return strings.t('general.loading');
                      final parsed = double.tryParse(value ?? '');
                      if (parsed == null || parsed < (double.tryParse(_amountController.text) ?? 0)) {
                        return '>= bid';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    child: _loading
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(strings.t('auth.confirm')),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: _loading ? null : () => Navigator.of(context).pop(),
                    child: Text(strings.t('general.cancel')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
