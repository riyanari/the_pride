import 'package:flutter/material.dart';
import 'package:the_pride/components/half_circle_painter.dart' show HalfCirclePainter;
import 'package:the_pride/theme/theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getInit();
      // checkForUpdate();
    });
  }

  Future<void> getInit() async {
    // Simulasi loading 2 detik
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    // Pindah ke halaman login, hapus splash dari stack
    Navigator.of(context).pushReplacementNamed('/login');
  }


  // void showSnackBar(BuildContext context, String message) {
  //   // Cetak pesan ke console untuk debugging
  //   log('SnackBar Message: $message');
  //
  //   final snackBar = SnackBar(
  //     content: Text(message),
  //     behavior: SnackBarBehavior.floating,
  //     margin: EdgeInsets.only(bottom: 100, left: 20, right: 20),
  //   );
  //
  //   if (mounted) {
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   }
  // }
  //
  // Future<void> checkForUpdate() async {
  //   if (kDebugMode) {
  //     log('Skipping update check in debug mode');
  //     return;
  //   }
  //
  //   try {
  //     final updateInfo = await InAppUpdate.checkForUpdate();
  //     log('Update info: ${updateInfo.toString()}');
  //
  //     if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
  //       log('Update available, starting update...');
  //       await update();
  //     } else {
  //       log('No update available');
  //     }
  //   } catch (e) {
  //     log('Error checking for update: $e', error: e);
  //     if (mounted) {
  //       showSnackBar(context, 'Error checking update: ${e.toString()}');
  //     }
  //   }
  // }

  // Future<void> update() async {
  //   try {
  //     log('Starting flexible update...');
  //     final result = await InAppUpdate.startFlexibleUpdate();
  //     log('Update result: $result');
  //
  //     if (result == AppUpdateResult.success) {
  //       log('Completing update...');
  //       await InAppUpdate.completeFlexibleUpdate();
  //       if (mounted) {
  //         showSnackBar(context, "Update completed successfully");
  //       }
  //     } else {
  //       if (mounted) {
  //         showSnackBar(context, "Update failed with result: $result");
  //       }
  //     }
  //   } catch (e) {
  //     log('Error during update: $e', error: e);
  //     if (mounted) {
  //       showSnackBar(context, 'Update error: ${e.toString()}');
  //     }
  //   }
  // }

  // Future<void> getInit() async {
  //   try {
  //     log('Initializing app data...');
  //     await Future.wait([
  //       Provider.of<SemesterProvider>(context, listen: false).fetchSemester(),
  //       Provider.of<NomorKelasProvider>(context, listen: false).fetchNomorKelas(),
  //       Provider.of<TipeKelasProvider>(context, listen: false).fetchTipeKelas(),
  //       Provider.of<KelasProvider>(context, listen: false).getKelasUserNotNull(),
  //       Provider.of<GuruPengampuProvider>(context, listen: false).fetchGuruPengampu(),
  //       Provider.of<MataPelajaranProvider>(context, listen: false).fetchMataPelajaran(),
  //       Provider.of<HafalanProvider>(context, listen: false).getHafalan(),
  //     ]);
  //
  //     log('Attempting auto login...');
  //     bool autoLoginSuccess =
  //     await Provider.of<AuthProvider>(context, listen: false).tryAutoLogin();
  //
  //     if (!mounted) return;
  //
  //     if (autoLoginSuccess) {
  //       log('Auto login successful, navigating to home');
  //       Navigator.pushReplacementNamed(context, '/home');
  //     } else {
  //       log('Auto login failed, navigating to login');
  //       Navigator.pushReplacementNamed(context, '/login');
  //     }
  //   } catch (e) {
  //     log('Error during initialization: $e', error: e);
  //     if (!mounted) return;
  //     showSnackBar(context, 'Failed to load data: ${e.toString()}');
  //     Navigator.pushReplacementNamed(context, '/login');
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundPrimaryColor,
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/img_background_buble.png',
          //     fit: BoxFit.fill,
          //     color: const Color(0xffB8FFD8).withValues(alpha: 0.7),
          //   ),
          // ),
          Positioned(
            top: 90,
            right: -50,
            child: CustomPaint(
              size: const Size(100, 100),
              painter: HalfCirclePainter(
                  color: kBoxGreyColor.withValues(alpha: 0.1)), // Gunakan painter yang telah Anda buat
            ),
          ),
          Positioned(
            top: -30,
            right: -75,
            child: CustomPaint(
              size: const Size(100, 100),
              painter: HalfCirclePainter(
                  color: kBoxGreyColor.withValues(alpha: 0.15))), // Gunakan painter yang telah Anda buat
            ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Image.asset('assets/the_pride_logo.png', height: 300,),
                Spacer(),
                const CircularProgressIndicator(
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation<Color>(kBoxGreyColor),
                  backgroundColor: kSecondaryColor,
                  semanticsLabel: 'Loading...',
                ),
                const SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
