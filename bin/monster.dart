import 'dart:math';
import 'character.dart';

class Monster {
  String mname;
  int mhealth;
  int mattack;
  int defense;
  late int maxHealth; // 원래 체력을 저장하는 변수 추가

  Monster(this.mname, this.mhealth, this.mattack, this.defense) {
    maxHealth = mhealth; // 생성 시 maxHealth에 원래 체력 저장
  }

  void restoreHealth() {
    mhealth = maxHealth; // 무한 모드에서 전투 시작 시 체력 초기화
  }

  void attackCharacter(Character character, bool isDefending) {
    if (isDefending) {
      character.defend(mattack); // 방어했을 때는 defend() 호출
    } else {
      character.health -= mattack; //  방어 안 했을 때는 풀 데미지 적용
      print('$mname이(가) ${character.name}을(를) 공격했습니다! (데미지: $mattack)');
    }
  }

  void increaseDefense() {
    defense += 3;
    print('$mname의 방어력이 증가했습니다! 현재 방어력: $defense'); //행동마다 방어력 증가
  }

  void takeDamage(int damage) {
    int actualDamage = max(0, damage - defense); //방어를 뺀 실제 데미지
    mhealth -= actualDamage;
    print('$mname이(가) 공격받았습니다! (받은 피해: $actualDamage)');
  }

  void showStatus() {
    print('[$mname] 체력: $mhealth | 공격력: $mattack | 방어력: $defense');
  }
}
