part of 'fact_bloc.dart';

class FactState extends Equatable {

  @override
  List<Object?> get props => [];

}

class FactInitial extends FactState {}

class FactLoaded extends FactState {
  late final Fact fact;

  FactLoaded(this.fact);

  @override
  List<Object?> get props => [fact];
}