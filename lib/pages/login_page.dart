import 'package:app_resep_makanan/pages/create_acc.dart';
import 'package:app_resep_makanan/pages/landing_page.dart';
import 'package:app_resep_makanan/services/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatelessWidget {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: const Color(0xFFFFFFFF),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SizedBox(
                  height: 100,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LandingPage()
                          )
                        );
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF70B9BE),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  'Masuk ke akun anda yang sudah anda buat',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: const Color(0xFF111827).withOpacity(0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 60),
              // Email Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'example@gmail.com',
                          hintStyle: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Color(0xFF9CA3B0),
                          )),
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Color(0xFF9CA3B0),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Password Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF9FAFB),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none),
                        hintText: 'Masukkan password anda',
                        hintStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Color(0xFF9CA3B0),
                        ),
                      ),
                      obscureText: true,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Color(0xFF9CA3B0),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Lupa password',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          color: Color(0xFF3C83F6),
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFF3C83F6),
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    //BUTTON SIGN IN
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                        onPressed: () async {
                          await AuthService().signIn(context: context, email: _emailController.text, password: _passwordController.text);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF70B9BE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Color(0xFFF3F4F6),
                              thickness: 2,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Atau login menggunakan',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Color(0xFFF3F4F6),
                              thickness: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFF3F4F6),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: IconButton(
                            onPressed: () {
                              AuthService().handleGoogleSignIn(context: context);
                            },
                            icon: SvgPicture.asset(
                              'assets/icons/google_icon.svg',
                              width: 20,
                              height: 20,
                            ),
                            iconSize: 60,
                            padding: const EdgeInsets.all(16),
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 35),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'Belum punya akun? ',
                            ),
                            //INI BUAT PINDAH KE HALAMAN BUAT AKUN
                            TextSpan(
                              text: 'Daftar',
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                color: Color(0xFF3C83F6),
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFF3C83F6),
                              ),
                              recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateAcc(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
