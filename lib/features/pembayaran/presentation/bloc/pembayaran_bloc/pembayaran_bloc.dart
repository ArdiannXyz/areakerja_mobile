import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/pembayaran_model.dart';
import '../../../data/repositories/pembayaran_repository_impl.dart';

// =========================================================================
// EVENTS
// =========================================================================

abstract class PembayaranEvent extends Equatable {
  const PembayaranEvent();

  @override
  List<Object?> get props => [];
}

class FetchPaymentChannelsEvent extends PembayaranEvent {
  const FetchPaymentChannelsEvent();
}

class CheckoutPembayaranEvent extends PembayaranEvent {
  final String divisiId;
  final String paymentChannelId;

  const CheckoutPembayaranEvent({
    required this.divisiId,
    required this.paymentChannelId,
  });

  @override
  List<Object?> get props => [divisiId, paymentChannelId];
}

class FetchDetailTransaksiEvent extends PembayaranEvent {
  final String transactionId;

  const FetchDetailTransaksiEvent(this.transactionId);

  @override
  List<Object?> get props => [transactionId];
}

class UploadBuktiBayarEvent extends PembayaranEvent {
  final String transactionId;
  final String filePath;
  final String fileName;

  const UploadBuktiBayarEvent({
    required this.transactionId,
    required this.filePath,
    required this.fileName,
  });

  @override
  List<Object?> get props => [transactionId, filePath, fileName];
}

// =========================================================================
// STATES
// =========================================================================

abstract class PembayaranState extends Equatable {
  const PembayaranState();

  @override
  List<Object?> get props => [];
}

class PembayaranInitial extends PembayaranState {
  const PembayaranInitial();
}

class PembayaranLoading extends PembayaranState {
  const PembayaranLoading();
}

class PaymentChannelsLoaded extends PembayaranState {
  final List<MetodePembayaranModel> channels;

  const PaymentChannelsLoaded(this.channels);

  @override
  List<Object?> get props => [channels];
}

class CheckoutSuccess extends PembayaranState {
  final PembayaranModel pembayaran;

  const CheckoutSuccess(this.pembayaran);

  @override
  List<Object?> get props => [pembayaran];
}

class DetailTransaksiLoaded extends PembayaranState {
  final PembayaranModel pembayaran;

  const DetailTransaksiLoaded(this.pembayaran);

  @override
  List<Object?> get props => [pembayaran];
}

class UploadBuktiSuccess extends PembayaranState {
  final String message;

  const UploadBuktiSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class PembayaranError extends PembayaranState {
  final String message;

  const PembayaranError(this.message);

  @override
  List<Object?> get props => [message];
}

// =========================================================================
// BLOC
// =========================================================================

class PembayaranBloc extends Bloc<PembayaranEvent, PembayaranState> {
  final PembayaranRepository _repository;

  PembayaranBloc({required PembayaranRepository repository})
      : _repository = repository,
        super(const PembayaranInitial()) {
    on<FetchPaymentChannelsEvent>(_onFetchPaymentChannels);
    on<CheckoutPembayaranEvent>(_onCheckout);
    on<FetchDetailTransaksiEvent>(_onFetchDetailTransaksi);
    on<UploadBuktiBayarEvent>(_onUploadBukti);
  }

  Future<void> _onFetchPaymentChannels(
    FetchPaymentChannelsEvent event,
    Emitter<PembayaranState> emit,
  ) async {
    emit(const PembayaranLoading());
    final result = await _repository.getPaymentChannels();
    result.fold(
      (failure) => emit(PembayaranError(failure.message)),
      (channels) => emit(PaymentChannelsLoaded(channels)),
    );
  }

  Future<void> _onCheckout(
    CheckoutPembayaranEvent event,
    Emitter<PembayaranState> emit,
  ) async {
    emit(const PembayaranLoading());
    final result = await _repository.checkout(
      divisiId: event.divisiId,
      paymentChannelId: event.paymentChannelId,
    );
    result.fold(
      (failure) => emit(PembayaranError(failure.message)),
      (pembayaran) => emit(CheckoutSuccess(pembayaran)),
    );
  }

  Future<void> _onFetchDetailTransaksi(
    FetchDetailTransaksiEvent event,
    Emitter<PembayaranState> emit,
  ) async {
    emit(const PembayaranLoading());
    final result = await _repository.getDetailTransaksi(event.transactionId);
    result.fold(
      (failure) => emit(PembayaranError(failure.message)),
      (pembayaran) => emit(DetailTransaksiLoaded(pembayaran)),
    );
  }

  Future<void> _onUploadBukti(
    UploadBuktiBayarEvent event,
    Emitter<PembayaranState> emit,
  ) async {
    emit(const PembayaranLoading());
    final result = await _repository.uploadBuktiBayar(
      transactionId: event.transactionId,
      filePath: event.filePath,
      fileName: event.fileName,
    );
    result.fold(
      (failure) => emit(PembayaranError(failure.message)),
      (message) => emit(UploadBuktiSuccess(message)),
    );
  }
}
