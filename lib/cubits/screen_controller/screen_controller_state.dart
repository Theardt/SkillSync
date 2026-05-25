part of 'screen_controller_cubit.dart';


enum MainScreens {
  home('Home', Icons.home),
  about('About', Icons.info); // About screen kept temporarily for reference

  final String displayName;
  final IconData icon;

  const MainScreens(this.displayName, this.icon);
}

class ScreenControllerState extends GlobalVars with EquatableMixin {
  final MainScreens currentScreen;
  final List<MainScreens> availableScreens;

  const ScreenControllerState({
    this.currentScreen = MainScreens.home,
    this.availableScreens = MainScreens.values,
  });

  @override
  List<Object?> get props => [currentScreen, availableScreens];

  ScreenControllerState copyWith({MainScreens? currentScreen, List<MainScreens>? availableScreens}) {
    return ScreenControllerState(
      currentScreen: currentScreen ?? this.currentScreen,
      availableScreens: availableScreens ?? this.availableScreens,
    );
  }
}
