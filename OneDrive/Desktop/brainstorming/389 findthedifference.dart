class Solution {
  String findTheDifference(String s, String t) {
    int sumS = s.runes.fold(0, (sum, sum2) => sum + sum2);
    int sumT = t.runes.fold(0, (sum, sum2) => sum + sum2);
    return String.fromCharCode(sumT - sumS);
  }
}
