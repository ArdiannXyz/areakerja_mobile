import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/perusahaan_repository_impl.dart';
import '../../data/models/koin_model.dart';
import 'koin_event.dart';

export 'koin_event.dart';

class KoinBloc extends Bloc<KoinEvent, KoinState> {
  final PerusahaanRepository _repository;

  KoinBloc({required PerusahaanRepository repository})
      : _repository = repository,
        super(const KoinInitial()) {
    on<FetchKoinPageDataEvent>(_onFetchKoinPageData);
    on<FetchKoinBalanceEvent>(_onFetchKoinBalance);
    on<FetchKoinPackagesEvent>(_onFetchKoinPackages);
    on<FetchTransactionHistoryEvent>(_onFetchTransactionHistory);
    on<FetchTransactionDetailEvent>(_onFetchTransactionDetail);
    on<CheckoutKoinEvent>(_onCheckoutKoin);
    on<UploadBuktiBayarEvent>(_onUploadBuktiBayar);
  }

  /// Muat saldo + paket sekaligus untuk halaman utama Koin
  Future<void> _onFetchKoinPageData(
    FetchKoinPageDataEvent event,
    Emitter<KoinState> emit,
  ) async {
    emit(const KoinLoading());
    final balanceResult = await _repository.getKoinBalance();
    final packagesResult = await _repository.getKoinPackages();

    final saldo = balanceResult.fold((_) => 0, (v) => v);
    final packages = packagesResult.fold((_) => <KoinPackageModel>[], (v) => v);

    emit(KoinPageLoaded(saldoKoin: saldo, packages: packages));
  }

  Future<void> _onFetchKoinBalance(
    FetchKoinBalanceEvent event,
    Emitter<KoinState> emit,
  ) async {
    final result = await _repository.getKoinBalance();
    result.fold(
      (failure) => emit(KoinError(failure.message)),
      (balance) => emit(KoinBalanceLoaded(balance)),
    );
  }

  Future<void> _onFetchKoinPackages(
    FetchKoinPackagesEvent event,
    Emitter<KoinState> emit,
  ) async {
    emit(const KoinLoading());
    final result = await _repository.getKoinPackages();
    result.fold(
      (failure) => emit(KoinError(failure.message)),
      (packages) => emit(KoinPackagesLoaded(packages)),
    );
  }

  Future<void> _onFetchTransactionHistory(
    FetchTransactionHistoryEvent event,
    Emitter<KoinState> emit,
  ) async {
    emit(const KoinLoading());
    final result = await _repository.getTransactionHistory();
    result.fold(
      (failure) => emit(KoinError(failure.message)),
      (transactions) => emit(TransactionHistoryLoaded(transactions)),
    );
  }

  Future<void> _onFetchTransactionDetail(
    FetchTransactionDetailEvent event,
    Emitter<KoinState> emit,
  ) async {
    emit(const KoinLoading());
    final result = await _repository.getTransactionDetail(event.transactionId);
    result.fold(
      (failure) => emit(KoinError(failure.message)),
      (transaction) => emit(TransactionDetailLoaded(transaction)),
    );
  }

  Future<void> _onCheckoutKoin(
    CheckoutKoinEvent event,
    Emitter<KoinState> emit,
  ) async {
    emit(const KoinLoading());
    final result = await _repository.checkoutKoin(
      packageId: event.packageId,
      paymentChannelId: event.paymentChannelId,
    );
    result.fold(
      (failure) => emit(KoinError(failure.message)),
      (transaction) => emit(KoinCheckoutSuccess(transaction)),
    );
  }

  Future<void> _onUploadBuktiBayar(
    UploadBuktiBayarEvent event,
    Emitter<KoinState> emit,
  ) async {
    emit(const KoinLoading());
    final result = await _repository.uploadBuktiBayar(
      transactionId: event.transactionId,
      filePath: event.filePath,
    );
    result.fold(
      (failure) => emit(KoinError(failure.message)),
      (_) => emit(const UploadBuktiSuccess()),
    );
  }
}
