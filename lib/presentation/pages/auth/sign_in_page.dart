import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hub_dom/presentation/widgets/k_textfield.dart';
import 'package:hub_dom/presentation/widgets/buttons/main_btn.dart';
import 'package:hub_dom/presentation/widgets/textfield_title.dart';
import 'package:hub_dom/core/constants/strings/app_strings.dart';
import 'package:hub_dom/presentation/widgets/main_logo_widget.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _phoneCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _phoneCtrl.addListener(() {
      setState(() {}); // rebuilds the widget whenever text changes
    });
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  bool validate() {
    bool isValid = formKey.currentState?.validate() ?? false;

    return isValid;
  }

  bool isDisableBtn(){
    if (_phoneCtrl.text.length == 10) {
      return false;
    } else {
      return true;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(alignment: Alignment.center, child: MainLogoWidget()),
                SizedBox(height: 40),

                Text(
                  AppStrings.signIn,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 40),
                Form(
                  key: formKey,
                  child: TextFieldTitle(
                    title: AppStrings.phoneNumber,
                    child: PhoneNumField(
                      phoneCtrl: _phoneCtrl,
                      isSubmitted: false,
                      hint: AppStrings.phoneHintText,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodySmall,
                    children: [
                      const TextSpan(text: "Продолжая, Вы соглашаетесь на "),
                      TextSpan(
                        text: "обработку персональных данных",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          decoration: TextDecoration.underline,
                          decorationThickness: 1.5,
                        ),
                        // Add tap gesture if needed
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("Персональные данные tapped");
                          },
                      ),
                      const TextSpan(text: " и с "),
                      TextSpan(
                        text: "политикой конфиденциальности",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          decoration: TextDecoration.underline,
                          decorationThickness: 1.5,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("Политика конфиденциальности tapped");
                          },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                MainButton(
                  buttonTile: AppStrings.login,
                  onPressed: () {},
                  isLoading: false,
                  isDisable: isDisableBtn(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
