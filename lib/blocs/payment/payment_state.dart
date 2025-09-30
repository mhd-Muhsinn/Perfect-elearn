part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();
  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentInProgress extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final String paymentId;
  const PaymentSuccess(this.paymentId);
}

class PaymentFailure extends PaymentState {
  final int code;
  final String description;
  final String metadata;
  const PaymentFailure(this.code, this.description, this.metadata);
}
