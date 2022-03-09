class MedicalModal {
  String imageBase64, imagename, puid;
  MedicalModal({
    this.imageBase64,
    this.imagename,
    this.puid,
  });
  factory MedicalModal.fromJson(Map<String, dynamic> json) {
    return MedicalModal(
      imageBase64: json['imageBase64'] as String,
      imagename: json['imagename'] as String,
      puid: json['puid'] as String,
    );
  }
  Map<String, dynamic> toJsonAdd() {
    return {
      'imageBase64': imageBase64,
      'imagename': imagename,
      'puid': puid,
    };
  }
}
