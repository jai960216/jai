class Solution {
  int lengthOfLastWord(String s) {
    var r = s.trim().split(' ').last.length;
    return r;
  }
}
