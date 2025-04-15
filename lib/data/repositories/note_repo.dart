import 'dart:convert';

import 'package:think_flow/data/data_sources/remote/api_client.dart';
import 'package:think_flow/data/models/data_model.dart';
import 'package:think_flow/data/models/note_model.dart';

import '../data_sources/remote/api_endpoint_urls.dart';
import '../data_sources/remote/api_exception.dart';

class NoteRepo extends ApiClient {
  NoteRepo();

  // Get list note
  Future<NoteModel> getListNotes({String? cursor}) async {
    try {
      final queryParams = cursor != null ? {'cursor': cursor} : null;
      final response = await getRequest(
        path: ApiEndpointUrls.getListNotes,
        params: queryParams,
      );
      
      if (response.statusCode == 200) {
        final responseData = noteModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Failed to get notes');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Create new note
  Future<DataModel> createNewNote(String title) async {
    Map body = {
      "title": title,
    };
    try {
      final response = await postRequest(path: ApiEndpointUrls.createNewNote, body: body);
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
    Map body = {"text_content": content};
    try {
      final response = await postRequest(path: '${ApiEndpointUrls.createTextNote}/$id', body: body);
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

}
