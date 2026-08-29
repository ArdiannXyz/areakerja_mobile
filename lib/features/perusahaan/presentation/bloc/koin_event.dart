import 'package:equatable/equatable.dart';
import '../../data/models/koin_model.dart';

/// ─── Events ───────────────────────────────────────────────────────────────

abstract class KoinEvent extends Equatable {
  const KoinEvent();

  @override
  List<Object?> get props => [];
}

/// Muat saldo koin + paket koin sekaligus (untuk KoinPage)
class FetchKoinPageDataEvent extends KoinEvent {
  const FetchKoinPageDataEvent();
}

/// Muat saldo koin saja
class FetchKoinBalanceEvent extends KoinEvent {
  const FetchKoinBalanceEvent();
}

/// Muat daftar paket koin dari API
class FetchKoinPackagesEvent extends KoinEvent {
  const FetchKoinPackagesEvent();
}

/// Muat riwayat transaksi
class FetchTransactionHistoryEvent extends KoinEvent {
  const FetchTransactionHistoryEvent();
}

/// Muat detail transaksi
class FetchTransactionDetailEvent extends KoinEvent {
  final String transactionId;
  const FetchTransactionDetailEvent(this.transactionId);

  @override
  List<Object?> get props => [transactionId];
}

/// Buat transaksi checkout koin
class CheckoutKoinEvent extends KoinEvent {
  final String packageId;
  final String paymentChannelId;
  const CheckoutKoinEvent({
    required this.packageId,
    required this.paymentChannelId,
  });

  @override
  List<Object?> get props => [packageId, paymentChannelId];
}

class FetchKoinHistoryEvent extends KoinEvent {
  const FetchKoinHistoryEvent();
}

/// Upload bukti pembayaran
class UploadBuktiBayarEvent extends KoinEvent {
  final String transactionId;
  final String filePath;
  const UploadBuktiBayarEvent({
    required this.transactionId,
    required this.filePath,
  });

  @override
  List<Object?> get props => [transactionId, filePath];
}

/// ─── States ───────────────────────────────────────────────────────────────

abstract class KoinState extends Equatable {
  const KoinState();

  @override
  List<Object?> get props => [];
}

class KoinInitial extends KoinState {
  const KoinInitial();
}

class KoinLoading extends KoinState {
  const KoinLoading();
}

/// Data halaman koin siap (saldo + packages)
class KoinPageLoaded extends KoinState {
  final int saldoKoin;
  final List<KoinPackageModel> packages;
  const KoinPageLoaded({required this.saldoKoin, required this.packages});

  @override
  List<Object?> get props => [saldoKoin, packages];
}

class KoinBalanceLoaded extends KoinState {
  final int saldoKoin;
  const KoinBalanceLoaded(this.saldoKoin);

  @override
  List<Object?> get props => [saldoKoin];
}

class KoinPackagesLoaded extends KoinState {
  final List<KoinPackageModel> packages;
  const KoinPackagesLoaded(this.packages);

  @override
  List<Object?> get props => [packages];
}

class TransactionHistoryLoaded extends KoinState {
  final List<KoinTransactionModel> transactions;
  const TransactionHistoryLoaded(this.transactions);

  @override
  List<Object?> get props => [transactions];
}

class TransactionDetailLoaded extends KoinState {
  final KoinTransactionModel transaction;
  const TransactionDetailLoaded(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

/// Checkout berhasil — transaksi dibuat, pending pembayaran
class KoinCheckoutSuccess extends KoinState {
  final KoinTransactionModel transaction;
  const KoinCheckoutSuccess(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

/// Upload bukti berhasil
class UploadBuktiSuccess extends KoinState {
  const UploadBuktiSuccess();
}

class KoinError extends KoinState {
  final String message;
  const KoinError(this.message);

  @override
  List<Object?> get props => [message];
}
