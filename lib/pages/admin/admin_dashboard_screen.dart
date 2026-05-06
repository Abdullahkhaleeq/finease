import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../app_constants.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _db = FirebaseFirestore.instance;
  int _tab = 0;
  String _search = '';
  final _searchCtrl = TextEditingController();

  static const _tabs = [
    ('Overview', Icons.dashboard_rounded),
    ('Users', Icons.manage_accounts_rounded),
    ('Forum', Icons.forum_rounded),
    ('Partners', Icons.handshake_rounded),
    ('Welfare', Icons.volunteer_activism_rounded),
    ('Reports', Icons.analytics_rounded),
  ];

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    
    // Safety check: if not admin, show access denied
    if (!authService.isAdmin) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_rounded, size: 64, color: AppTheme.error),
              const SizedBox(height: 16),
              Text('Access Denied', style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text('You do not have permission to view this page.', style: GoogleFonts.inter(color: AppTheme.textSecondary)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        automaticallyImplyLeading: false,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Admin Dashboard', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w800)),
          Text(AppConstants.adminEmail, style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
        ]),
        actions: [
          IconButton(icon: const Icon(Icons.auto_fix_high_rounded, color: Colors.white), tooltip: 'Seed samples', onPressed: _seed),
          IconButton(icon: const Icon(Icons.logout_rounded, color: Colors.white), onPressed: () => authService.signOut()),
        ],
      ),
      body: Column(children: [
        Container(
          color: AppTheme.primary, height: 54,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            scrollDirection: Axis.horizontal,
            itemCount: _tabs.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final sel = i == _tab;
              return GestureDetector(
                onTap: () => setState(() => _tab = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: sel ? Colors.white : Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.white.withOpacity(sel ? 1 : 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _tabs[i].$2,
                        size: 16,
                        color: sel ? AppTheme.primary : Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _tabs[i].$1,
                        style: GoogleFonts.inter(
                          color: sel ? AppTheme.primary : Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(child: _body()),
      ]),
      floatingActionButton: _fab(),
    );
  }

  Widget _body() {
    switch (_tab) {
      case 1: return _usersTab();
      case 2: return _forumTab();
      case 3: return _partnersTab();
      case 4: return _welfareTab();
      case 5: return _reportsTab();
      default: return _overviewTab();
    }
  }

  Widget? _fab() {
    if (_tab == 3) return FloatingActionButton.extended(backgroundColor: _primary, icon: const Icon(Icons.add_business_rounded, color: Colors.white), label: const Text('Add Partner', style: TextStyle(color: Colors.white)), onPressed: () => _partnerDialog());
    if (_tab == 4) return FloatingActionButton.extended(backgroundColor: _primary, icon: const Icon(Icons.add_task_rounded, color: Colors.white), label: const Text('Add Case', style: TextStyle(color: Colors.white)), onPressed: _welfareDialog);
    return null;
  }

  // ── OVERVIEW ─────────────────────────────────────────────────────────────────
  Widget _overviewTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _db.collection('users').snapshots(),
      builder: (ctx, uSnap) => StreamBuilder<QuerySnapshot>(
        stream: _db.collection('forum_posts').snapshots(),
        builder: (ctx, pSnap) => StreamBuilder<QuerySnapshot>(
          stream: _db.collection('welfare_applications').snapshots(),
          builder: (ctx, wSnap) {
            final users = uSnap.data?.docs ?? [];
            final posts = pSnap.data?.docs ?? [];
            final welfare = wSnap.data?.docs ?? [];
            return ListView(padding: const EdgeInsets.all(16), children: [
              _grid([
                _tile('Total Users', '${users.length}', Icons.people_rounded, _primary),
                _tile('Forum Posts', '${posts.length}', Icons.forum_rounded, Colors.orange),
                _tile('Welfare Cases', '${welfare.length}', Icons.assignment_rounded, Colors.green),
                _tile('Flagged Posts', '${posts.where((d) => (d.data() as Map)['moderationStatus'] == 'flagged').length}', Icons.flag_rounded, Colors.red),
              ]),
              const SizedBox(height: 20),
              _sectionTitle('Quick Actions'),
              const SizedBox(height: 10),
              Wrap(spacing: 10, runSpacing: 10, children: [
                _actionBtn('Users', Icons.manage_accounts_rounded, () => setState(() => _tab = 1)),
                _actionBtn('Moderate', Icons.shield_rounded, () => setState(() => _tab = 2)),
                _actionBtn('Welfare', Icons.volunteer_activism_rounded, () => setState(() => _tab = 4)),
                _actionBtn('Reports', Icons.file_copy_rounded, () => setState(() => _tab = 5)),
              ]),
            ]);
          },
        ),
      ),
    );
  }

  // ── USERS ────────────────────────────────────────────────────────────────────
  Widget _usersTab() {
    return Column(children: [
      _searchBox('Search users...'),
      Expanded(child: StreamBuilder<QuerySnapshot>(
        stream: _db.collection('users').orderBy('email').snapshots(),
        builder: (_, snap) {
          final docs = _filter(snap.data?.docs ?? []);
          if (docs.isEmpty) return _empty(Icons.people_outline_rounded, 'No users found');
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final d = docs[i].data() as Map<String, dynamic>;
              final status = d['accountStatus'] ?? 'active';
              return _card(
                icon: d['role'] == 'admin' ? Icons.admin_panel_settings_rounded : Icons.person_rounded,
                title: d['fullName'] ?? d['email'] ?? 'User',
                subtitle: '${d['email'] ?? ''} · ${d['role'] ?? 'user'}',
                badge: status,
                badgeColor: status == 'suspended' ? Colors.red : Colors.green,
                actions: [
                  _btn(status == 'suspended' ? 'Activate' : 'Suspend', status == 'suspended' ? Icons.check_circle_rounded : Icons.block_rounded,
                      () => _setUserStatus(docs[i].id, status == 'suspended' ? 'active' : 'suspended')),
                  _btn('Details', Icons.badge_rounded, () => _userDetails(docs[i])),
                ],
              );
            },
          );
        },
      )),
    ]);
  }

  // ── FORUM ────────────────────────────────────────────────────────────────────
  Widget _forumTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _db.collection('forum_posts').orderBy('createdAt', descending: true).snapshots(),
      builder: (_, snap) {
        final posts = snap.data?.docs ?? [];
        if (posts.isEmpty) return _empty(Icons.forum_outlined, 'No posts yet');
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          itemCount: posts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final d = posts[i].data() as Map<String, dynamic>;
            final status = d['moderationStatus'] ?? 'visible';
            return _card(
              icon: Icons.forum_rounded,
              title: d['title'] ?? 'Post',
              subtitle: '${d['category'] ?? 'General'} by ${d['authorName'] ?? 'User'}',
              badge: status,
              badgeColor: status == 'flagged' ? Colors.orange : status == 'removed' ? Colors.red : Colors.green,
              actions: [
                _btn('Flag', Icons.flag_rounded, () => _setPostStatus(posts[i].id, 'flagged')),
                _btn('Restore', Icons.visibility_rounded, () => _setPostStatus(posts[i].id, 'visible')),
                _btn('Remove', Icons.delete_outline_rounded, () => _setPostStatus(posts[i].id, 'removed')),
              ],
            );
          },
        );
      },
    );
  }

  // ── PARTNERS ─────────────────────────────────────────────────────────────────
  Widget _partnersTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _db.collection('marketplace_partners').snapshots(),
      builder: (_, snap) {
        final docs = snap.data?.docs ?? [];
        if (docs.isEmpty) return _empty(Icons.storefront_outlined, 'No partners yet');
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final d = docs[i].data() as Map<String, dynamic>;
            final active = (d['status'] ?? 'active') == 'active';
            return _card(
              icon: Icons.handshake_rounded,
              title: d['name'] ?? 'Partner',
              subtitle: d['category'] ?? 'General',
              badge: active ? 'active' : 'inactive',
              badgeColor: active ? Colors.green : Colors.grey,
              actions: [
                _btn('Edit', Icons.edit_rounded, () => _partnerDialog(doc: docs[i])),
                _btn(active ? 'Disable' : 'Enable', active ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    () => docs[i].reference.set({'status': active ? 'inactive' : 'active'}, SetOptions(merge: true))),
              ],
            );
          },
        );
      },
    );
  }

  // ── WELFARE ──────────────────────────────────────────────────────────────────
  Widget _welfareTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _db.collection('welfare_applications').orderBy('createdAt', descending: true).snapshots(),
      builder: (_, snap) {
        final docs = snap.data?.docs ?? [];
        if (docs.isEmpty) return _empty(Icons.assignment_outlined, 'No welfare cases');
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final d = docs[i].data() as Map<String, dynamic>;
            final status = d['status'] ?? 'pending';
            return _card(
              icon: Icons.volunteer_activism_rounded,
              title: d['applicantName'] ?? 'Applicant',
              subtitle: d['program'] ?? 'Support request',
              badge: status,
              badgeColor: status == 'approved' ? Colors.green : status == 'rejected' ? Colors.red : Colors.orange,
              actions: [
                _btn('Approve', Icons.check_circle_rounded, () => _setWelfareStatus(docs[i].id, 'approved')),
                _btn('Reject', Icons.cancel_rounded, () => _setWelfareStatus(docs[i].id, 'rejected')),
                _btn('Resolve', Icons.task_alt_rounded, () => _setWelfareStatus(docs[i].id, 'resolved')),
              ],
            );
          },
        );
      },
    );
  }

  // ── REPORTS ──────────────────────────────────────────────────────────────────
  Widget _reportsTab() {
    return ListView(padding: const EdgeInsets.all(16), children: [
      _card(icon: Icons.file_copy_rounded, title: 'Operational Report', subtitle: 'CSV-style summary of users, posts, partners and welfare cases.', badge: 'ready', badgeColor: Colors.green,
        actions: [_btn('Copy Report', Icons.copy_rounded, _copyReport)]),
      const SizedBox(height: 12),
      _card(icon: Icons.security_rounded, title: 'Security Controls', subtitle: 'Suspended users are blocked on login. Removed posts are hidden from users. Disabled partners are hidden from marketplace.', badge: 'active', badgeColor: Colors.blue),
    ]);
  }

  // ── HELPERS ──────────────────────────────────────────────────────────────────
  Widget _grid(List<Widget> tiles) => GridView.count(
    shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.4,
    children: tiles,
  );

  Widget _tile(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 28),
        const Spacer(),
        Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w800, color: color)),
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600])),
      ]),
    );
  }

  Widget _card({required IconData icon, required String title, required String subtitle, required String badge, required Color badgeColor, List<Widget> actions = const []}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: _primary.withOpacity(0.08), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: _primary, size: 20)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 14)),
            Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600])),
          ])),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: badgeColor.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
            child: Text(badge, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: badgeColor))),
        ]),
        if (actions.isNotEmpty) ...[const SizedBox(height: 8), Wrap(spacing: 4, children: actions)],
      ]),
    );
  }

  Widget _btn(String label, IconData icon, VoidCallback onTap) => TextButton.icon(
    onPressed: onTap, icon: Icon(icon, size: 15), label: Text(label, style: GoogleFonts.inter(fontSize: 12)),
    style: TextButton.styleFrom(foregroundColor: _primary, visualDensity: VisualDensity.compact, padding: const EdgeInsets.symmetric(horizontal: 6)),
  );

  Widget _actionBtn(String label, IconData icon, VoidCallback onTap) => OutlinedButton.icon(
    onPressed: onTap, icon: Icon(icon, size: 18), label: Text(label),
    style: OutlinedButton.styleFrom(foregroundColor: _primary, side: const BorderSide(color: Color(0xFFDDDDDD)), backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
  );

  Widget _searchBox(String hint) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
    child: TextField(
      controller: _searchCtrl,
      onChanged: (v) => setState(() => _search = v.toLowerCase()),
      decoration: InputDecoration(hintText: hint, prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: _search.isEmpty ? null : IconButton(icon: const Icon(Icons.close_rounded), onPressed: () { _searchCtrl.clear(); setState(() => _search = ''); }),
        filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
      ),
    ),
  );

  Widget _sectionTitle(String t) => Text(t, style: GoogleFonts.plusJakartaSans(fontSize: 17, fontWeight: FontWeight.w800));

  Widget _empty(IconData icon, String msg) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 52, color: Colors.grey[300]),
    const SizedBox(height: 10),
    Text(msg, style: GoogleFonts.inter(color: Colors.grey[500])),
  ]));

  List<QueryDocumentSnapshot> _filter(List<QueryDocumentSnapshot> docs) {
    if (_search.isEmpty) return docs;
    return docs.where((d) => (d.data() as Map).values.join(' ').toLowerCase().contains(_search)).toList();
  }

  // ── FIRESTORE ACTIONS ────────────────────────────────────────────────────────
  Future<void> _setUserStatus(String id, String status) async {
    await _db.collection('users').doc(id).set({'accountStatus': status, 'statusUpdatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
    _snack('User marked $status.');
  }

  Future<void> _setPostStatus(String id, String status) async {
    await _db.collection('forum_posts').doc(id).set({'moderationStatus': status, 'moderatedAt': FieldValue.serverTimestamp(), 'moderatedBy': _adminEmail}, SetOptions(merge: true));
    _snack('Post marked $status.');
  }

  Future<void> _setWelfareStatus(String id, String status) async {
    await _db.collection('welfare_applications').doc(id).set({'status': status, 'reviewedAt': FieldValue.serverTimestamp(), 'reviewedBy': _adminEmail}, SetOptions(merge: true));
    _snack('Case marked $status.');
  }

  Future<void> _seed() async {
    final b = _db.batch();
    b.set(_db.collection('welfare_applications').doc('seed-1'), {'applicantName': 'Ayesha Khan', 'program': 'BISP', 'status': 'pending', 'notes': 'Income verification needed.', 'createdAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
    b.set(_db.collection('forum_posts').doc('seed-flag'), {'title': 'Suspicious investment link', 'content': 'Needs moderation.', 'category': 'Investing', 'authorName': 'FinEase Monitor', 'authorId': 'system', 'likes': 0, 'comments': 0, 'moderationStatus': 'flagged', 'createdAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
    await b.commit();
    _snack('Sample data seeded.');
  }

  Future<void> _copyReport() async {
    final u = await _db.collection('users').get();
    final p = await _db.collection('forum_posts').get();
    final w = await _db.collection('welfare_applications').get();
    final buf = StringBuffer()
      ..writeln('FinEase Admin Report')
      ..writeln('Generated,${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}')
      ..writeln('Users,${u.size}')
      ..writeln('Posts,${p.size}')
      ..writeln('Welfare Cases,${w.size}');
    await Clipboard.setData(ClipboardData(text: buf.toString()));
    _snack('Report copied to clipboard.');
  }

  void _userDetails(QueryDocumentSnapshot doc) {
    showModalBottomSheet(context: context, showDragHandle: true, builder: (_) => ListView(
      padding: const EdgeInsets.all(20),
      children: (doc.data() as Map<String, dynamic>).entries.map((e) => ListTile(title: Text(e.key, style: GoogleFonts.inter(fontWeight: FontWeight.w600)), subtitle: Text('${e.value}', style: GoogleFonts.inter()))).toList(),
    ));
  }

  void _partnerDialog({QueryDocumentSnapshot? doc}) {
    final d = (doc?.data() ?? {}) as Map<String, dynamic>;
    final name = TextEditingController(text: d['name'] ?? '');
    final cat = TextEditingController(text: d['category'] ?? 'Finance');
    final desc = TextEditingController(text: d['description'] ?? '');
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: Text(doc == null ? 'Add Partner' : 'Edit Partner'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
        const SizedBox(height: 8),
        TextField(controller: cat, decoration: const InputDecoration(labelText: 'Category')),
        const SizedBox(height: 8),
        TextField(controller: desc, maxLines: 3, decoration: const InputDecoration(labelText: 'Description')),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        ElevatedButton(child: const Text('Save'), onPressed: () async {
          final payload = {'name': name.text.trim(), 'category': cat.text.trim(), 'description': desc.text.trim(), 'status': 'active', 'approved': true, 'updatedAt': FieldValue.serverTimestamp()};
          if (doc == null) await _db.collection('marketplace_partners').add(payload);
          else await doc.reference.set(payload, SetOptions(merge: true));
          if (ctx.mounted) Navigator.pop(ctx);
          _snack('Partner saved.');
        }),
      ],
    ));
  }

  void _welfareDialog() {
    final applicant = TextEditingController();
    final program = TextEditingController(text: 'Financial Support');
    final notes = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Add Welfare Case'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: applicant, decoration: const InputDecoration(labelText: 'Applicant Name')),
        const SizedBox(height: 8),
        TextField(controller: program, decoration: const InputDecoration(labelText: 'Program')),
        const SizedBox(height: 8),
        TextField(controller: notes, maxLines: 3, decoration: const InputDecoration(labelText: 'Notes')),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        ElevatedButton(child: const Text('Save'), onPressed: () async {
          await _db.collection('welfare_applications').add({'applicantName': applicant.text.trim().isEmpty ? 'Applicant' : applicant.text.trim(), 'program': program.text.trim(), 'notes': notes.text.trim(), 'status': 'pending', 'createdAt': FieldValue.serverTimestamp()});
          if (ctx.mounted) Navigator.pop(ctx);
          _snack('Case added.');
        }),
      ],
    ));
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
  }
}
