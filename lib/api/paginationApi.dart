abstract class PaginationApi {
  initPage() async {}
  resetPage() async {}
  updatePage() async {}
  hasMore() async {}
  updateData({required dynamic newData}) async {}
  requestData() async {}
  resetCache() async {}
  resetCearchKeyWord({required String keyword}) async {}
  getSearchKey() async {}
}
