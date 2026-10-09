import 'dart:io';

void main() {
  // Data awal akun
  String correctPassword = "112233";
  double saldo = 1000000; // Saldo awal contoh sebesar Rp 1.000.000
  bool isAuthorized = false;

  print("=== SELAMAT DATANG DI BANK DIGITAL ===");

  // 1. Sistem meminta pengguna memasukkan password
  for (int attempt = 3; attempt > 0; attempt--) {
    stdout.write("Masukkan password Anda: ");
    String? inputPassword = stdin.readLineSync();

    if (inputPassword == correctPassword) {
      isAuthorized = true;
      print("Login berhasil!\n");
      break;
    } else {
      print("Password salah! Sisa kesempatan: ${attempt - 1}\n");
    }
  }

  // Jika password salah 3 kali, keluar program
  if (!isAuthorized) {
    print("Akses diblokir. Anda telah salah memasukkan password sebanyak 3 kali.");
    return;
  }

  // 2. Jika password benar, muncul menu pilihan
  bool isRunning = true;
  while (isRunning) {
    print("\n====================");
    print("    MENU UTAMA ATM");
    print("====================");
    print("1. Cek Saldo");
    print("2. Setor Tunai");
    print("3. Tarik Tunai");
    print("4. Keluar");
    stdout.write("Silakan pilih menu (1-4): ");
    
    String? pilihan = stdin.readLineSync();

    switch (pilihan) {
      case '1':
        // 3. Cek Saldo
        print("\n--- Informasi Saldo ---");
        print("Saldo Anda saat ini adalah: Rp ${formatRupiah(saldo)}");
        break;

      case '2':
        // 4. Setor Tunai
        print("\n--- Setor Tunai ---");
        stdout.write("Masukkan nominal uang yang ingin disetor (Rp): ");
        String? inputSetor = stdin.readLineSync();
        
        double? nominalSetor = double.tryParse(inputSetor ?? '');
        if (nominalSetor != null && nominalSetor > 0) {
          saldo += nominalSetor;
          print("Setor tunai berhasil!");
          print("Saldo Anda sekarang: Rp ${formatRupiah(saldo)}");
        } else {
          print("Nominal tidak valid!");
        }
        break;

      case '3':
        // 5. Tarik Tunai dengan pilihan pecahan
        print("\n--- Tarik Tunai ---");
        stdout.write("Masukkan nominal uang yang ingin ditarik (Rp): ");
        String? inputTarik = stdin.readLineSync();
        
        double? nominalTarik = double.tryParse(inputTarik ?? '');
        if (nominalTarik == null || nominalTarik <= 0) {
          print("Nominal tidak valid!");
          break;
        }

        if (nominalTarik > saldo) {
          print("Maaf, saldo Anda tidak mencukupi untuk penarikan ini.");
          break;
        }

        // Cek apakah nominal kelipatan yang wajar
        if (nominalTarik % 50000 != 0) {
          print("Maaf, penarikan harus kelipatan Rp 50.000 atau Rp 100.000.");
          break;
        }

        print("\nPilih pecahan uang:");
        print("1. Pecahan Rp 50.000");
        print("2. Pecahan Rp 100.000");
        stdout.write("Pilihan pecahan (1/2): ");
        String? pilihanPecahan = stdin.readLineSync();

        int pecahan = 0;
        if (pilihanPecahan == '1') {
          pecahan = 50000;
        } else if (pilihanPecahan == '2') {
          pecahan = 100000;
        } else {
          print("Pilihan pecahan tiidak valid.");
          break;
        }

        // Hitung jumlah lembar uang
        int jumlahLembar = (nominalTarik ~/ pecahan);

        // Validasi apakah nominal bisa dibagi pecahan tersebut
        if (nominalTarik % pecahan != 0) {
          print("Nominal tidak dapat dibagi habis dengan pecahan Rp ${formatRupiah(pecahan.toDouble())}.");
          break;
        }

        // Potong saldo otomatis dan tampilkan informasi
        saldo -= nominalTarik;
        print("\nPenarikan tunai berhasil!");
        print("Anda akan menerima uang pecahan Rp ${formatRupiah(pecahan.toDouble())} sebanyak $jumlahLembar lembar.");
        print("Sisa saldo Anda: Rp ${formatRupiah(saldo)}");
        break;

      case '4':
        print("\nTerima kasih telah menggunakan layanan bank kami.");
        isRunning = false;
        break;

      default:
        print("Pilihan tidak valid, silakan pilih menu 1 sampai 4.");
    }
  }
}

// Fungsi pembantu sederhana untuk format angka agar mudah dibaca (opsional)
String formatRupiah(double angka) {
  return angka.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
}