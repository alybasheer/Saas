import 'package:get/get.dart';
import '../repositories/payment_repository.dart';
import 'auth_controller.dart';

class PaymentController extends GetxController {
  final PaymentRepository _repo = PaymentRepository();
  final RxList<Map<String, dynamic>> payments = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  /// Submit a payment and refresh payment history
  Future<void> submitPayment({
    required double amount,
    required String method,
    required String studentName,
    required String className,
  }) async {
    final userId = Get.find<AuthController>().user.value?.uid;

    if (userId == null || userId.isEmpty) {
      Get.snackbar('Error', 'User not logged in');
      return;
    }

    try {
      isLoading.value = true;
      await _repo.submitPayment(
        userId: userId,
        amount: amount,
        method: method,
        studentName: studentName,
        className: className,
      );
      await fetchPayments();
      Get.snackbar('Success', 'Payment submitted!',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Payment failed: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Load payments for current user
  Future<void> fetchPayments() async {
    final userId = Get.find<AuthController>().user.value?.uid;

    if (userId == null || userId.isEmpty) {
      payments.clear();
      return;
    }

    try {
      isLoading.value = true;
      payments.value = await _repo.getPayments(userId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load payments: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> fetchAllPayments({String? className, String? studentName}) async {
    try {
      isLoading.value = true;
      payments.value = await _repo.getAllPayments(
        className: className,
        studentName: studentName,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load payments: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
