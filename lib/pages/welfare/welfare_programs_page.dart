import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

class WelfareProgramsPage extends StatefulWidget {
  const WelfareProgramsPage({super.key});

  @override
  State<WelfareProgramsPage> createState() => _WelfareProgramsPageState();
}

class _WelfareProgramsPageState extends State<WelfareProgramsPage> {
  String _searchQuery = '';
  String _selectedCategory = 'All Programs';

  final List<Map<String, dynamic>> _allPrograms = [
    {
      'category': 'Financial Aid',
      'icon': Icons.volunteer_activism_outlined,
      'iconBgColor': const Color(0xFFEFF4FF),
      'iconColor': AppTheme.primary,
      'badgeLabel': 'Govt. Program',
      'badgeColor': const Color(0xFFDCE9FF),
      'badgeTextColor': AppTheme.primary,
      'title': 'BISP – Benazir Income Support Programme',
      'description':
          'Pakistan\'s largest social safety net providing cash transfers to low-income families. Eligible households receive PKR 8,500 per quarter.',
      'orgName': 'Government of Pakistan',
      'statusLabel': 'Amount',
      'statusValue': 'PKR 8,500/qtr',
      'statusValueColor': AppTheme.primary,
      'url': 'https://www.bisp.gov.pk',
    },
    {
      'category': 'Education',
      'icon': Icons.school_outlined,
      'iconBgColor': const Color(0xFFEFF4FF),
      'iconColor': AppTheme.primary,
      'badgeLabel': 'Education',
      'badgeColor': const Color(0xFFE8F5E9),
      'badgeTextColor': const Color(0xFF2E7D32),
      'title': 'Ehsaas Undergraduate Scholarship',
      'description':
          'Merit-cum-need scholarships for deserving students at HEC-recognized public universities across Pakistan. Covers tuition & stipend.',
      'orgName': 'BISP / HEC Pakistan',
      'statusLabel': 'Coverage',
      'statusValue': 'Full Tuition + Stipend',
      'statusValueColor': const Color(0xFF2E7D32),
      'url': 'https://www.bisp.gov.pk/ehsaas-educational-stipends',
    },
    {
      'category': 'Health',
      'icon': Icons.health_and_safety_outlined,
      'iconBgColor': const Color(0xFFEFF4FF),
      'iconColor': AppTheme.primary,
      'badgeLabel': 'Health',
      'badgeColor': const Color(0xFFFFDBCB),
      'badgeTextColor': const Color(0xFF773207),
      'title': 'Al-Khidmat Health Services',
      'description':
          'Free medical camps, subsidized treatment, and medicines for low-income families through a nationwide network of hospitals & dispensaries.',
      'orgName': 'Al-Khidmat Foundation Pakistan',
      'statusLabel': 'Status',
      'statusValue': 'Open Now',
      'statusValueColor': const Color(0xFF2E7D32),
      'url': 'https://alkhidmat.org',
    },
    {
      'category': 'Financial Aid',
      'icon': Icons.business_center_outlined,
      'iconBgColor': const Color(0xFFEFF4FF),
      'iconColor': AppTheme.primary,
      'badgeLabel': 'Microfinance',
      'badgeColor': const Color(0xFFFFDBCB),
      'badgeTextColor': const Color(0xFF773207),
      'title': 'Akhuwat Interest-Free Loans',
      'description':
          'Pakistan\'s largest Islamic microfinance institution offering interest-free (Qarz-e-Hasna) loans to deserving families for businesses, education & housing.',
      'orgName': 'Akhuwat Foundation',
      'statusLabel': 'Interest',
      'statusValue': 'Zero % (Interest Free)',
      'statusValueColor': AppTheme.primary,
      'url': 'https://www.akhuwat.org.pk',
    },
    {
      'category': 'Education',
      'icon': Icons.laptop_chromebook_outlined,
      'iconBgColor': const Color(0xFFEFF4FF),
      'iconColor': AppTheme.primary,
      'badgeLabel': 'Education',
      'badgeColor': const Color(0xFF29FCF3),
      'badgeTextColor': const Color(0xFF00504D),
      'title': 'Edhi Foundation – Educational Aid',
      'description':
          'The Edhi Foundation supports orphans and underprivileged children with free education, housing, and rehabilitation services nationwide.',
      'orgName': 'Edhi Foundation Pakistan',
      'statusLabel': 'Type',
      'statusValue': 'Free Education',
      'statusValueColor': AppTheme.textPrimary,
      'url': 'https://edhi.org',
    },
    {
      'category': 'Housing',
      'icon': Icons.home_work_outlined,
      'iconBgColor': const Color(0xFFEFF4FF),
      'iconColor': AppTheme.primary,
      'badgeLabel': 'Housing',
      'badgeColor': const Color(0xFFFFDBCB),
      'badgeTextColor': const Color(0xFF773207),
      'title': 'Naya Pakistan Housing Programme',
      'description':
          'Government low-cost housing scheme for low and middle-income families. Subsidized home loans and affordable housing units across Pakistan.',
      'orgName': 'NPHP – Government of Pakistan',
      'statusLabel': 'Subsidy',
      'statusValue': 'Up to PKR 1M',
      'statusValueColor': AppTheme.textPrimary,
      'url': 'https://www.nphp.gov.pk',
    },
    {
      'category': 'Financial Aid',
      'icon': Icons.savings_outlined,
      'iconBgColor': const Color(0xFFEFF4FF),
      'iconColor': AppTheme.primary,
      'badgeLabel': 'Relief',
      'badgeColor': const Color(0xFFE8F5E9),
      'badgeTextColor': const Color(0xFF2E7D32),
      'title': 'Pakistan Bait-ul-Mal (PBM)',
      'description':
          'Federal welfare organization providing financial assistance to needy individuals, orphans, disabled persons, and widows through various programs.',
      'orgName': 'Pakistan Bait-ul-Mal',
      'statusLabel': 'Status',
      'statusValue': 'Open Applications',
      'statusValueColor': const Color(0xFF2E7D32),
      'url': 'https://pbm.gov.pk',
    },
  ];

