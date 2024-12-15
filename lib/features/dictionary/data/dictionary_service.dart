// ignore_for_file: public_member_api_docs, sort_constructors_first
class DictionaryButton {
  String audio;
  String name;

  DictionaryButton({
    required this.audio,
    required this.name,
  });

  static Future<List<DictionaryButton>> generateButton() async {
    final Map<String, String> audioNameMap = {
      "alif.wav": "ا",
      "ba.wav": "ب",
      "ta.wav": "ت",
      "tha.wav": "ث",
      "jim.wav": "ج",
      "ca.wav": "چ",
      "ha!.wav": "ح",
      "kho.wav": "خ",
      "dal.wav": "د",
      "dzal.wav": "ذ",
      "ro.wav": "ر",
      "zal.wav": "ز",
      "sin.wav": "س",
      "syin.wav": "ش",
      "sod.wav": "ص",
      "dhod.wav": "ض",
      "tho.wav": "ط",
      "dzho.wav": "ظ",
      "ain.wav": "ع",
      "ghain.wav": "غ",
      "nga.wav": "ڠ",
      "fa.wav": "ف",
      "pa.wav": "ڤ",
      "qaf.wav": "ق",
      "kaf.wav": "ک",
      "ga.wav": "ݢ",
      "lam.wav": "ل",
      "mim.wav": "م",
      "nun.wav": "ن",
      "wau.wav": "و",
      "va.wav": "ۏ",
      "ha.wav": "ه",
      "lam alif.wav": "لا",
      "hamzah.wav": "ء",
      "ya.wav": "ي",
      "nya.wav": "ڽ",
    };

    return audioNameMap.entries
        .map((entry) => DictionaryButton(
              audio: "audios/${entry.key}",
              name: entry.value,
            ))
        .toList();
  }
}
