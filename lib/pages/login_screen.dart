import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'shop/shop_show_screen.dart';
import '../providers/auth_provider.dart';
import '../../components/elements/my_text_form_field.dart';
import '../../components/elements/progress_hud.dart';
import '../../utility_methods.dart';

class LoginScreen extends StatefulWidget {
  final String? error;
  const LoginScreen({Key? key, this.error}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;

    double viewInsets = MediaQuery.of(context).viewInsets.bottom;

    return Consumer<AuthProvider>(
      builder: (BuildContext context, state, child) {
        if (state.isAuthenticated) {
          return const ShopShowScreen();
        } else {
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFfdd023),
              body: ProgressHUD(
                inAsyncCall: _isLoading,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      constraints: const BoxConstraints.expand(),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          repeat: ImageRepeat.noRepeat,
                          image: AssetImage("assets/images/login_screen.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: viewInsets > 0.0 ? 160 : 310,
                      child: SizedBox(
                        width: 300.0,
                        height: 330.0,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.errorMessage ?? '',
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                localizations.username,
                                style: kTextStyle(size: 16.0).copyWith(
                                  color: const Color(0xFF2f2f30),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              MyTextFormField(
                                controller: _usernameController,
                                decoration: kInputDecoration,
                                validator: (String? value) {
                                  if (value!.trim().isEmpty) {
                                    return localizations.enter_username;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                localizations.password,
                                style: kTextStyle(size: 16.0).copyWith(
                                  color: const Color(0xFF2f2f30),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              MyTextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: kInputDecoration,
                                validator: (String? value) {
                                  if (value!.trim().isEmpty) {
                                    return localizations.enter_password;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20.0),
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFF2f2f30),
                                    shape: kRoundedRectangleBorder,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 30,
                                    ),
                                  ),
                                  child: Text(
                                    localizations.login,
                                    style: kTextStyle(size: 16.0).copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _isLoading = true;
                                      });

                                      context.read<AuthProvider>().login({
                                        'email': _usernameController.text,
                                        'password': _passwordController.text,
                                      });

                                      if (state.isAuthenticated) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ShopShowScreen(),
                                          ),
                                        );
                                      }

                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
