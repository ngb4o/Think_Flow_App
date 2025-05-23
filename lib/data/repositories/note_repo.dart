import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:think_flow/data/data_sources/remote/api_client.dart';
import 'package:think_flow/data/models/create_link_note_model.dart';
import 'package:think_flow/data/models/data_model.dart';
import 'package:think_flow/data/models/list_note_model.dart';
import 'package:think_flow/data/models/text_note_model.dart';

import '../data_sources/remote/api_endpoint_urls.dart';
import '../data_sources/remote/api_exception.dart';
import '../models/audio_note_model.dart';
import '../models/list_audio_note_model.dart';
import '../models/note_member_model.dart';
import '../models/note_model.dart';

class NoteRepo extends ApiClient {
  NoteRepo();

  // ---------- GET ---------- //
  // Get list note
  Future<ListNoteModel> getListNotes({String? cursor}) async {
    try {
      final queryParams = cursor != null ? {'cursor': cursor} : null;
      final response = await getRequest(
        path: ApiEndpointUrls.note,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final responseData = listNoteModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Failed to get list notes');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Get note
  Future<NoteModel> getNote(String noteId) async {
    try {
      final response = await getRequest(path: '${ApiEndpointUrls.note}/$noteId');
      if (response.statusCode == 200) {
        final responseData = noteModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Fail to get note');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Get text note
  Future<TextNoteModel> getTextNote(String noteId) async {
    try {
      final response = await getRequest(path: '${ApiEndpointUrls.textNote}/$noteId');
      if (response.statusCode == 200) {
        final responseData = textNoteModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Fail to get text note');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Get audio note
  Future<AudioNoteModel> getAudio(String audioId) async {
    try {
      final response = await getRequest(path: '${ApiEndpointUrls.audio}/$audioId');
      if (response.statusCode == 200) {
      
        final responseData = audioNoteModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Get audio failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      print('Error in getAudio: $e');
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Get listaudio note
  Future<ListAudioNoteModel> getListAudioNote(String noteId) async {
    try {
      final response = await getRequest(
        path: '${ApiEndpointUrls.audio}?note-id=$noteId',
      );
      if (response.statusCode == 200) {
        final responseData = listAudioNoteModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Fail to get audio note');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Get list archived
  Future<ListNoteModel> getListArchived({String? cursor}) async {
    try {
      final queryParams = cursor != null ? {'cursor': cursor} : null;
      final response = await getRequest(
        path: ApiEndpointUrls.archived,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final responseData = listNoteModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Failed to get list notes');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Get note share with me
  Future<ListNoteModel> getNoteShareWithMe({String? cursor}) async {
    try {
      final queryParams = cursor != null ? {'cursor': cursor} : null;
      final response = await getRequest(
        path: ApiEndpointUrls.noteShareWithMe,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final responseData = listNoteModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Failed to get list notes');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Get note member
  Future<NoteMemberModel> getNoteMember(String noteId) async {
    try {
      final response = await getRequest(path: '${ApiEndpointUrls.note}/$noteId${ApiEndpointUrls.members}');
      if(response.statusCode == 200) {
        final responseData = noteMemberModelFromJson(jsonEncode(response.data));
        return responseData;
      }else {
        throw ApiException(message: 'Fail to get list member');
      }
    } on ApiException {
      rethrow;
    } catch(e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // ---------- CREATE ---------- //
  // Create new note
  Future<DataModel> createNewNote(String title) async {
    Map body = {
      "title": title,
    };
    try {
      final response = await postRequest(
        path: ApiEndpointUrls.note,
        body: body,
      );
      if (response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Create failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Create text note
  Future<DataModel> createTextNote(String id, Map<String, dynamic> content) async {
    try {
      // Ensure text_string is not empty
      if (content['text_string'] == null || content['text_string'].toString().trim().isEmpty) {
        content['text_string'] = 'New note';
      }

      final response = await postRequest(
        path: '${ApiEndpointUrls.textNote}/$id',
        body: content,
      );
      if (response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Create text note failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Create audio note
  Future<DataModel> createAudiNote(String id, File audioFile) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(audioFile.path),
      });

      final response = await postRequest(
        path: '${ApiEndpointUrls.audioNote}/$id',
        body: formData,
      );

      if (response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Create audio note failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Create link note
  Future<CreateLinkNoteModel> createLinkNote(String permission, String noteId) async {
    Map body = {
      "permission": permission,
    };
    try {
      final response = await postRequest(
        path: '${ApiEndpointUrls.note}/$noteId${ApiEndpointUrls.createLinkNote}',
        body: body,
      );
      if(response.statusCode == 200) {
        final responseData = createLinkNoteModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Create link note failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Share link to email
  Future<DataModel> shareLinkNoteToEmail(String email, String permission, String noteId) async {
    Map body = {
      "email": email,
      "permission": permission,
    };
    try {
      final response = await postRequest(
        path: '${ApiEndpointUrls.note}/$noteId${ApiEndpointUrls.shareLinkNoteToEmail}',
        body: body,
      );
      if(response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Share note failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  Future<DataModel> createSummaryText(String id) async {
    try {
      final response = await postRequest(
        path: '${ApiEndpointUrls.text}/$id${ApiEndpointUrls.createSummaryNote}',
      );
      if (response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Create summary note failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  Future<DataModel> createSummaryNote(String id) async {
    try {
      final response = await postRequest(
        path: '${ApiEndpointUrls.note}/$id${ApiEndpointUrls.createSummaryNote}',
      );
      if (response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Create summary note failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  Future<NoteModel> createMindmapNote(String id) async {
    try {
      final response = await postRequest(
        path: '${ApiEndpointUrls.note}/$id${ApiEndpointUrls.createMindmapNote}',
      );
      if (response.statusCode == 200) {
        final responseData = noteModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Create mindmap note failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  Future<DataModel> createAudioSummaryText(String audioId) async {
    try {
      final response = await postRequest(
        path: '${ApiEndpointUrls.audio}/$audioId${ApiEndpointUrls.createSummaryNote}',
      );
      if (response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Create audio summary note failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // ---------- PATCH ---------- //
  // Update note
  Future<DataModel> updateNote(String noteId, String title) async {
    Map body = {
      "title": title,
    };
    try {
      final response = await patchRequest(
        path: '${ApiEndpointUrls.note}/$noteId',
        body: body,
      );
      if (response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Update failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Update text note
  Future<DataModel> updateTextNote(String id, Map<String, dynamic> content) async {
    try {
      final response = await patchRequest(
        path: '${ApiEndpointUrls.text}/$id',
        body: content,
      );
      if (response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Update text note failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Archive note
  Future<DataModel> archiveNote(String noteId) async {
    try {
      final response = await patchRequest(
        path: '${ApiEndpointUrls.archive}/$noteId',
      );
      if (response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Update text note failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Unarchive note
  Future<DataModel> unarchiveNote(String noteId) async {
    try {
      final response = await patchRequest(
        path: '${ApiEndpointUrls.unarchive}/$noteId',
      );
      if (response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Update text note failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Update permission member
  Future<DataModel> updatePermissionMember(String noteId, String userId, String permission) async {
    Map body = {
      'permission' : permission,
    };
    try {
      final response = await patchRequest(
        path: '${ApiEndpointUrls.note}/$noteId${ApiEndpointUrls.members}/$userId',
        body: body,
      );
      if (response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Update text note failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Update summary note
  Future<DataModel> updateSummaryNote(String id, String summaryText) async {
    Map body = {
      "summary_text": summaryText,
    };
    try {
      final response = await patchRequest(
        path: '${ApiEndpointUrls.summary}/$id',
        body: body,
      );
      if (response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Update summary note failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Update mindmap note
  Future<NoteModel> updateMindmapNote(String mindmapId, Map<String, dynamic> mindmapData) async {
    try {
      final response = await patchRequest(
        path: '${ApiEndpointUrls.mindmap}/$mindmapId',
        body: mindmapData,
      );
      if (response.statusCode == 200) {
        final responseData = noteModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Update mindmap note failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Update transcript note
  Future<DataModel> updateTranscriptNote(String transcriptId, String content) async {
    Map body = {
      "content": content,
    };
    try {
      final response = await patchRequest(
        path: '${ApiEndpointUrls.transcript}/$transcriptId',
        body: body,
      );
      if (response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Update transcript audio failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // ---------- DELETE ---------- //
  // Delete note
  Future<DataModel> deleteNote(String noteId) async {
    try {
      final response = await deleteRequest(path: '${ApiEndpointUrls.note}/$noteId');
      if (response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Delete failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Delete audio
  Future<DataModel> deleteAudio(String audioId) async {
    try {
      final response = await deleteRequest(path: '${ApiEndpointUrls.audio}/$audioId');
      if (response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Delete failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }
}
