class Calculate {
  List<String> _chars;

  static const int maxChars = 15;

  Calculate(List<String> cs) {
    _chars = List.from(cs);
  }

  factory Calculate.fromString(String str) {
    List<String> result = [];
    for (int i = 0; i < str.length; i++) result.add(str[i]);
    return Calculate(result);
  }

  factory Calculate.fromDouble(double val) {
    return Calculate.fromString(val.toString());
  }

  bool isNumber(String str) {
    try {
      double.parse(str);
      return true;
    } catch (_) {
      return false;
    }
  }

  List<String> get chars => List.from(_chars);

  int get currentNumberIndex {
    for (int i = _chars.length - 1; i >= 0; i--) {
      String char = _chars[i];
      String pChar = "";
      if (i - 1 >= 0) pChar = _chars[i - 1];
      if (!isNumber(char) &&
          char != "." &&
          char != ")" &&
          pChar + char != "(-" &&
          char != "(") return i;
    }
    return -1;
  }

  Calculate copy() {
    return Calculate(List.from(_chars));
  }

  Calculate currentNumber() {
    int index = currentNumberIndex;
    if (index == -1) return copy();
    if (index + 1 >= length) return Calculate([]);
    return sublist(index + 1);
  }

  Calculate afterComma() {
    int index = -1;
    for (int i = 0; i < length; i++)
      if (at(i) == ".") {
        index = i;
        break;
      }
    if (index == -1) return Calculate([]);
    return sublist(index);
  }

  Calculate beforeComma() {
    int index = -1;
    for (int i = 0; i < length; i++)
      if (at(i) == ".") {
        index = i;
        break;
      }
    if (index == -1) return Calculate([]);
    return sublist(0, index);
  }

  double toDouble() {
    return double.parse(this.toString());
  }

  String toString() {
    String result = "";
    for (String char in chars) result += char;
    return result;
  }

  String toShowString() {
    String result = toString();
    bool afterComma(int index) {
      if (!result.contains(".")) return false;
      for (int i = index; i >= 0; i--) {
        if (result[i] == ".") return true;
        if (result[i] == "+" ||
            result[i] == "-" ||
            result[i] == "x" ||
            result[i] == "/" ||
            result[i] == "%") return false;
      }
      return false;
    }

    int digitsNum = 0;
    for (int i = result.length - 1; i >= 0; i--) {
      if (afterComma(i)) {
        digitsNum = 0;
        continue;
      }
      if (isNumber(result[i]))
        digitsNum++;
      else
        digitsNum = 0;
      if (digitsNum == 3) {
        result = "${result.substring(0, i)} ${result.substring(i)}";
        digitsNum = 0;
      }
    }

    return result;
  }

  Calculate sublist(int start, [int end]) {
    return Calculate(_chars.sublist(start, end));
  }

  void replaceRange(int start, int end, List<String> replacement) {
    _chars.replaceRange(start, end, replacement);
  }

  void replace(int start, int end, Calculate replacement) {
    _chars.replaceRange(start, end, replacement.chars);
  }

  void replaceCurrentNumber(Calculate replacement) {
    int index = currentNumberIndex;
    if (index == -1)
      index = 0;
    else
      index++;
    replace(index, _chars.length, replacement);
  }

  String get lastChar => last >= 0 ? _chars[last] : "";

  int get last => _chars.length - 1;

  int numOf(String search) {
    int sum = 0;
    for (String char in _chars) if (char == search) sum++;
    return sum;
  }

  bool lastCharIs(List<String> search) {
    for (String char in search) if (char == lastChar) return true;
    return false;
  }

  bool contains(String str) {
    return _chars.contains(str);
  }

  int indexOf(String str) {
    return _chars.indexOf(str);
  }

  int lastIndexOf(String str) {
    return _chars.lastIndexOf(str);
  }

  String at(int index) {
    return _chars[index];
  }

  void insert(int index, String element) {
    _chars.insert(index, element);
  }

  void add(String element) {
    for (int i = 0; i < element.length; i++) _chars.add(element[i]);
  }

  void clear() {
    _chars.clear();
  }

  void remove(int index) {
    _chars.removeAt(index);
  }

  int get length => _chars.length;

