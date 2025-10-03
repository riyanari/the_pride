import 'package:flutter/material.dart';
import 'package:the_pride/models/reward_model.dart';
import '../../services/wilayah/wilayah_service.dart';
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
  final TextEditingController _rtRwController = TextEditingController();
  final TextEditingController _kodePosController = TextEditingController();
  final TextEditingController _telpController = TextEditingController();

  // State untuk dropdown wilayah
  List<dynamic> _provinces = [];
  List<dynamic> _regencies = [];
  List<dynamic> _districts = [];
  List<dynamic> _villages = [];

  String? _selectedProvince;
  String? _selectedRegency;
  String? _selectedDistrict;
  String? _selectedVillage;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  Future<void> _loadProvinces() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final prov = await WilayahService.getProvinces();
      setState(() {
        _provinces = prov;
      });
    } catch (e) {
      _showErrorSnackBar('Gagal memuat data provinsi');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadRegencies(String provinceId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final reg = await WilayahService.getRegencies(provinceId);
      setState(() {
        _regencies = reg;
        _districts = [];
        _villages = [];
        _selectedRegency = null;
        _selectedDistrict = null;
        _selectedVillage = null;
      });
    } catch (e) {
      _showErrorSnackBar('Gagal memuat data kabupaten/kota');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadDistricts(String regencyId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final dist = await WilayahService.getDistricts(regencyId);
      setState(() {
        _districts = dist;
        _villages = [];
        _selectedDistrict = null;
        _selectedVillage = null;
      });
    } catch (e) {
      _showErrorSnackBar('Gagal memuat data kecamatan');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadVillages(String districtId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final vill = await WilayahService.getVillages(districtId);
      setState(() {
        _villages = vill;
        _selectedVillage = null;
      });
    } catch (e) {
      _showErrorSnackBar('Gagal memuat data kelurahan');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: kWhiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Icon(
              Icons.check_circle,
              color: kSecondaryColor,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              "Penukaran Berhasil!",
              style: primaryTextStyle.copyWith(
                fontSize: 20,
                fontWeight: bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Text(
          "Reward Anda akan segera dikirim ke alamat yang telah ditentukan. Terima kasih telah menggunakan layanan kami.",
          style: secondaryTextStyle.copyWith(fontSize: 14),
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kSecondaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Kembali ke Beranda",
                style: whiteTextStyle.copyWith(fontWeight: medium),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _rtRwController.dispose();
    _kodePosController.dispose();
    _telpController.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kSecondaryColor.withValues(alpha:0.1), kSecondaryColor.withValues(alpha:0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                color: kSecondaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                "Checkout Reward",
                style: primaryTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Lengkapi data pengiriman untuk menerima reward Anda",
            style: secondaryTextStyle.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kSecondaryColor.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kSecondaryColor.withValues(alpha:0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Penting!",
                  style: errorTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Dengan mengkonfirmasi penukaran, poin Anda akan terpotong sesuai harga reward dan tidak dapat dikembalikan.",
                  style: errorTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: medium,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: kSecondaryColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              "Alamat Pengiriman",
              style: primaryTextStyle.copyWith(
                fontSize: 18,
                fontWeight: bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.1),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildTextField(
                controller: _namaController,
                label: "Nama Lengkap",
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _alamatController,
                label: "Alamat Lengkap",
                icon: Icons.home_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildDropdownSection(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _rtRwController,
                      label: "RT/RW",
                      icon: Icons.numbers_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _kodePosController,
                      label: "Kd. Pos",
                      icon: Icons.local_post_office_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _telpController,
                label: "Nomor Telepon",
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: secondaryTextStyle,
        prefixIcon: Icon(icon, color: kSecondaryColor.withValues(alpha:0.7)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kSecondaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      style: primaryTextStyle,
    );
  }

  Widget _buildDropdownSection() {
    return Column(
      children: [
        _buildDropdown(
          value: _selectedProvince,
          items: _provinces,
          label: "Provinsi",
          icon: Icons.map_outlined,
          onChanged: (value) {
            setState(() {
              _selectedProvince = value;
            });
            if (value != null) _loadRegencies(value);
          },
        ),
        if (_selectedProvince != null) const SizedBox(height: 12),
        if (_selectedProvince != null)
          _buildDropdown(
            value: _selectedRegency,
            items: _regencies,
            label: "Kota/Kabupaten",
            icon: Icons.location_city_outlined,
            onChanged: (value) {
              setState(() {
                _selectedRegency = value;
              });
              if (value != null) _loadDistricts(value);
            },
          ),
        if (_selectedRegency != null) const SizedBox(height: 12),
        if (_selectedRegency != null)
          _buildDropdown(
            value: _selectedDistrict,
            items: _districts,
            label: "Kecamatan",
            icon: Icons.place_outlined,
            onChanged: (value) {
              setState(() {
                _selectedDistrict = value;
              });
              if (value != null) _loadVillages(value);
            },
          ),
        if (_selectedDistrict != null) const SizedBox(height: 12),
        if (_selectedDistrict != null)
          _buildDropdown(
            value: _selectedVillage,
            items: _villages,
            label: "Kelurahan",
            icon: Icons.house_outlined,
            onChanged: (value) {
              setState(() {
                _selectedVillage = value;
              });
            },
          ),
      ],
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<dynamic> items,
    required String label,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items.map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          value: item["id"].toString(),
          child: Text(
            item["name"],
            style: primaryTextStyle,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: secondaryTextStyle,
        prefixIcon: Icon(icon, color: kSecondaryColor.withValues(alpha:0.7)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kSecondaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      style: primaryTextStyle,
      borderRadius: BorderRadius.circular(12),
      icon: Icon(Icons.arrow_drop_down, color: kSecondaryColor),
      isExpanded: true,
    );
  }

  Widget _buildRewardInfo() {
    int totalPoints = widget.reward.points * widget.quantity;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.card_giftcard_outlined,
                color: kSecondaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "Detail Reward",
                style: primaryTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   width: 80,
              //   height: 80,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(12),
              //     color: Colors.grey.shade100,
              //     image: widget.reward.imagePath.isNotEmpty
              //         ? DecorationImage(
              //       image: AssetImage(widget.reward.imagePath),
              //       fit: BoxFit.cover,
              //     )
              //         : null,
              //   ),
              //   child: widget.reward.imagePath.isEmpty
              //       ? Icon(
              //     Icons.card_giftcard,
              //     color: Colors.grey.shade400,
              //     size: 40,
              //   )
              //       : null,
              // ),
              Image.asset(
                widget.reward.imagePath.isNotEmpty ? widget.reward.imagePath : "assets/no_img.png",
                height: 80,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // fallback kalau file benar-benar tidak ada
                  return Image.asset(
                    "assets/no_img.png",
                    height: 80,
                    fit: BoxFit.contain,
                  );
                },
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.reward.name,
                      style: primaryTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow("Spesifikasi", widget.specification),
                    _buildDetailRow("Jumlah", "${widget.quantity} item"),
                    const SizedBox(height: 8),
                    // Container(
                    //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    //   decoration: BoxDecoration(
                    //     color: kSecondaryColor.withValues(alpha:0.1),
                    //     borderRadius: BorderRadius.circular(8),
                    //   ),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Icon(
                    //         Icons.workspace_premium_outlined,
                    //         color: kSecondaryColor,
                    //         size: 16,
                    //       ),
                    //       const SizedBox(width: 4),
                    //       Text(
                    //         "$totalPoints Poin",
                    //         style: primaryTextStyle.copyWith(
                    //           fontSize: 14,
                    //           fontWeight: bold,
                    //           color: kSecondaryColor,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$title: ",
              style: secondaryTextStyle.copyWith(
                fontSize: 12,
                fontWeight: medium,
              ),
            ),
            TextSpan(
              text: value,
              style: primaryTextStyle.copyWith(
                fontSize: 12,
                fontWeight: regular,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    int totalPoints = widget.reward.points * widget.quantity;

    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Total Poin",
                  style: secondaryTextStyle.copyWith(fontSize: 12),
                ),
                Text(
                  "$totalPoints Pts",
                  style: primaryTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: bold,
                    color: kSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _confirmOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kSecondaryColor,
                  foregroundColor: kWhiteColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(kWhiteColor),
                  ),
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Konfirmasi",
                        style: whiteTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmOrder() {
    final alamat = {
      "nama": _namaController.text,
      "alamatLengkap": _alamatController.text,
      "provinsi": _provinces.firstWhere(
            (p) => p["id"] == _selectedProvince,
        orElse: () => {"name": ""},
      )["name"],
      "kota": _regencies.firstWhere(
            (r) => r["id"] == _selectedRegency,
        orElse: () => {"name": ""},
      )["name"],
      "kecamatan": _districts.firstWhere(
            (d) => d["id"] == _selectedDistrict,
        orElse: () => {"name": ""},
      )["name"],
      "kelurahan": _villages.firstWhere(
            (v) => v["id"] == _selectedVillage,
        orElse: () => {"name": ""},
      )["name"],
      "rtRw": _rtRwController.text,
      "kodePos": _kodePosController.text,
      "telp": _telpController.text,
    };

    if (alamat.values.any((element) => element.toString().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Harap lengkapi semua data alamat!"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    // Simulasi proses konfirmasi
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      _showSuccessDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: primaryTextStyle.copyWith(fontWeight: bold),
        ),
        centerTitle: true,
        backgroundColor: kWhiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildNoteCard(),
                  const SizedBox(height: 24),
                  _buildAddressForm(),
                  const SizedBox(height: 24),
                  _buildRewardInfo(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }
}