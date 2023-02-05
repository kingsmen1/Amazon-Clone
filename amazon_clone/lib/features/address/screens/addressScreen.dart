import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_textField.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/address/services/addressServices.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const routeName = '/address-screen';
  final String sum;
  const AddressScreen({super.key, required this.sum});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController _flatBuildingController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final _addressFormKey = GlobalKey<FormState>();
  final AddressServices addressServices = AddressServices();
  List<PaymentItem> paymentItems = [];
  String addressToBeUsed = '';

  @override
  void initState() {
    super.initState();
    paymentItems.add(PaymentItem(
        amount: widget.sum,
        label: 'Total Amount',
        status: PaymentItemStatus.final_price));
  }

  @override
  void dispose() {
    super.dispose();
    _flatBuildingController.dispose();
    _areaController.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
  }

  void onApplePayResult(res) {}
  void onGooglePayResult(res) {
    if (context.read<UserProvider>().user.address.isEmpty) {
      addressServices.addAddress(context, address: addressToBeUsed);
    }
    addressServices.placeOrder(context,
        address: addressToBeUsed, totalSum: double.parse(widget.sum));
  }

  void payPressed(String addressFromProvider) {
    addressToBeUsed = '';
    bool isFormEmpty = _flatBuildingController.text.isNotEmpty ||
        _areaController.text.isNotEmpty ||
        _pincodeController.text.isNotEmpty ||
        _cityController.text.isNotEmpty;

    if (isFormEmpty) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            '${_flatBuildingController.text}, ${_areaController.text}, ${_cityController.text} -${_pincodeController.text} ';
        return;
      } else {
        throw Exception('Please enter all the values');
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    } else {
      showSnackbar(context, 'Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String address = context.watch<UserProvider>().user.address;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: GlobalVariables.appBarGradient)),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              key: _addressFormKey,
              child: Column(
                children: [
                  if (address.isNotEmpty)
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12)),
                          child: Text(
                            address,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'OR',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  CustomTextField(
                    controller: _flatBuildingController,
                    hintText: 'Flat, House no, Building',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: _areaController,
                    hintText: 'Area Street',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: _pincodeController,
                    hintText: 'Pincode',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: _cityController,
                    hintText: 'Town/City',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //~Adding payment's
                  ApplePayButton(
                      margin: const EdgeInsets.only(top: 25),
                      width: double.infinity,
                      height: 50,
                      style: ApplePayButtonStyle.white,
                      type: ApplePayButtonType.buy,
                      paymentConfigurationAsset: 'applepay.json',
                      onPaymentResult: onApplePayResult,
                      paymentItems: paymentItems),
                  GooglePayButton(
                    onPressed: () => payPressed(address),
                    margin: const EdgeInsets.only(top: 25),
                    width: double.infinity,
                    height: 50,
                    type: GooglePayButtonType.buy,
                    paymentConfigurationAsset: 'gpay.json',
                    onPaymentResult: onGooglePayResult,
                    paymentItems: paymentItems,
                    loadingIndicator: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
