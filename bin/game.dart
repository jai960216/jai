import 'dart:io';
import 'dart:math';
import 'character.dart';
import 'monster.dart';
import 'utils.dart';

class Game {
  List<String> inventory = [];
  late Character character;
  List<Monster> monsters = [];
  int defeatedMonsters = 0;
  bool isInfiniteMode = false; // 무한 모드 여부

  void startGame() {
    character = loadCharacterStats();
    monsters = loadMonsterStats();

    if (monsters.isEmpty) {
      print('몬스터 데이터를 불러오는 데 실패했습니다.');
      return;
    }

    // 게임 모드 선택
    selectGameMode();

    print('몬스터 총 ${monsters.length}마리');
    print('게임을 시작합니다!');

    while (character.health > 0) {
      battle();

      // 캐릭터가 패배하면 즉시 종료 (nextBattlePrompt 호출 안 함)
      if (character.health <= 0) {
        return;
      }

      if (!isInfiniteMode && defeatedMonsters >= 3) {
        // 무한 모드가 아니고, 몬스터 3마리 처치 시 종료
        print('축하합니다! 일반 모드에서 모든 몬스터를 물리쳤습니다.');
        saveResult(character, "승리");
        return;
      }

      nextBattlePrompt(); // 캐릭터가 살아있을 때만 next battle 실행됨
    }
  }

  void selectGameMode() {
    // 게임모드 선택, 설정
    while (true) {
      stdout.write('게임 모드를 선택하세요: [1] 일반 모드 [2] 무한 모드 : ');
      String? input = stdin.readLineSync();

      if (input == '1') {
        isInfiniteMode = false;
        print('일반 모드를 선택했습니다.');
        return;
      } else if (input == '2') {
        isInfiniteMode = true;
        print('무한 모드를 선택했습니다.');
        return;
      } else {
        print('잘못된 입력입니다. 1 또는 2를 입력하세요.');
      }
    }
  }

  void battle() {
    Monster? monster = getRandomMonster(); //몬스터가 없을떄 null
    if (monster == null) {
      print('더 이상 싸울 몬스터가 없습니다.');
      return;
    }

    // 무한 모드에서는 몬스터 체력을 원래 값으로 복구
    if (isInfiniteMode) {
      monster.restoreHealth();
    }

    print('새로운 전투 시작! ${monster.mname} 등장!');

    while (character.health > 0 && monster.mhealth > 0) {
      character.showStatus();
      monster.showStatus();

      stdout.write('행동을 선택하세요 (1: 공격, 2: 방어, 3: 아이템 사용): ');
      String? choice = stdin.readLineSync();

      bool isDefending = false; // 변수 선언 및 초기화

      if (choice == '1') {
        character.attackMonster(monster);
        checkActionBonus(character);
      } else if (choice == '2') {
        isDefending = true; // 방어 상태 설정
        checkActionBonus(character);
      } else if (choice == '3') {
        useItem(inventory, character);
        character.showStatus();
        checkActionBonus(character);
      }

      // 몬스터가 살아있다면 반격
      if (monster.mhealth > 0) {
        monster.attackCharacter(character, isDefending);
        print("--------------------------------------------");
      }

      // 반격 후 체력이 0이면 패배 처리
      if (character.health <= 0) {
        print('게임 오버! ${character.name}이 패배했습니다.');
        saveResult(character, "패배");
        return;
      }
    }

    // 몬스터가 죽었을 때 전투 종료 처리
    print('${monster.mname}을(를) 처치했습니다!');
    print("--------------------------------------------");
    gainItem();
    defeatedMonsters++;

    if (!isInfiniteMode) {
      monsters.remove(monster);
    }

    print('현재 남은 몬스터 수: ${monsters.length}, 처치한 몬스터 수: $defeatedMonsters');
  }

  Monster? getRandomMonster() {
    if (monsters.isEmpty) {
      return null; // 리스트가 비어 있으면 null 반환
    }
    return monsters[Random().nextInt(monsters.length)]; //null이 아니면 랜덤몬스터 출력
  }

  void nextBattlePrompt() {
    while (true) {
      stdout.write('다음 몬스터와 대결하시겠습니까? (y/n): '); // 다음 전투 진행 페이즈
      String? input =
          stdin.readLineSync()?.toLowerCase(); // 정확한 값 입력을 위해 소문자로 통일

      if (input == 'y') {
        return;
      } else if (input == 'n') {
        print('게임을 종료합니다.');
        saveResult(character, "종료");
        exit(0);
      } else {
        print('잘못된 입력입니다. y 또는 n을 입력하세요.'); // 오입력 시 출력
      }
    }
  }

  void gainItem() {
    // 아이템 획득
    print('몬스터를 물리쳤습니다! 보상을 선택하세요:');
    print('1. 검, 공격력 +15');
    print('2. 물약, 체력 +50');
    print('3. 방패, 방어력 +15');
    stdout.write('선택 (1/2/3): ');

    String? choice = stdin.readLineSync(); // 아이템 선택
    if (choice == '1') {
      inventory.add('검, 공격력 +15');
      print('공격력 +15 아이템을 획득했습니다!');
      print("--------------------------------------------");
    } else if (choice == '2') {
      inventory.add('물약, 체력 +50');
      print('체력 +50 아이템을 획득했습니다!');
      print("--------------------------------------------");
    } else if (choice == '3') {
      inventory.add('방패, 방어력 +15');
      print('방어력 +15 아이템을 획득했습니다!');
      print("--------------------------------------------");
    } else {
      print('잘못된 선택입니다. 아이템을 획득하지 못했습니다.');
    }
  }
}
