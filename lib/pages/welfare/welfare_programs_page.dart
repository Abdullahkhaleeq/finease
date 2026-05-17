import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
=======
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3

import '../../models/welfare_program.dart';
import '../../services/auth_service.dart';
import '../../services/url_launcher_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_config_gate.dart';
import 'welfare_program_detail_page.dart';
import 'welfare_provider.dart';

class WelfareProgramsPage extends StatelessWidget {
  const WelfareProgramsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthService>();
    return ChangeNotifierProvider(
      create: (_) => WelfareProvider(
        uid: auth.user?.uid,
        firestoreService: auth.firestoreService,
      ),
      child: AppFeatureGate(
        enabled: (config) => config.welfareEnabled,
        blockedTitle: 'Welfare programs are paused',
        blockedMessage:
            'The welfare directory is temporarily paused by FinEase admin.',
        blockedIcon: Icons.volunteer_activism_outlined,
        child: const _WelfarePageContent(),
      ),
    );
  }
}

class _WelfarePageContent extends StatefulWidget {
  const _WelfarePageContent();
  @override
  State<_WelfarePageContent> createState() => _WelfarePageContentState();
}

<<<<<<< HEAD
class _WelfarePageContentState extends State<_WelfarePageContent> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
=======
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
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WelfareProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
<<<<<<< HEAD
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
=======
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
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
        ),
        title: Text(
          'Financial Assistance',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
        ),
        actions: [
          _BookmarkBadge(count: provider.bookmarkCount),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: provider.refresh,
        color: AppTheme.primary,
        child: provider.isLoading
            ? const _LoadingSkeleton()
            : provider.error != null
            ? _ErrorState(message: provider.error!, onRetry: provider.refresh)
            : _ProgramList(searchController: _searchController),
      ),
    );
  }
}

<<<<<<< HEAD
// ── Bookmark badge ──────────────────────────────────────────────────────────

class _BookmarkBadge extends StatelessWidget {
  const _BookmarkBadge({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.bookmark_outline_rounded, color: Colors.black87),
        if (count > 0)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ── Main list ───────────────────────────────────────────────────────────────

class _ProgramList extends StatelessWidget {
  const _ProgramList({required this.searchController});
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WelfareProvider>();
    final filtered = provider.filteredPrograms;
    final recommended = provider.recommendedPrograms;
    final hasFilters = provider.hasActiveFilters;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      children: [
        const SizedBox(height: 6),
        _HeroHeader(),
        const SizedBox(height: 20),
        _SearchBar(controller: searchController),
        const SizedBox(height: 14),
        _CategoryChips(),
        const SizedBox(height: 10),
        _TagChips(),
        if (hasFilters)
          _ActiveFilterBanner(provider: provider, controller: searchController),
        const SizedBox(height: 20),

        // Recommended section — only shown when no filter active
        if (!hasFilters && recommended.isNotEmpty) ...[
          _SectionHeader(
            title: 'Recommended for You',
            subtitle: 'Based on your profile and eligibility',
            icon: Icons.auto_awesome_rounded,
          ),
          const SizedBox(height: 12),
          ...recommended.map(
            (p) => _ProgramCard(program: p, isHighlighted: true),
          ),
          const SizedBox(height: 8),
          Divider(color: AppTheme.border),
          const SizedBox(height: 12),
          _SectionHeader(
            title: 'All Programs',
            subtitle: '${filtered.length} programs found',
            icon: Icons.list_alt_rounded,
          ),
          const SizedBox(height: 12),
        ],

        if (filtered.isEmpty)
          _EmptyState(onClear: provider.clearFilters)
        else ...[
          ...filtered.map((p) => _ProgramCard(program: p)),
        ],

        const SizedBox(height: 20),
        _ImpactBanner(count: filtered.length),
      ],
    );
  }
}

// ── Hero header ─────────────────────────────────────────────────────────────

