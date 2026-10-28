import 'package:gatekeep/helper/dio_client.dart';
import 'package:gatekeep/locator.dart';
import 'package:gatekeep/model/visitor.dart';
import 'package:gatekeep/services/api_exception.dart';
import 'package:gatekeep/services/local_data_service.dart';
import 'package:gatekeep/utils/api_constants.dart';

class ApiService {
  ApiService();

  final DioClient client = locator<DioClient>();
  final LocalDataService local = locator<LocalDataService>();

  // True when the last call was answered from shared preferences.
  bool usingLocalData = false;

  Future<List<Visitor>> getVisitors() {
    return call(
      remote: () async {
        final body = await client.get(ApiConstants.visitors);
        if (body is! List) throw ApiException('Unexpected response from server');
        return body.whereType<Map<String, dynamic>>().map(Visitor.fromJson).toList();
      },
      offline: () => local.getVisitors(),
    );
  }

  Future<Visitor> getVisitor(String id) {
    return call(
      remote: () async => parseVisitor(await client.get('${ApiConstants.visitors}/$id')),
      offline: () => local.getVisitor(id),
    );
  }

  Future<Visitor> createVisitor(Visitor visitor) {
    return call(
      remote: () async => parseVisitor(await client.post(ApiConstants.visitors, visitor.toCreateJson())),
      offline: () => local.createVisitor(visitor),
    );
  }

  // Sends only the given fields. Used for edit and for status changes.
  Future<Visitor> updateVisitor(String id, Map<String, dynamic> data) {
    return call(
      remote: () async => parseVisitor(await client.put('${ApiConstants.visitors}/$id', data)),
      offline: () => local.updateVisitor(id, data),
    );
  }

  Future<void> deleteVisitor(String id) {
    return call(
      remote: () => client.delete('${ApiConstants.visitors}/$id'),
      offline: () => local.deleteVisitor(id),
    );
  }

  Visitor parseVisitor(dynamic body) {
    if (body is! Map<String, dynamic> || body['id'] == null) {
      throw ApiException('Unexpected response from server');
    }
    return Visitor.fromJson(body);
  }

  // Goes to the mock API first. If it is not set up or can't be reached,
  // the same request is answered from local data instead.
  Future<T> call<T>({required Future<T> Function() remote, required Future<T> Function() offline}) async {
    if (!ApiConstants.isConfigured) {
      usingLocalData = true;
      return offline();
    }
    try {
      final result = await remote();
      usingLocalData = false;
      return result;
    } on ApiException catch (e) {
      if (!e.isNetworkError) rethrow;
      usingLocalData = true;
      return offline();
    }
  }
}
