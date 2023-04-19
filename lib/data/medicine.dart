class Medicine {
  final String itemName; // 제품명
  final String entpName; // 업체명
  final String effect; // 효능
  final String itemCode; // 품목기준코드
  final String useMethod; // 사용법
  final String warmbeforeHave; // 약 먹기전 알아야할 사항
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
    required this.warmbeforeHave,
    required this.warmHave,
    required this.interaction,
    required this.sideEffect,
    required this.depositMethod,
  });

  factory Medicine.fromJson(Map<String, dynamic> json, int idx) {
    String removeTag(String x) {
      return x.replaceAll(RegExp("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>"), "");
    }

    try {
      return Medicine(
        itemName: json['body']['items'][idx]['itemName'] ?? 'null',
        entpName: json['body']['items'][idx]['entpName'] ?? 'null',
        effect: removeTag(json['body']['items'][idx]['efcyQesitm'] ?? 'null'),
        itemCode: removeTag(json['body']['items'][idx]['itemSeq'] ?? 'null'),
        useMethod: removeTag(json['body']['items'][idx]['useMethodQesitm'] ?? 'null'),
        warmbeforeHave: removeTag(json['body']['items'][idx]['atpnWarnQesitm'] ?? 'null'),
        warmHave: removeTag(json['body']['items'][idx]['atpnQesitm'] ?? 'null'),
        interaction: removeTag(json['body']['items'][idx]['intrcQesitm'] ?? 'null'),
        sideEffect: removeTag(json['body']['items'][idx]['seQesitm'] ?? 'null'),
        depositMethod: removeTag(json['body']['items'][idx]['depositMethodQesitm'] ?? 'null'),
      );
    } catch (e) {
      return Medicine(
        itemName: "no found",
        entpName: "no found",
        effect: "no found",
        itemCode: "no found",
        useMethod: "no found",
        warmbeforeHave: "no found",
        warmHave: "no found",
        interaction: "no found",
        sideEffect: "no found",
        depositMethod: "no found",
      );
    }
  }
}
