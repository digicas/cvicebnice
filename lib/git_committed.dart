// Copyright 2020 Radek Svarz. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Inspired by
// https://github.com/flutter/flutter/wiki/Code-generation-in-Flutter

import 'package:build/build.dart';
import 'dart:async';

/// The builder factory used by the `build.yaml` script. Creates a [GitCommittedInfoBuilder]
Builder gitCommittedInfoBuilder(BuilderOptions builderOptions) =>
    GitCommittedInfoBuilder();

/// Builder generating the dart file with information on actual git commit
class GitCommittedInfoBuilder extends Builder {
  @override
  Map<String, List<String>> get buildExtensions => const <String, List<String>>{
        '.toml': <String>['.git.dart']
      };

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final AssetId output = buildStep.inputId.changeExtension('.git.dart');
    print("buuuuuuilding");
    final String contents = await buildStep.readAsString(buildStep.inputId);
    await buildStep.writeAsString(output, contents);
  }
}
