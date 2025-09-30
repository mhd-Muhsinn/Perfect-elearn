import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:perfect/models/course_model.dart';
import 'package:perfect/services/razor_pay_service.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentInitial()) {
    on<StartPayment>(_onStartPayment);
    on<PaymentSucceeded>(_onPaymentSucceeded);
    on<PaymentFailed>(_onPaymentFailed);
  }

  void _onStartPayment(StartPayment event, Emitter<PaymentState> emit) async {
    emit(PaymentInProgress());
    try {
      RazorpayService.openCheckout(event.context, event.course, int.parse(event.course.price));
    } catch (e) {
      emit(PaymentFailure(-1, "Payment Failed", e.toString()));
      RazorpayService.dispose();
    }
  }

  Future<void> _onPaymentSucceeded(
      PaymentSucceeded event, Emitter<PaymentState> emit) async {
    print('''scuessssss''');
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'myCourses': FieldValue.arrayUnion([event.course.id])
      });
    }
    
    emit(PaymentSuccess(event.response.paymentId ?? ''));
    RazorpayService.dispose();
  }

  void _onPaymentFailed(PaymentFailed event, Emitter<PaymentState> emit) {
    emit(PaymentFailure(event.code, event.description, event.metadata));
    RazorpayService.dispose();
  }
}
