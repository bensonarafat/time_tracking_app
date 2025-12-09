import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:time_tracking_app/core/constants/constants.dart';

import '../models/comment_model.dart';
import '../models/task_model.dart';

abstract interface class TaskRemoteDataSource {
  Future<TaskModel> createTask(String content);
  Future<TaskModel> updateTask(String taskId, {String? content});
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> getTask(String taskId);
  Future<CommentModel> createComment(String taskId, String content);
  Future<List<CommentModel>> getComments(String taskId);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final http.Client client;
  final String apiToken;

  TaskRemoteDataSourceImpl({required this.client, required this.apiToken});

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $apiToken',
    'Content-Type': 'application/json',
  };

  @override
  Future<TaskModel> createTask(String content) async {
    final response = await client.post(
      Uri.parse('${Constants.baseUrl}/tasks'),
      headers: _headers,
      body: jsonEncode({'content': content}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return TaskModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create task: ${response.body}');
    }
  }

  @override
  Future<List<TaskModel>> getTasks() async {
    final response = await client.get(
      Uri.parse('${Constants.baseUrl}/tasks'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => TaskModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks: ${response.statusCode}');
    }
  }

  @override
  Future<TaskModel> updateTask(String taskId, {String? content}) async {
    final response = await client.post(
      Uri.parse('${Constants.baseUrl}/tasks/$taskId'),
      headers: _headers,
      body: json.encode({'content': content}),
    );

    if (response.statusCode == 200) {
      return TaskModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update task: ${response.statusCode}');
    }
  }

  @override
  Future<CommentModel> createComment(String taskId, String content) async {
    final response = await client.post(
      Uri.parse('${Constants.baseUrl}/comments'),
      headers: _headers,
      body: json.encode({'task_id': taskId, 'content': content}),
    );

    if (response.statusCode == 200) {
      return CommentModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create comment: ${response.statusCode}');
    }
  }

  @override
  Future<List<CommentModel>> getComments(String taskId) async {
    final response = await client.get(
      Uri.parse('${Constants.baseUrl}/comments?task_id=$taskId'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => CommentModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments: ${response.statusCode}');
    }
  }

  @override
  Future<TaskModel> getTask(String taskId) async {
    final response = await client.get(
      Uri.parse('${Constants.baseUrl}/tasks/$taskId'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return TaskModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch task ${response.statusCode}');
    }
  }
}
