class Solution {
  bool isAnagram(String s, String t) {
    List<String> slist = s.split("");
    List<String> tlist = t.split("");
    slist.sort();
    tlist.sort();
    String ssort = slist.join();
    String tsort = tlist.join();
    print(ssort);
    print(tsort);
    return ssort == tsort;

    //알파벳 단위로 쪼개기 split
    //리스트타입으로 변환 list
    //정렬 sort
    //문자로 되돌리기 join
    //서로 같은지 return
  }
}