class _HeroHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verified support\nprograms',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppTheme.primary,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Discover real welfare, scholarship, health and loan programs in Pakistan.',
          style: GoogleFonts.inter(color: AppTheme.textSecondary, height: 1.5),
        ),
      ],
    );
  }
}

// ── Search bar ──────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<WelfareProvider>();
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        return TextField(
          controller: controller,
          onChanged: provider.setSearch,
          decoration: InputDecoration(
            hintText: 'Search by title, organization, tags or keywords…',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: value.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      controller.clear();
                      provider.setSearch('');
                    },
                  )
                : null,
          ),
        );
      },
=======
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
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
    );
  }
}

<<<<<<< HEAD
// ── Category chips ──────────────────────────────────────────────────────────

class _CategoryChips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WelfareProvider>();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _Chip(
            label: 'All',
            selected: provider.selectedCategory == null,
            onTap: () => provider.setCategory(null),
          ),
          ...WelfareCategory.values.map(
            (cat) => _Chip(
              label: cat.displayName,
              selected: provider.selectedCategory == cat,
              onTap: () => provider.setCategory(cat),
            ),
          ),
        ],
=======
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
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
      ),
    );
  }
}

<<<<<<< HEAD
// ── Tag chips ───────────────────────────────────────────────────────────────

class _TagChips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WelfareProvider>();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: kWelfareTags
            .map(
              (tag) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: GestureDetector(
                  onTap: () => provider.toggleTag(tag),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: provider.selectedTags.contains(tag)
                          ? AppTheme.primary.withValues(alpha: 0.12)
                          : AppTheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: provider.selectedTags.contains(tag)
                            ? AppTheme.primary
                            : AppTheme.border,
                      ),
                    ),
                    child: Text(
                      '#$tag',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: provider.selectedTags.contains(tag)
                            ? AppTheme.primary
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// ── Active filter banner ─────────────────────────────────────────────────────

class _ActiveFilterBanner extends StatelessWidget {
  const _ActiveFilterBanner({required this.provider, required this.controller});
  final WelfareProvider provider;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          const Icon(
            Icons.filter_list_rounded,
            size: 14,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            '${provider.activeFilterCount} filters active',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              controller.clear();
              provider.clearFilters();
            },
            child: Text(
              'Clear all',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Generic chip ─────────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppTheme.primary : AppTheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppTheme.primary : AppTheme.border,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: selected ? Colors.white : AppTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Section header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
            fontSize: 16,
          ),
        ),
        const Spacer(),
        Text(
          subtitle,
          style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}

// ── Program card ─────────────────────────────────────────────────────────────

class _ProgramCard extends StatelessWidget {
  const _ProgramCard({required this.program, this.isHighlighted = false});
  final WelfareProgram program;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WelfareProvider>();
    final bookmarked = provider.isBookmarked(program.id);
    final appStatus = provider.applicationStatus(program.id);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
              value: provider,
              child: WelfareProgramDetailPage(program: program),
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isHighlighted
                  ? AppTheme.primary.withValues(alpha: 0.3)
                  : AppTheme.border,
              width: isHighlighted ? 1.5 : 1,
            ),
            boxShadow: isHighlighted
                ? AppTheme.cardShadow
                : AppTheme.softShadow,
          ),
          child: Column(
            children: [
              if (isHighlighted)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.07),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(17),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 12,
                        color: AppTheme.primary,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Recommended for you',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: program.category.badgeColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            program.category.icon,
                            color: program.category.badgeTextColor,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: program.category.badgeColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  program.category.displayName,
                                  style: GoogleFonts.inter(
                                    color: program.category.badgeTextColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              if (appStatus != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Text(
                                    _statusLabel(appStatus),
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => provider.toggleBookmark(program.id),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              bookmarked
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_outline_rounded,
                              key: ValueKey(bookmarked),
                              color: bookmarked
                                  ? AppTheme.primary
                                  : AppTheme.textSecondary,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      program.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      program.organization,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      program.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: AppTheme.textSecondary,
                        height: 1.5,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _MetaPill(
                          icon: Icons.payments_outlined,
                          label: program.estimatedSupportValue,
                          color: AppTheme.success,
                        ),
                        const SizedBox(width: 8),
                        _MetaPill(
                          icon: Icons.speed_rounded,
                          label: program.difficulty.label,
                          color: program.difficulty.color,
                        ),
                        if (program.isVerified) ...[
                          const SizedBox(width: 8),
                          _MetaPill(
                            icon: Icons.verified_rounded,
                            label: 'Verified',
                            color: AppTheme.primary,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChangeNotifierProvider.value(
                                  value: provider,
                                  child: WelfareProgramDetailPage(
                                    program: program,
                                  ),
                                ),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppTheme.primary),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'View Details',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async => await UrlLauncherService
                                .instance
                                .launchExternalUrl(
                                  context,
                                  program.officialUrl,
                                ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Apply Now',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
=======
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
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
        ),
      ),
    );
  }

<<<<<<< HEAD
  String _statusLabel(ApplicationStatus s) => switch (s) {
    ApplicationStatus.saved => '🔖 Saved',
    ApplicationStatus.applied => '✉️ Applied',
    ApplicationStatus.inReview => '⏳ In Review',
    ApplicationStatus.approved => '✅ Approved',
    ApplicationStatus.rejected => '❌ Not Approved',
  };
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.icon,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Impact banner ─────────────────────────────────────────────────────────────

class _ImpactBanner extends StatelessWidget {
  const _ImpactBanner({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Impact snapshot',
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.75),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Compare real support pathways before you apply.',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ImpactStat(value: '$count', label: 'PROGRAMS'),
              _ImpactStat(
                value: '${WelfareCategory.values.length}',
                label: 'CATEGORIES',
              ),
              const _ImpactStat(value: '100%', label: 'OFFICIAL'),
            ],
          ),
        ],
      ),
