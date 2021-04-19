part of '../pokedex.dart';

class _FabMenu extends StatelessWidget {
  const _FabMenu({
    @required this.animation,
    @required this.toggle,

    this.onAllGenPress,
    this.onSearchPress,
  });

  final Animation animation;
  final Function onAllGenPress;

  final Function onSearchPress;
  final Function toggle;

  void onPress(Function callback) {
    toggle();

    if (callback != null) callback();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandedAnimationFab(
      animation: animation,
      onPress: toggle,
      items: [

        FabItem(
          'All Gen',
          Icons.flash_on,
          onPress: () => onPress(onAllGenPress),
        ),
        FabItem(
          'Search',
          Icons.search,
          onPress: () => onPress(onSearchPress),
        ),
      ],
    );
  }
}
