class TextUtile {
  static RegExp brackets = RegExp(r'(\(+|)+\)');
  static RegExp leftBrackets = RegExp(r'(\(+)');
  static RegExp rightBrackets = RegExp(r'(\)+)');
  static RegExp publicType = RegExp(r'(공유\)+)');
  isMatch(String str, RegExp regExp) => regExp.hasMatch(str);
  String cutStr(String string, int start, int end) {
    return string.substring(start, end);
  }

  String parkingTypeParss(String name) {
    if (isMatch(name, publicType)) {
      int start = name.indexOf(publicType);
      int end = name.indexOf(publicType) + 2;
      return cutStr(name, start, end);
    } else {
      if (isMatch(name, brackets)) {
        int start = name.lastIndexOf(leftBrackets) + 1;
        int end = name.lastIndexOf(rightBrackets);
        return cutStr(name, start, end) + '청';
      } else {
        return '자영';
      }
    }
  }

  String parkingNameParss(String name) {
    if (isMatch(name, publicType)) {
      int start = name.indexOf(publicType) + 3;
      int end = name.lastIndexOf(leftBrackets);
      return cutStr(name, start, end);
    } else {
      int start = 0;
      int end = name.lastIndexOf(leftBrackets);
      return cutStr(name, start, end);
    }
  }
}
