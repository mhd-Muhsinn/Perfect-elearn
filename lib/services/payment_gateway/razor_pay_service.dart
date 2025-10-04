import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect/blocs/payment/payment_bloc.dart';
import 'package:perfect/models/course_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  static final String key = 'rzp_test_R9hX2ruIZD2i1u';
  static final Razorpay razorpay = Razorpay();

  static void dispose() {
    razorpay.clear();
  }

  static void openCheckout(BuildContext context, Course course, int amount) {
    var options = {
      'key': key,
      'amount': amount, 
      'name': 'Perfect',
      'description': course.name.toString(),
      'retry': {'enabled': false, 'max_count': 0},
      'send_sms_hash': true,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    razorpay.open(options);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
        (PaymentFailureResponse response) {
      handlePaymentErrorResponse(response, context);
    });
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
        (PaymentSuccessResponse response) {
      handlePaymentSuccessResponse(response, context,course);
    });
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
        (ExternalWalletResponse response) {
      handleExternalWalletSelected(response, context);
    });
  }

  static void handlePaymentErrorResponse(
      PaymentFailureResponse response, BuildContext context) {
  
  }

  static void handlePaymentSuccessResponse(
      PaymentSuccessResponse response, BuildContext context,Course course) {
    context.read<PaymentBloc>().add(PaymentSucceeded(course, response));
   
    razorpay.clear();
  }

  static void handleExternalWalletSelected(
      ExternalWalletResponse response, BuildContext context) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  static void showAlertDialog(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(ctx).pop(); // ✅ closes the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
