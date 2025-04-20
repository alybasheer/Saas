import 'package:get/get.dart';
import '../repositories/payment_repository.dart';
import 'auth_controller.dart';

class PaymentController extends GetxController {
  final PaymentRepository _repo = PaymentRepository();
  final RxList<Map<String, dynamic>> payments = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  // Submit payment (atomic operation)
  Future<void> submitPayment({
    required double amount,
    required String method,
  }) async {
    try {
      isLoading.value = true;
      final userId = Get.find<AuthController>().user.value?.uid ?? '';
      await _repo.submitPayment(
        userId: userId,
        amount: amount,
        method: method,
      );
      await fetchPayments();
      Get.snackbar('Success', 'Payment submitted!');
    } catch (e) {
      Get.snackbar('Error', 'Payment failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch payments (non-blocking)
  Future<void> fetchPayments() async {
    try {
      isLoading.value = true;
      final userId = Get.find<AuthController>().user.value?.uid ?? '';
      payments.value = await _repo.getPayments(userId);
    } finally {
      isLoading.value = false;
    }
  }
}