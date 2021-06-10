abstract class BaseApi {
  initPage() async {}
  resetPage() async {}
  updatePage() async {}
  updateData({required dynamic newData}) async {}
  requestData(String search) async {}
  resetCache() {}
}
