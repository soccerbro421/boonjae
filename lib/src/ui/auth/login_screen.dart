import 'package:boonjae/src/services/auth_service.dart';
import 'package:boonjae/src/ui/auth/auth_text_field_input.dart';
import 'package:boonjae/src/ui/auth/forgot_password_view.dart';
import 'package:boonjae/src/ui/auth/initialize_screen.dart';
import 'package:boonjae/src/ui/auth/signup_screen.dart';
import 'package:boonjae/src/ui/mobile_view.dart';
import 'package:boonjae/src/ui/widgets/user_agreement_view.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  showSnackBar(String content) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }

  goToMobile() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const InitializeScreen(
            targetWidget: MobileView(),
          ),
        ),
      );
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthService().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (res == 'success') {
      goToMobile();
    } else {
      showSnackBar(res);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignUp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Flexible(
              //   flex: 2,
              //   child: Container(),
              // ),
               const SizedBox(
                height: 300.0, // Set the desired height
                // width: 00.0, // Set the desired width

                child: 
                // Container( color: Colors.blue, child: 
                // Expanded (child: 
                  RiveAnimation.asset('assets/rive/sleepy_lottie.riv')
                // ,),
                // )
                
                
                
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(
                //       10.0), // Adjust the radius as needed
                //   child: Image.asset('assets/images/icon.png'),
                // ),
              ),
              // const SizedBox(height: 32),
              TextFieldInput(
                textEditingController: _emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 32),
              TextFieldInput(
                textEditingController: _passwordController,
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(height: 32),
              InkWell(
                onTap: loginUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    color: Color.fromARGB(49, 182, 83, 215),
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : const Text('Log in'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return const ForgotPasswordView();
                        },),);
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Color.fromARGB(255, 192, 159, 225),
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 64),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                      onTap:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return const UserAgreementView();
                        },),);
                      },
                      child: const Text(
                        
                        'By using this app, you confirm that you agree to our Terms of Service and Privacy Policy',
                        style: TextStyle(
                          color: Color.fromARGB(255, 134, 133, 135),
                          
                          // fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: const Text('Don\'t have an account?'),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: navigateToSignUp,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: const Text('Sign up'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
