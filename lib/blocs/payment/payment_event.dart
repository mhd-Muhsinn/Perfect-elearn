part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
  @override
  List<Object?> get props => [];
}

class StartPayment extends PaymentEvent {
  final BuildContext context;
  final Course course;
  const StartPayment(this.context, this.course);
}

class PaymentSucceeded extends PaymentEvent {
  final Course course;
  final PaymentSuccessResponse response;
  const PaymentSucceeded(this.course, this.response);
}

class PaymentFailed extends PaymentEvent {
  final int code;
  final String description;
  final String metadata;
  const PaymentFailed(this.code, this.description, this.metadata);
}
