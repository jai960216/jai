import 'dart:io';
import 'dart:math';
import 'character.dart';
import 'monster.dart';

Character loadCharacterStats() {
  final file = File('characters.txt');
  try {
    final contents = file.readAsLinesSync();
    Map<String, List<int>> characterData = {}; //캐릭터 데이터 형식

    stdout.write('캐릭터 이름을 입력하세요: ');
    String? name = stdin.readLineSync(); //이름 입력
    while (name == null ||
        name.isEmpty ||
        !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(name)) {
      //입력 가능 범위설정
      stdout.write('올바른 이름을 입력하세요 (영문, 숫자만 허용): '); //이름 입력 제한, 조건
      name = stdin.readLineSync();
    }

    // 종족 데이터 읽어오기
    for (var line in contents) {
      final stats = line.split(',');
      if (stats.length != 4) continue;
      characterData[stats[0].trim()] = [
        //종족 이름
        int.parse(stats[1].trim()), // 체력
        int.parse(stats[2].trim()), // 공격력
        int.parse(stats[3].trim()), // 방어력
      ];
    }

    // 종족 출력
    print('캐릭터 종족을 선택하세요:');
    characterData.keys.toList().asMap().forEach((index, race) {
      //캐릭터 정보를 순차적으로 바꿔서 1.인간 2.드워프 3.엘프로 출력
      print(
        '${index + 1}. $race [체력: ${characterData[race]![0]}, 공격력: ${characterData[race]![1]}, 방어력: ${characterData[race]![2]}]', //정보 출력
      );
    });

    stdout.write('선택 (번호 입력): '); // 종족 선택
    String? choice = stdin.readLineSync(); // 선택 입력
    int? selectedIndex = int.tryParse(choice ?? '');
    if (selectedIndex == null ||
        selectedIndex < 1 ||
        selectedIndex > characterData.length) {
      print('잘못된 선택입니다. 기본 종족이 선택됩니다.'); // 잘못 선택하면 기본 종족 선택
      selectedIndex = 1;
    }
    String selectedRace =
        characterData.keys.toList()[selectedIndex - 1]; // 유저 입력값 -> 인덱스 값 바꾸기

    return Character(
      //선택종족 객채
      name,
      characterData[selectedRace]![0], //체력
      characterData[selectedRace]![1], //공격력
      characterData[selectedRace]![2], //방어력
    );
  } catch (e) {
    //예외처리, 캐릭터 로드 실패
    print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
    exit(1);
  }
}

void useItem(List<String> inventory, Character character) {
  //아이템 사용
  if (inventory.isEmpty) {
    //아이템 리스트가 비어있으면 출력력
    print('사용할 아이템이 없습니다!');
    return;
  }
  print('사용할 아이템을 선택하세요:'); //아이템이 존재할경우 아이템 리스트 출력
  for (int i = 0; i < inventory.length; i++) {
    print('${i + 1}. ${inventory[i]}');
  }
  stdout.write('선택 (번호 입력): ');
  String? choice = stdin.readLineSync(); //아이템 선택 입력
  int? index = int.tryParse(choice ?? '');

  if (index == null || index < 1 || index > inventory.length) {
    //아이템 리스트보다 큰 값 입력시 출력
    print('잘못된 선택입니다.');
    return;
  }

  String selectedItem = inventory[index - 1]; //선택된 아이템

  if (!inventory.contains(selectedItem)) {
    print('선택한 아이템이 인벤토리에 없습니다.'); //없는 아이템 번호 입력시 출력
    return;
  }

  if (selectedItem == '검, 공격력 +15') {
    //아이템 정보 및 적용 정보
    character.attack += 15;
    print('공격력이 15 증가했습니다! 현재 공격력: ${character.attack}');
  } else if (selectedItem == '물약, 체력 +50') {
    character.health += 50;
    print('체력이 50 증가했습니다! 현재 체력: ${character.health}');
  } else if (selectedItem == '방패, 방어력 +15') {
    character.defense += 15;
    print('방어력이 15 증가했습니다! 현재 방어력: ${character.defense}');
  }

  inventory.removeAt(index - 1); //인벤토리에서 아이템 제거
}

void checkActionBonus(Character character) {
  //action 이후 30%확률로 체력 회복
  if (Random().nextDouble() < 0.3) {
    character.health += 10;
    print('보너스 체력을 얻었습니다! 현재 체력: ${character.health}');
  }
}

List<Monster> loadMonsterStats() {
  List<Monster> monsters = [];
  try {
    final file = File('monsters.txt');
    final contents = file.readAsLinesSync();
    for (var line in contents) {
      final stats = line.split(',');
      if (stats.length != 4) continue;

      String name = stats[0].trim(); // 몬스터 이름
      int health = int.parse(stats[1].trim()); // 체력
      int maxAttack = int.parse(stats[2].trim()); // 최대 공격력
      int defense = int.parse(stats[3].trim()); // 방어력

      int randomAttack = Random().nextInt(
        maxAttack + 1,
      ); //  0 ~ maxAttack 범위의 랜덤 공격력

      monsters.add(
        Monster(
          name,
          health,
          randomAttack, //  랜덤한 공격력 적용
          defense,
        ),
      );
    }
  } catch (e) {
    print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
    exit(1);
  }
  return monsters;
}

void saveResult(Character character, String result) {
  //결과 저장
  stdout.write('결과를 저장하시겠습니까? (y/n): ');
  String? input = stdin.readLineSync();
  if (input?.toLowerCase() == 'y') {
    final file = File('result.txt');
    file.writeAsStringSync('${character.name},${character.health},$result');
    print('결과가 저장되었습니다.');
  }
}