  static Calculate solve(Calculate string) {
    Calculate str = string.copy();
    try {
      double.parse(str.toString());
      if (str.afterComma().toString() == ".0") return str.beforeComma();
      return str;
    } catch (_) {}
    if (str.contains("(") && str.contains(")")) {
      int openIndex = str.indexOf("(");
      int closeIndex = -1;
      int numOpened = 1;
      for (int i = openIndex + 1; i < str.length; i++) {
        String char = str.at(i);
        if (char == "(") numOpened++;
        if (char == ")") {
          numOpened--;
          if (numOpened == 0) {
            closeIndex = i;
            break;
          }
        }
      }
      str.replaceRange(
        openIndex,
        closeIndex + 1,
        [
          Calculate.solve(str.sublist(openIndex + 1, closeIndex))
              .toShowString(),
        ],
      );
      return solve(str);
    }

    if (str.contains("-") || str.contains("+")) {
      if (str.at(0) == "+" || str.at(0) == "-") str.insert(0, "0");
      List<Calculate> terms = [];
      int lastIndex = 0;
      for (int i = 0; i < str.length; i++) {
        if (str.at(i) == "+" || str.at(i) == "-") {
          if (i + 1 < str.length &&
              (str.at(i + 1) == "+" || str.at(i + 1) == "-")) continue;

          terms.add(str.sublist(lastIndex, i));
          terms.add(Calculate.fromString(str.at(i)));
          lastIndex = i + 1;
        }
      }
      terms.add(str.sublist(lastIndex));
      double sum = double.parse(Calculate.solve(terms[0]).toString());
      for (int i = 2; i < terms.length; i += 2) {
        final double term = double.parse(Calculate.solve(terms[i]).toString());
        sum += terms[i - 1].at(0) == "+" ? term : -term;
      }
      return solve(Calculate.fromString(sum.toString()));
    }
    if (str.contains("/") || str.contains("x")) {
      int index;
      bool mult;
      if (str.contains("/")) {
        index = str.indexOf("/");
        mult = false;
      } else {
        index = str.indexOf("x");
        mult = true;
      }
      final term1 = double.parse(
        Calculate.solve(
          str.sublist(0, index),
        ).toString(),
      );
      final term2 = double.parse(
        Calculate.solve(
          str.sublist(index + 1),
        ).toString(),
      );
      if (term2 == 0 && !mult) return null;
      return mult
          ? Calculate.fromDouble((term1 * term2))
          : Calculate.fromDouble((term1 / term2));
    }

    if (str.contains("%")) {
      return Calculate.fromDouble(
        str.sublist(0, str.length - 1).toDouble() / 100,
      );
    }
    return null;
  }

  void operate(String char) {
    if (isNumber(char) && lastChar == ")") add("x");
    if ((isNumber(char) || char == ".") &&
        currentNumber().length + 1 > maxChars) return;

    if (char == "=") {
      if (numOf("(") != numOf(")") || lastCharIs(["+", "-", "x", "/"])) {
        return;
      }
      try {
        _chars = Calculate.solve(this).chars;
      } catch (_) {
        _chars = Calculate.fromString("error").chars;
      }
      return;
    }

    if (char == "()") {
      if (_chars.length == 0 || lastChar == "(") {
        add("(");
      } else if (numOf("(") > numOf(")")) {
        if (lastCharIs(["/", "x", "+", "-"])) return;
        add(")");
      } else if (lastCharIs(["/", "x", "+", "-"])) {
        add("(");
      } else {
        add("x(");
      }

      return;
    }

    if (char == "c") {
      clear();
      return;
    }

    if (char == "back") {
      if (length != 0) remove(last);
      return;
    }

    if (char == "+/-") {
      if (currentNumber().length == 0) return;
      replaceCurrentNumber(
          Calculate.fromString("(-${currentNumber().toString()})"));
      return;
    }

    if (char == "." && currentNumber().contains(".")) return;
    if (char == "." && length == 0) {
      add("0.");
      return;
    }

    if (char == "-" && lastCharIs(["/", "x", "-", "+"])) return;

    if ((char == "/" || char == "x" || char == "+") &&
        lastCharIs(["(", "/", "x", "-", "+", ""])) return;

    if ((char == "%" && lastCharIs(["%", "(", "/", "x", "-", "+"]))) return;

    if (_chars == ["0"]) clear();

    add(char);
  }
}
