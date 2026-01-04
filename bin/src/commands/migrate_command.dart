import 'dart:io';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import '../migrate/analyzer.dart';
import '../migrate/migrator.dart';
import '../migrate/report.dart';
import '../migrate/cli.dart';
import '../migrate/patterns.dart';

class MigrateCommand extends Command<void> {
  @override
  final name = 'migrate';

  @override
  final description = 'Migrate Locus SDK from v1.x to v2.0';

  @override
  final aliases = ['m', 'upgrade'];

  late final ArgParser _argParser;

  MigrateCommand() {
    _argParser = ArgParser()
      ..addFlag(
        'dry-run',
        abbr: 'n',
        help: 'Preview changes without modifying files',
        defaultsTo: false,
      )
      ..addFlag(
        'backup',
        abbr: 'b',
        help: 'Create backup before migrating',
        defaultsTo: true,
      )
      ..addOption(
        'path',
        abbr: 'p',
        help: 'Path to project (defaults to current directory)',
        defaultsTo: '.',
      )
      ..addOption(
        'format',
        abbr: 'f',
        help: 'Output format',
        allowed: ['text', 'json'],
        defaultsTo: 'text',
      )
      ..addFlag(
        'verbose',
        abbr: 'v',
        help: 'Show detailed output',
        defaultsTo: false,
      )
      ..addFlag(
        'skip-tests',
        help: 'Skip test files',
        defaultsTo: false,
      )
      ..addFlag(
        'no-color',
        help: 'Disable colored output',
        defaultsTo: false,
      )
      ..addFlag(
        'help',
        abbr: 'h',
        help: 'Show this help message',
        defaultsTo: false,
      );
  }

  @override
  String get invocation {
    return '${runner?.executableName} $name [options]';
  }

  @override
  Future<void> run() async {
    final results = argResults;
    if (results == null) {
      stderr.write('Error: Could not parse arguments\n');
      exit(1);
    }

    final verbose = results['verbose'] as bool;
    final dryRun = results['dry-run'] as bool;
    final createBackup = results['backup'] as bool;
    final path = results['path'] as String;
    final format = results['format'] as String;
    final skipTests = results['skip-tests'] as bool;
    final noColor = results['no-color'] as bool;
    final showHelp = results['help'] as bool;

    if (showHelp) {
      print(usage);
      return;
    }

    final projectDir = Directory(path);

    if (!await projectDir.exists()) {
      stderr.write('Error: Directory not found: $path\n');
      exit(1);
    }

    final cli = MigrationCLI(verbose: verbose, noColor: noColor);
    final analyzer = MigrationAnalyzer(verbose: verbose);
    final migrator = MigrationMigrator(analyzer: analyzer, verbose: verbose);

    try {
      cli.info('Starting migration analysis...');

      final result = await migrator.migrate(
        projectDir: projectDir,
        dryRun: dryRun,
        createBackup: createBackup,
        skipTests: skipTests,
      );

      if (format == 'json') {
        print(_generateJsonOutput(result));
      } else {
        cli.printMigrationResult(result);
      }

      final exitCode = _determineExitCode(result);
      exit(exitCode);
    } catch (e, stack) {
      stderr.write('Error during migration: $e\n');
      if (verbose) {
        stderr.write('$stack\n');
      }
      exit(1);
    }
  }

  String _generateJsonOutput(MigrationResult result) {
    final Map<String, dynamic> output = {
      'dryRun': result.dryRun,
      'timestamp': result.timestamp.toIso8601String(),
      'summary': {
        'filesAnalyzed': result.analysis.totalFiles,
        'filesWithLocus': result.analysis.filesWithLocus,
        'totalPatterns': result.analysis.totalMatches,
        'autoMigratable': result.analysis.autoMigratableCount,
        'manualReview': result.analysis.manualReviewCount,
        'removedFeatures': result.analysis.removedFeaturesCount,
        'filesModified': result.filesModified,
        'successfulChanges': result.successfulChanges,
        'failedChanges': result.failedChanges,
      },
      'backupPath': result.backupPath,
      'matchesByCategory': result.analysis.matchesByCategory,
      'warnings': result.analysis.warnings.map((w) => w.toJson()).toList(),
      'errors': result.analysis.errors.map((e) => e.toJson()).toList(),
    };

    return _formatJson(output);
  }

  String _formatJson(Map<String, dynamic> data) {
    try {
      return _jsonEncode(data, 0);
    } catch (e) {
      return data.toString();
    }
  }

  String _jsonEncode(Map<String, dynamic> data, int indent) {
    final buffer = StringBuffer();
    final spaces = '  ' * indent;
    final nextSpaces = '  ' * (indent + 1);

    buffer.write('{\n');

    final entries = data.entries.toList();
    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      buffer.write('$nextSpaces"${entry.key}": ');

      final value = entry.value;
      if (value is Map<String, dynamic>) {
        buffer.write(_jsonEncode(value, indent + 1));
      } else if (value is List) {
        buffer.write(_jsonEncodeList(value, indent + 1));
      } else if (value is String) {
        buffer.write('"${value.replaceAll('"', '\\"')}"');
      } else if (value is bool || value is num) {
        buffer.write(value.toString());
      } else if (value == null) {
        buffer.write('null');
      } else {
        buffer.write('"${value.toString()}"');
      }

      if (i < entries.length - 1) {
        buffer.write(',');
      }
      buffer.write('\n');
    }

    buffer.write('$spaces}');
    return buffer.toString();
  }

  String _jsonEncodeList(List<dynamic> list, int indent) {
    if (list.isEmpty) return '[]';

    final buffer = StringBuffer();
    final spaces = '  ' * indent;
    final nextSpaces = '  ' * (indent + 1);

    buffer.write('[\n');

    for (int i = 0; i < list.length; i++) {
      final value = list[i];
      buffer.write('$nextSpaces');

      if (value is Map<String, dynamic>) {
        buffer.write(_jsonEncode(value, indent + 1));
      } else if (value is List) {
        buffer.write(_jsonEncodeList(value, indent + 1));
      } else if (value is String) {
        buffer.write('"${value.replaceAll('"', '\\"')}"');
      } else if (value is bool || value is num) {
        buffer.write(value.toString());
      } else if (value == null) {
        buffer.write('null');
      } else {
        buffer.write('"${value.toString()}"');
      }

      if (i < list.length - 1) {
        buffer.write(',');
      }
      buffer.write('\n');
    }

    buffer.write('$spaces]');
    return buffer.toString();
  }

  int _determineExitCode(MigrationResult result) {
    if (result.failedChanges > 0) {
      return 1;
    }

    if (result.analysis.manualReviewCount > 0 && !result.dryRun) {
      return 0;
    }

    return 0;
  }
}
