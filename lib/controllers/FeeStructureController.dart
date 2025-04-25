// Create fee_structure_controller.dart
import 'package:get/get.dart';
import '../models/fee_stucture.dart';
import '../repositories/fee_repository.dart';

class FeeStructureController extends GetxController {
  final FeeRepository _repo = FeeRepository();
  final RxList<FeeStructure> feeStructures = <FeeStructure>[].obs;
  final RxBool isLoading = false.obs;
  final RxString currentFilter = 'All'.obs;

  @override
  void onInit() {
    fetchFeeStructures();
    super.onInit();
  }

  Future<void> fetchFeeStructures({String? classFilter, String? feeTypeFilter}) async {
    try {
      isLoading.value = true;
      feeStructures.value = await _repo.getFeeStructures(
        classFilter: classFilter,
        feeTypeFilter: feeTypeFilter,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load fee structures: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addFeeStructure(FeeStructure fee) async {
    try {
      isLoading.value = true;
      await _repo.addFeeStructure(fee);
      await fetchFeeStructures();
      Get.snackbar('Success', 'Fee structure added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add fee structure: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleStatus(String id, bool isActive) async {
    try {
      await _repo.toggleFeeStructureStatus(id, !isActive);
      await fetchFeeStructures();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update status: ${e.toString()}');
    }
  }
}