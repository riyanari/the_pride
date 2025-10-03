import 'package:flutter/material.dart';
import 'package:the_pride/models/reward_model.dart';

import '../../theme/theme.dart';
import 'checkout_reward.dart';

class DetailRewardPage extends StatefulWidget {
  final RewardModel reward;

  const DetailRewardPage({super.key, required this.reward});

  @override
  State<DetailRewardPage> createState() => _DetailRewardPageState();
}

class _DetailRewardPageState extends State<DetailRewardPage> {
  // Variabel untuk menyimpan pilihan spesifikasi
  String? _selectedSpecification;

  // Variabel untuk menyimpan jumlah yang dipilih
  int _quantity = 1;

  Widget bottomSheet(BuildContext context, void Function(void Function()) setModalState) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.reward.name,
            style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: medium),
          ),
          Row(
            children: [
              Image.asset("assets/ic_coins_black.png", height: 14,),
              Text("${widget.reward.points} Pts", style: primaryTextStyle,),
            ],
          ),
          Divider(),
          // Pilih Spesifikasi
          Text(
            "Spesifikasi",
            style: primaryTextStyle.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 10),

          // Spesifikasi Wrap/Grid
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: widget.reward.spesifikasi.map((String value) {
              bool isSelected = _selectedSpecification == value;

              return GestureDetector(
                onTap: () {
                  setModalState(() {
                    _selectedSpecification = value;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? kSecondaryColor.withValues(alpha:0.2) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? kSecondaryColor : Colors.grey,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    value,
                    style: primaryTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: medium,
                      color: isSelected ? kSecondaryColor : Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Pilih Jumlah
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Jumlah", style: primaryTextStyle.copyWith(fontSize: 16)),

              // Container untuk tombol +/- dan angka
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    // Tombol Minus
                    IconButton(
                      onPressed: () {
                        setModalState(() {
                          if (_quantity > 1) {
                            _quantity--;
                          }
                        });
                      },
                      icon: Icon(Icons.remove, size: 18),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      constraints: BoxConstraints(),
                    ),

                    // Angka
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.symmetric(
                          vertical: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      child: Text(
                        _quantity.toString(),
                        style: primaryTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: medium,
                        ),
                      ),
                    ),

                    // Tombol Plus
                    IconButton(
                      onPressed: () {
                        setModalState(() {
                          _quantity++;
                        });
                      },
                      icon: Icon(Icons.add, size: 18),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Informasi Total Poin
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kSecondaryColor.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Poin Dibayar:", style: primaryTextStyle.copyWith(fontWeight: medium)),
                Row(
                  children: [
                    Image.asset("assets/ic_coins_black.png", height: 16),
                    SizedBox(width: 4),
                    Text(
                      "${widget.reward.points * _quantity} Pts",
                      style: primaryTextStyle.copyWith(
                        fontWeight: bold,
                        color: kSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Tombol Konfirmasi
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedSpecification == null
                  ? null
                  : () {
                // Aksi konfirmasi pemesanan
                _confirmExchange();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedSpecification == null
                    ? Colors.grey[300]
                    : kSecondaryColor,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Tukar Sekarang",
                style: whiteTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method untuk konfirmasi penukaran
  void _confirmExchange() {
    if (_selectedSpecification == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pilih spesifikasi terlebih dahulu"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(
          reward: widget.reward,
          specification: _selectedSpecification!,
          quantity: _quantity,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Background atas
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: kBoxGreyColor,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.35),
                    blurRadius: 8,
                    offset: const Offset(8, 4),
                  ),
                ],
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: double.infinity,
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
                ),
              ),
            ),
      
            // Gambar Reward
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                      // widget.reward.imagePath,
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 14.0),
                      child: Image.asset(
                        widget.reward.imagePath.isNotEmpty ? widget.reward.imagePath : "assets/no_img.png",
                        height: MediaQuery.of(context).size.height * 0.35,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          // fallback kalau file benar-benar tidak ada
                          return Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Image.asset(
                              "assets/no_img.png",
                              height: MediaQuery.of(context).size.height * 0.30,
                              fit: BoxFit.contain,
                            ),
                          );
                        },
                      ),
                    )
                  ),
                ],
              ),
            ),
      
            // Konten utama yang bisa di-scroll
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 30),
                clipBehavior: Clip.none,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.35),
      
                    // Nama Reward
                    Text(
                      widget.reward.name,
                      style: whiteTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: bold,
                      ),
                    ),
                    Text(
                      "Semarang",
                      style: whiteTextStyle.copyWith(fontSize: 10),
                    ),
                    const SizedBox(height: 20),
      
                    // Deskripsi dan Syarat
                    SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      child: Row(
                        children: [
                          // Container Deskripsi
                          Container(
                            padding: const EdgeInsets.all(18),
                            height: 300,
                            width: MediaQuery.of(context).size.width * 0.85,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: kWhiteColor,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: kGreyColor.withValues(alpha:0.9),
                                  blurRadius: 4,
                                  offset: const Offset(2, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Deskripsi",
                                  style: primaryTextStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.reward.description,
                                  style: primaryTextStyle.copyWith(
                                    fontSize: 12,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),
      
                          // Container Syarat
                          Container(
                            padding: const EdgeInsets.all(18),
                            height: 300,
                            width: MediaQuery.of(context).size.width * 0.85,
                            decoration: BoxDecoration(
                              color: kWhiteColor,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: kGreyColor.withValues(alpha:0.9),
                                  blurRadius: 4,
                                  offset: const Offset(2, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Syarat",
                                  style: primaryTextStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Masukkan syarat-syarat di sini.",
                                  style: primaryTextStyle.copyWith(
                                    fontSize: 12,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
      
            // Row Poin dan Tombol Tukar yang selalu terlihat di bawah
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: kWhiteColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Poin
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.0),
                        child: Row(
                          children: [
                            Image.asset("assets/ic_coins_black.png", height: 16),
                            SizedBox(width: 4),
                            Text(
                              "${widget.reward.points.toString()} Pts",
                              style: primaryTextStyle.copyWith(
                                fontSize: 12,
                                fontWeight: medium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
      
                    // Tombol Tukar
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Reset state setiap kali bottom sheet dibuka
                          setState(() {
                            _selectedSpecification = null;
                            _quantity = 1;
                          });
      
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (context, setModalState) {
                                  return bottomSheet(context, setModalState);
                                },
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kSecondaryColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        child: Text(
                          "Tukar",
                          style: whiteTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}