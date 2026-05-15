import 'dart:io';
import '../create_auto_files/path_constants.dart';
import 'path_constants.dart';



class ControllerAddRequiredFiles extends BaseAddRequiredFiles {
  ControllerAddRequiredFiles( this.isCubit);
  final  bool  isCubit;

  @override
  makeRequiredFiles(String folder) async {
      super.makeRequiredFiles(folder);

      if (isCubit) {
        await  addCubitFiles(folder);
      }

  }
}



Future<void> addCubitFiles(String folder) async {

  final filePath = '${PathConstants().folderPath(folder)}/${PathConstants().cubitFileName()}';
  final file = File(filePath);

  if (!file.existsSync()) {
    final contentt =
    '''
    import 'package:${PathConstants().projectName}/core/constants/app_constant.dart';
 import 'package:${PathConstants().projectName}/core/base/base_state.dart';
 import 'package:${PathConstants().projectName}/core/base/base_service.dart';   
import 'package:${PathConstants().projectName}/core/base/base_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:${PathConstants().projectName}/main.dart';
import '${PathConstants().stateFileName()}';
import 'package:${PathConstants().projectName}/features/screens/${PathConstants().name}/service/${PathConstants().name}_service.dart';


class ${PathConstants().cubitName()} extends BaseCubit<${PathConstants().stateName()}> {
   ${PathConstants().cubitName()}(this._service) : super(${PathConstants().initialStateName()}()) ;
  final ${PathConstants().serviceName()} _service;
  
     static ${PathConstants().cubitName()} get({BuildContext? context,bool listen=false}) =>
      BlocProvider.of(context??navigatorKey.currentContext!,listen: listen);
  
  @override
  init() {
    // TODO: implement init
   
  }
  
}
''';
    file.writeAsStringSync(contentt);
    print('📄 Created cubit Dart file: $filePath');
  } else {
    print('⚠️ cubit Dart file already exists: $filePath');
  }

  final statePath = '${PathConstants().folderPath(folder)}/${PathConstants().stateFileName()}';
  final state = File(statePath);

  if (!state.existsSync()) {
    final content =
    '''

import 'package:flutter/material.dart';

@immutable
abstract class ${PathConstants().stateName()} {}

class ${PathConstants().initialStateName()} extends ${PathConstants().stateName()} {}
''';
    state.writeAsStringSync(content);
    print('📄 Created state Dart file: $statePath');
  } else {
    print('⚠️ cubit state file already exists: $statePath');
  }

}
