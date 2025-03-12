import 'dart:io';

void main() {
  ShoppingMall mall = ShoppingMall([
    Product("shirt", 45000),
    Product("원피스", 30000),
    Product("반팔티", 35000),
    Product("반바지", 38000),
    Product("양말", 5000),
  ]);

  while (true) {
    print("");
    print("[1] 상품 목록 보기 / [2] 장바구니에 담기 / [3] 총 가격 보기 / [4] 종료");
    stdout.write("원하는 기능의 번호를 입력하세요: ");
    String? input = stdin.readLineSync();

    if (input == "1") {
      mall.showProducts();
    } else if (input == "2") {
      mall.addToCart();
    } else if (input == "3") {
      mall.showTotal();
    } else if (input == "4") {
      print("이용해 주셔서 감사합니다 ~ 안녕히 가세요 !");
      break;
    } else {
      print("지원하지 않는 기능입니다 ! 다시 시도해 주세요 ..");
    }
  }
}

class Product {
  String name;
  int price;

  Product(this.name, this.price);
}

class ShoppingMall {
  final List<Product> products;
  int totalPrice = 0;

  ShoppingMall(this.products);

  void showProducts() {
    print("");
    print("상품 목록:");
    for (var product in products) {
      print("${product.name} / ${product.price}원");
    }
  }

  void addToCart() {
    print("장바구니에 담을 상품 이름을 입력하세요:");
    String? productName = stdin.readLineSync();

    if (productName == null || productName.isEmpty) {
      print("입력값이 올바르지 않아요 !");
      return;
    }

    Product? selectedProduct;
    try {
      selectedProduct = products.firstWhere((p) => p.name == productName);
    } catch (e) {
      print("입력값이 올바르지 않아요 !");
      return;
    }

    print("상품 개수를 입력하세요:");
    String? quantityInput = stdin.readLineSync();

    try {
      if (quantityInput == null || quantityInput.isEmpty) {
        throw FormatException();
      }
      int quantity = int.parse(quantityInput);
      if (quantity <= 0) {
        print("0개보다 많은 개수의 상품만 담을 수 있어요 !");
        return;
      }
      totalPrice += selectedProduct.price * quantity;
      print("장바구니에 상품이 담겼어요 !");
    } catch (e) {
      print("입력값이 올바르지 않아요 !");
    }
  }

  void showTotal() {
    print("장바구니에 $totalPrice원 어치를 담으셨네요 !");
  }
}
