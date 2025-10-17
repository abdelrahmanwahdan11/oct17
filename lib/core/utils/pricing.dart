double calculatePrice({required int days, required double unitPrice}) {
  if (days <= 0) return 0;
  return days * unitPrice;
}
