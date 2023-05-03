class Medicine {
  final String itemName; // 제품명
  final String entpName; // 업체명
  final String effect; // 효능
  final String itemCode; // 품목기준코드
  final String useMethod; // 사용법
  final String warmBeforeHave; // 약 먹기전 알아야할 사항
  final String warmHave; // 약 사용상 주의사항
  final String interaction; // 상호작용
  final String sideEffect; // 부작용
  final String depositMethod; // 보관법

  Medicine({
    required this.itemName,
    required this.entpName,
    required this.effect,
    required this.itemCode,
    required this.useMethod,
    required this.warmBeforeHave,
    required this.warmHave,
    required this.interaction,
    required this.sideEffect,
    required this.depositMethod,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    String removeTag(String x) {
      return x.replaceAll(RegExp("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>"), "");
    }
    try {
      return Medicine(
        itemName: json['itemName'] ?? '알아야 할 내용이 없어요.',
        entpName: json['entpName'] ?? '알아야 할 내용이 없어요.',
        effect: removeTag(json['efcyQesitm'] ?? '알아야 할 내용이 없어요.'),
        itemCode: removeTag(json['itemSeq'] ?? '알아야 할 내용이 없어요.'),
        useMethod: removeTag(json['useMethodQesitm'] ?? '알아야 할 내용이 없어요.'),
        warmBeforeHave: removeTag(json['atpnWarnQesitm'] ?? '알아야 할 내용이 없어요.'),
        warmHave: removeTag(json['atpnQesitm'] ?? '알아야 할 내용이 없어요.'),
        interaction: removeTag(json['intrcQesitm'] ?? '알아야 할 내용이 없어요.'),
        sideEffect: removeTag(json['seQesitm'] ?? '알아야 할 내용이 없어요.'),
        depositMethod: removeTag(json['depositMethodQesitm'] ?? '알아야 할 내용이 없어요.'),
      );
    } catch (e) {
      return Medicine(
        itemName: "no found",
        entpName: "no found",
        effect: "no found",
        itemCode: "no found",
        useMethod: "no found",
        warmBeforeHave: "no found",
        warmHave: "no found",
        interaction: "no found",
        sideEffect: "no found",
        depositMethod: "no found",
      );
    }
  }
}