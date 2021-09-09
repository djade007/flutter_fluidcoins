class FluidResponse {
  final String coin;
  final num amount;
  final String paymentStatus;
  final String reference;
  final String error;

  bool get hasError => error.isNotEmpty;

  bool get isUnderPaid => paymentStatus == 'underpaid';

  bool get isOverPaid => paymentStatus == 'overpaid';

  bool get isPaidInFull => paymentStatus == 'paid_in_full';

  const FluidResponse({
    this.coin: '',
    this.amount: 0,
    this.paymentStatus: '',
    this.reference: '',
    this.error: '',
  });

  factory FluidResponse.fromJson(Map<String, dynamic> data) {
    return FluidResponse(
      coin: data['coin'] ?? '',
      amount: data['human_readable_amount'] ?? 0,
      paymentStatus: data['payment_status'] ?? '',
      reference: data['reference'],
    );
  }

  factory FluidResponse.error(String type) {
    return FluidResponse(
      error: type,
    );
  }
}
