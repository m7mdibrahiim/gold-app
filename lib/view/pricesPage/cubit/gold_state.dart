// States for Cubit
abstract class GoldState {}

class GoldInitial extends GoldState {}

class GoldLoading extends GoldState {}

class GoldLoaded extends GoldState {
  final double gold24k;
  final double gold22k;
  final double gold21k;
  final double gold18k;
  final double usdToEgpRate; // New state to store USD to EGP exchange rate
  final double goldPricePerGramEGP; // New state to store the gold price per gram in EGP

  GoldLoaded(this.gold24k, this.gold22k, this.gold21k, this.gold18k, this.usdToEgpRate, this.goldPricePerGramEGP);
}

class GoldError extends GoldState {
  final String message;
  GoldError(this.message);
}