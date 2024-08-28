import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:recipe_app/ui/screens/splash/onboarding_screen.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: 860,
          decoration: BoxDecoration(
            color: Color.fromRGBO(63, 180, 177, 1),
            image: DecorationImage(
              image: AssetImage('assets/images/background_welcome.png'),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Gap(240),
              Image.asset(
                'assets/images/logo.png',
                color: Colors.white,
                width: 234,
                height: 234,
              ),
              Text(
                'Meals On\n Demand',
                style: TextStyle(
                    height: 1,
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) {
                        return SplashScreen2();
                      },
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  width: 209,
                  height: 60,
                  child: Center(
                    child: Text(
                      'Let’s start',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Gap(80),
            ],
          ),
        ),
      ),
    );
  }
}
