import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/saved_instruction_model.dart';
import '../../data/database/database_helper.dart';
import 'dart:developer' as dev;

class SettingsState {
  final List<SavedInstructionModel> instructions;
  final bool isLoading;
  final String? error;

  SettingsState({
    this.instructions = const [],
    this.isLoading = false,
    this.error,
  });

  SettingsState copyWith({
    List<SavedInstructionModel>? instructions,
    bool? isLoading,
    String? error,
  }) {
    return SettingsState(
      instructions: instructions ?? this.instructions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class SettingsViewModel extends StateNotifier<SettingsState> {
  final _dbHelper = DatabaseHelper.instance;
  final _uuid = const Uuid();

  SettingsViewModel() : super(SettingsState()) {
    loadInstructions();
  }

  Future<void> loadInstructions() async {
    state = state.copyWith(isLoading: true);
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'instructions',
        orderBy: 'created_at DESC',
      );

      final instructions = List.generate(maps.length, (i) {
        return SavedInstructionModel.fromMap(maps[i]);
      });

      state = state.copyWith(instructions: instructions, isLoading: false);
    } catch (e) {
      dev.log('Error loading instructions: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addInstruction(String title, String content) async {
    try {
      final newInstruction = SavedInstructionModel(
        id: _uuid.v4(),
        title: title,
        content: content,
        createdAt: DateTime.now(),
      );

      final db = await _dbHelper.database;
      await db.insert('instructions', newInstruction.toMap());
      
      state = state.copyWith(
        instructions: [newInstruction, ...state.instructions],
      );
    } catch (e) {
      dev.log('Error adding instruction: $e');
    }
  }

  Future<void> deleteInstruction(String id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete('instructions', where: 'id = ?', whereArgs: [id]);
      
      state = state.copyWith(
        instructions: state.instructions.where((i) => i.id != id).toList(),
      );
    } catch (e) {
      dev.log('Error deleting instruction: $e');
    }
  }
}

final settingsProvider = StateNotifierProvider<SettingsViewModel, SettingsState>((ref) {
  return SettingsViewModel();
});