=======
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
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
    );
  }
}

<<<<<<< HEAD
class _ImpactStat extends StatelessWidget {
  const _ImpactStat({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

// ── Loading skeleton ──────────────────────────────────────────────────────────

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: List.generate(4, (_) => const _SkeletonCard()),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
=======
  Widget _buildProgramCard(
      BuildContext context, Map<String, dynamic> program) {
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
<<<<<<< HEAD
        borderRadius: BorderRadius.circular(18),
=======
        borderRadius: BorderRadius.circular(16),
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
<<<<<<< HEAD
=======
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
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
            children: [
              _Bone(width: 42, height: 42, radius: 12),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
<<<<<<< HEAD
                  _Bone(width: 80, height: 12),
                  const SizedBox(height: 6),
                  _Bone(width: 140, height: 18),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          _Bone(width: double.infinity, height: 12),
          const SizedBox(height: 6),
          _Bone(width: 200, height: 12),
          const SizedBox(height: 14),
=======
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
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
          Row(
            children: [
<<<<<<< HEAD
              _Bone(width: 80, height: 26, radius: 8),
              const SizedBox(width: 8),
              _Bone(width: 70, height: 26, radius: 8),
=======
              _buildImpactStat(context, '7+', 'PROGRAMS'),
              _buildImpactStat(context, 'PKR 2M+', 'DISBURSED'),
              _buildImpactStat(context, '85%', 'SUCCESS RATE'),
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
            ],
          ),
        ],
      ),
    );
  }
}

<<<<<<< HEAD
class _Bone extends StatelessWidget {
  const _Bone({required this.width, required this.height, this.radius = 6});
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.border,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onClear});
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 44,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No programs found',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try adjusting your search or filters.',
              style: GoogleFonts.inter(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error state ───────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 52,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
=======
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
>>>>>>> c281882508291f62fb38dea4bf5b14544423a4e3
        ),
      ),
    );
  }
}
