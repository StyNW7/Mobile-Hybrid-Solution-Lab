void main() {
  print("=== DART BASIC DEMO ===\n");

  // 1. Variable & Tipe Data
  int umur = 20;
  double ipk = 3.75;
  String nama = "Stanley";
  bool isActive = true;

  print("Nama: $nama");
  print("Umur: $umur");
  print("IPK: $ipk");
  print("Status Aktif: $isActive\n");

  // 2. String Interpolation
  print("Halo, nama saya $nama dan saya berumur $umur tahun.\n");

  // 3. final dan const
  final String kampus = "BINUS University";
  const int tahunMasuk = 2022;

  print("Kampus: $kampus");
  print("Tahun Masuk: $tahunMasuk\n");

  // 4. Selection (if - else)
  if (ipk >= 3.5) {
    print("Predikat: Cumlaude\n");
  } else if (ipk >= 3.0) {
    print("Predikat: Sangat Memuaskan\n");
  } else {
    print("Predikat: Memuaskan\n");
  }

  // 5. Repetition (Loop)
  print("Perulangan for:");
  for (int i = 1; i <= 5; i++) {
    print("Perulangan ke-$i");
  }
  print("");

  // 6. List
  List<String> matkul = ["Mobile", "Web", "AI"];
  matkul.add("Network");

  print("Daftar Mata Kuliah:");
  for (var m in matkul) {
    print("- $m");
  }
  print("");

  // 7. Set (Data Unik)
  Set<String> organisasi = {"HIMTI", "BSLC", "HIMTI"};
  print("Organisasi (tanpa duplikat): $organisasi\n");

  // 8. Map (Key - Value)
  Map<String, int> nilai = {
    "Mobile": 90,
    "Web": 85,
    "AI": 95,
  };

  print("Nilai Mata Kuliah:");
  nilai.forEach((key, value) {
    print("$key : $value");
  }); 
  print("");

  // 9. Method / Function
  int hasil = tambah(10, 20);
  print("Hasil penjumlahan: $hasil");
}

// Method
int tambah(int a, int b) {
  return a + b;
}