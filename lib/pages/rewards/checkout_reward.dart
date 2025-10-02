import 'package:flutter/material.dart';
import 'package:the_pride/models/reward_model.dart';
import '../../theme/theme.dart';

class CheckoutPage extends StatefulWidget {
  final RewardModel reward;
  final String specification;
  final int quantity;

  const CheckoutPage({
    super.key,
    required this.reward,
    required this.specification,
    required this.quantity,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // Controllers untuk form alamat
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _provinsiController = TextEditingController();
  final TextEditingController _kotaController = TextEditingController();
  final TextEditingController _kecamatanController = TextEditingController();
  final TextEditingController _kelurahanController = TextEditingController();
  final TextEditingController _rtRwController = TextEditingController();
  final TextEditingController _kodePosController = TextEditingController();
  final TextEditingController _telpController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _provinsiController.dispose();
    _kotaController.dispose();
    _kecamatanController.dispose();
    _kelurahanController.dispose();
    _rtRwController.dispose();
    _kodePosController.dispose();
    _telpController.dispose();
    super.dispose();
  }

  Widget catatan() {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.35),
            blurRadius: 8,
            offset: const Offset(8, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text("CATATAN!!!",
              style: errorTextStyle.copyWith(fontWeight: bold, fontSize: 12)),
          Text(
            "* Dengan klik pesan, maka poin Anda akan terpotong sesuai harga reward.",
            style: secondaryTextStyle.copyWith(fontSize: 12, fontWeight: medium),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget formAlamat() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Alamat Tujuan",
          style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.35),
                blurRadius: 8,
                offset: const Offset(8, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: "Nama Lengkap",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(
                  labelText: "Alamat Lengkap",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _provinsiController,
                      decoration: InputDecoration(
                        labelText: "Provinsi",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _kotaController,
                      decoration: InputDecoration(
                        labelText: "Kota/Kabupaten",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _kecamatanController,
                      decoration: InputDecoration(
                        labelText: "Kecamatan",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _kelurahanController,
                      decoration: InputDecoration(
                        labelText: "Kelurahan",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _rtRwController,
                      decoration: InputDecoration(
                        labelText: "RT/RW",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _kodePosController,
                      decoration: InputDecoration(
                        labelText: "Kode Pos",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _telpController,
                decoration: InputDecoration(
                  labelText: "No. Telepon",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget rewardInfo() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.35),
            blurRadius: 8,
            offset: const Offset(8, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(widget.reward.imagePath,
              height: 80, width: 80, fit: BoxFit.cover),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.reward.name,
                  style:
                  primaryTextStyle.copyWith(fontSize: 16, fontWeight: bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Spesifikasi: ${widget.specification}",
                  style: secondaryTextStyle.copyWith(fontSize: 12),
                ),
                Text(
                  "Jumlah: ${widget.quantity}",
                  style: secondaryTextStyle.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalPoints = widget.reward.points * widget.quantity;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            clipBehavior: Clip.none,
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                catatan(),
                const SizedBox(height: 20),
                formAlamat(),
                const SizedBox(height: 20),
                rewardInfo(),
                const Divider(height: 30),
        
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       "Total Poin Dibayar:",
                //       style: primaryTextStyle.copyWith(fontSize: 16),
                //     ),
                //     Row(
                //       children: [
                //         Image.asset("assets/ic_coins_black.png", height: 16),
                //         const SizedBox(width: 4),
                //         Text(
                //           "$totalPoints Pts",
                //           style: primaryTextStyle.copyWith(
                //             fontSize: 16,
                //             fontWeight: bold,
                //             color: kSecondaryColor,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: kWhiteColor,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  "$totalPoints Pts",
                  style: primaryTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: bold,
                    color: kSecondaryColor,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final alamat = {
                      "nama": _namaController.text,
                      "alamatLengkap": _alamatController.text,
                      "provinsi": _provinsiController.text,
                      "kota": _kotaController.text,
                      "kecamatan": _kecamatanController.text,
                      "kelurahan": _kelurahanController.text,
                      "rtRw": _rtRwController.text,
                      "kodePos": _kodePosController.text,
                      "telp": _telpController.text,
                    };

                    if (alamat.values.any((element) => element.isEmpty)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Harap isi semua field alamat!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    print("Data alamat: $alamat");

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Penukaran berhasil!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kSecondaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  child: Text(
                    "Konfirmasi",
                    style: whiteTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