  List<Map<String, dynamic>> get _filteredPrograms {
    return _allPrograms.where((program) {
      final matchesQuery =
          program['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
              program['orgName'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'All Programs' || program['category'] == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppTheme.primary, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Welfare Programs',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Support Programs',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Verified Pakistani welfare programs — BISP, Al-Khidmat, Akhuwat, and more. Tap a program to visit their official website.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            _buildSearchBar(context),
            const SizedBox(height: 14),
            _buildCategoryChips(context),
            const SizedBox(height: 20),
            _buildProgramList(context),
            const SizedBox(height: 28),
            _buildImpactBanner(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      onChanged: (value) => setState(() => _searchQuery = value),
      decoration: InputDecoration(
        hintText: 'Search programs or organizations...',
        prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
        fillColor: AppTheme.surface,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppTheme.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildCategoryChips(BuildContext context) {
    final categories = [
      'All Programs',
      'Financial Aid',
      'Education',
      'Health',
      'Housing',
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories
            .map((cat) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildChip(context, cat,
                      isSelected: _selectedCategory == cat),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label,
      {required bool isSelected}) {
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? AppTheme.primary : AppTheme.border),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color:
                    isSelected ? Colors.white : AppTheme.textSecondary,
              ),
        ),
      ),
    );
  }

  Widget _buildProgramList(BuildContext context) {
    final filtered = _filteredPrograms;
    if (filtered.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text('No programs match your search.',
              style: Theme.of(context).textTheme.bodyLarge),
        ),
      );
    }

    return Column(
      children: filtered
          .map((program) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildProgramCard(context, program),
              ))
          .toList(),
    );
  }

  Widget _buildProgramCard(
      BuildContext context, Map<String, dynamic> program) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: program['iconBgColor'] as Color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(program['icon'] as IconData,
                    color: program['iconColor'] as Color, size: 22),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: program['badgeColor'] as Color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  program['badgeLabel'] as String,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: program['badgeTextColor'] as Color,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(program['title'] as String,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  )),
          const SizedBox(height: 6),
          Text(program['description'] as String,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.business, size: 13, color: AppTheme.textSecondary),
              const SizedBox(width: 4),
              Text(program['orgName'] as String,
                  style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: AppTheme.border),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(program['statusLabel'] as String,
                      style: Theme.of(context).textTheme.labelSmall),
                  const SizedBox(height: 2),
                  Text(
                    program['statusValue'] as String,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: program['statusValueColor'] as Color,
                        ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _openUrl(context, program),
                icon: const Icon(Icons.open_in_new_rounded, size: 14),
                label: const Text('Visit Website'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  minimumSize: const Size(0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openUrl(BuildContext context, Map<String, dynamic> program) {
    final url = program['url'] as String;
    final title = program['title'] as String;
    // Copy URL to clipboard and show guidance
    Clipboard.setData(ClipboardData(text: url));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.open_in_new_rounded,
                color: AppTheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Visit Website',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 14)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF4FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link_rounded,
                      size: 16, color: AppTheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(url,
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Link copied to clipboard. Open your browser and paste to visit the official website.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: const Text('Got it',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E3192), Color(0xFF1565C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Making a\nmeasurable\nimpact together',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 14),
          Text(
            'FinEase connects you with Pakistan\'s verified welfare programs — BISP, Akhuwat, Al-Khidmat, Edhi, and many more — so financial support is just a tap away.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildImpactStat(context, '7+', 'PROGRAMS'),
              _buildImpactStat(context, 'PKR 2M+', 'DISBURSED'),
              _buildImpactStat(context, '85%', 'SUCCESS RATE'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImpactStat(
      BuildContext context, String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white.withOpacity(0.7),
                fontSize: 10,
                letterSpacing: 0.5,
              ),
        ),
      ],
    );
  }
}
