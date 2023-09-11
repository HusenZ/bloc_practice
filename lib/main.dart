import 'package:bloc_practice/apis/login_api.dart';
import 'package:bloc_practice/apis/notes_api.dart';
import 'package:bloc_practice/blocs/actions.dart';
import 'package:bloc_practice/blocs/app_bloc.dart';
import 'package:bloc_practice/blocs/app_state.dart';
import 'package:bloc_practice/dialogs/generic_dialogs.dart';
import 'package:bloc_practice/dialogs/loading_screen.dart';
import 'package:bloc_practice/models.dart';
import 'package:bloc_practice/strings.dart';
import 'package:bloc_practice/views/iterable_list_view.dart';
import 'package:bloc_practice/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Practice',
      theme: ThemeData(primaryColor: Colors.purpleAccent),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoadingScreen loadingScreen = LoadingScreen();

    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NotesApi(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Practice'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            // take care of loading screen

            if (appState.isLoading) {
              loadingScreen.show(
                context: context,
                text: pleaseWait,
              );
            } else {
              loadingScreen.hide();
            }
            final loginErrors = appState.loginErrors;
            if (loginErrors != null) {
              showGenericDialog(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionBuilder: () => {
                  ok: true,
                },
              );
            }

            //if we are logged in but we have no fetched notes, fetch them now
            if (appState.isLoading == false &&
                appState.loginErrors == null &&
                appState.loginHandle == const LoginHandle.pass() &&
                appState.fetchedNotes == null) {
              context.read<AppBloc>().add(
                    const LoadNotesAction(),
                  );
            }
          },
          builder: (context, appState) {
            final notes = appState.fetchedNotes;
            if (notes == null) {
              return LoginView(
                onLoginTapped: (email, password) {
                  context.read<AppBloc>().add(
                        LoginAction(email: email, password: password),
                      );
                },
              );
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
