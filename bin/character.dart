// character.dart
import 'dart:math';
import 'monster.dart';

class Character {
  String name;
  int health;
  int attack;
  int defense;

  Character(this.name, this.health, this.attack, this.defense);

  void attackMonster(Monster monster) {
    int damage = max(0, attack - monster.defense); // 방어력을 고려한 피해 계산
    monster.mhealth -= damage; // 몬스터 체력에서 damage만큼 감소
    print('$name이(가) ${monster.mname}을(를) 공격했습니다! (데미지: $damage)');
  }

  void defend(int damage) {
    int reducedDamage = max(0, damage - defense); // 음수 방지 기능
    health -= reducedDamage;
    print('$name이(가) 방어했습니다! $reducedDamage데미지를 받았습니다!'); //방어한 데미지
  }

  void showStatus() {
    print('[$name] 체력: $health | 공격력: $attack | 방어력: $defense'); // 캐릭터 스탯 출력
  }
}
