part of 'home_cubit.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  const HomeState({required this.selectedIndex});

  @override
  List<Object> get props => [selectedIndex];
}
