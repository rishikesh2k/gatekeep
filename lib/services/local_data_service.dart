import 'package:gatekeep/helper/date_helper.dart';
import 'package:gatekeep/helper/shared_prefs.dart';
import 'package:gatekeep/model/visitor.dart';
import 'package:gatekeep/services/api_exception.dart';
import 'package:gatekeep/utils/dummy_visitors.dart';

// Used when the mock API is not set up or not reachable.
// Data is kept in shared preferences so it survives an app restart.
class LocalDataService {
  Future<List<Map<String, dynamic>>> readAll() async {
    await SharedPrefs.init();
    if (!SharedPrefs.hasVisitors) {
      await SharedPrefs.saveVisitors(DummyVisitors.build());
    }
    return SharedPrefs.getVisitors();
  }

  Future<List<Visitor>> getVisitors() async {
    final list = await readAll();
    return list.map(Visitor.fromJson).toList();
  }

  Future<Visitor> getVisitor(String id) async {
    final list = await readAll();
    for (final item in list) {
      if (item['id'].toString() == id) return Visitor.fromJson(item);
    }
    throw ApiException('Visitor not found', statusCode: 404);
  }

  Future<Visitor> createVisitor(Visitor visitor) async {
    final list = await readAll();
    final json = visitor.toCreateJson();
    json['id'] = await SharedPrefs.nextLocalId();
    json['created_at'] = DateHelper.nowForApi();
    list.insert(0, json);
    await SharedPrefs.saveVisitors(list);
    return Visitor.fromJson(json);
  }

  Future<Visitor> updateVisitor(String id, Map<String, dynamic> data) async {
    final list = await readAll();
    final index = list.indexWhere((item) => item['id'].toString() == id);
    if (index == -1) throw ApiException('Visitor not found', statusCode: 404);
    list[index] = {...list[index], ...data};
    await SharedPrefs.saveVisitors(list);
    return Visitor.fromJson(list[index]);
  }

  Future<void> deleteVisitor(String id) async {
    final list = await readAll();
    list.removeWhere((item) => item['id'].toString() == id);
    await SharedPrefs.saveVisitors(list);
  }
}
