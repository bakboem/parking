class TextUtile {
  static RegExp brackets = RegExp(r'(\(+|)+\)');
  static RegExp leftBrackets = RegExp(r'(\(+)');
  static RegExp rightBrackets = RegExp(r'(\)+)');
  isMatch(String str, RegExp regExp) => regExp.hasMatch(str);
  String cutStr(String string, int start, int end) {
    return string.substring(start, end);
  }

  String parkingTypeParss(String name) {
    if (isMatch(name, brackets)) {
      int start = name.lastIndexOf(leftBrackets) + 1;
      int end = name.lastIndexOf(rightBrackets);
      return cutStr(name, start, end);
    } else {
      return '자영';
    }
  }
}
