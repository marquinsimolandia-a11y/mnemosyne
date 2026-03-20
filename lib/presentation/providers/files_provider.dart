import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'dart:developer' as dev;
import 'dart:io';

class FilesState {
  final List<File> galleryFiles;
  final bool isPicking;
  final String? error;

  FilesState({
    this.galleryFiles = const [],
    this.isPicking = false,
    this.error,
  });

  FilesState copyWith({
    List<File>? galleryFiles,
    bool? isPicking,
    String? error,
  }) {
    return FilesState(
      galleryFiles: galleryFiles ?? this.galleryFiles,
      isPicking: isPicking ?? this.isPicking,
      error: error,
    );
  }
}

class FilesViewModel extends StateNotifier<FilesState> {
  FilesViewModel() : super(FilesState());

  Future<String?> pickFile() async {
    state = state.copyWith(isPicking: true, error: null);
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null && result.files.single.path != null) {
        state = state.copyWith(isPicking: false);
        return result.files.single.path;
      }
    } catch (e) {
      dev.log('File picker error: $e');
      state = state.copyWith(isPicking: false, error: e.toString());
    }
    state = state.copyWith(isPicking: false);
    return null;
  }

  void addToGallery(String path) {
    state = state.copyWith(
      galleryFiles: [...state.galleryFiles, File(path)],
    );
  }

  Future<void> openFile(String path) async {
    try {
      await OpenFile.open(path);
    } catch (e) {
      dev.log('Error opening file: $e');
    }
  }
}

final filesProvider = StateNotifierProvider<FilesViewModel, FilesState>((ref) {
  return FilesViewModel();
});
