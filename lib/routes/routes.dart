
import 'package:get/get.dart';
import 'package:school_management/controllers/auth_controller.dart';
import 'package:school_management/screens/create_note_screen.dart';
import 'package:school_management/screens/sign_in_screen.dart';
import 'package:school_management/screens/sign_up_screen.dart';
import 'package:school_management/widgets/menu_bar.dart';

class AppRoutes {
  static const String signUpScreen = '/sign-up-screen';
  static const String signInScreen = '/sign-in-screen';
  static const String createNoteScreen = '/create-note-screen';
  static const String authPage = '/auth-page';
  static const String floatingMenu = '/floating-menu';



  static final routes = [
    GetPage(
      name: signUpScreen,
      page: () {
        return const SignUpScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: signInScreen,
      page: () {
        return const SignInScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: createNoteScreen,
      page: () {
        return const CreateNoteScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: authPage,
      page: () {
        return const AuthPage();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: floatingMenu,
      page: () {
        return const FloatingBar();
      },
      transition: Transition.fadeIn,
    ),


  ];
}