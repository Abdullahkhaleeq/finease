import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/transaction.dart';
import '../../services/financial_coach_service.dart';

class CoachChatScreen extends StatefulWidget {
  final List<FinancialTransaction> transactions;
  final Map<String, double> budgets;
  final double monthlyIncome;

  const CoachChatScreen({
    super.key,
    required this.transactions,
    this.budgets = const {},
    this.monthlyIncome = 0,
  });

  @override
  State<CoachChatScreen> createState() => _CoachChatScreenState();
}

class _CoachChatScreenState extends State<CoachChatScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  final _focus = FocusNode();

  late final FinancialCoachService _svc;
  final List<CoachMessage> _messages = [];
  bool _loading = false;

  static const _primary = Color(0xFF2E3192);
  static const _coachBg = Color(0xFFEEF2FF);
  static const _userBg = Color(0xFF2E3192);

  @override
  void initState() {
    super.initState();
    _svc = FinancialCoachService();
    // Instant tips on open
    _addInstantTips();
    // Welcome message
    _messages.insert(
      0,
      CoachMessage(
        text: '👋 Hi! I\'m your FinEase Financial Coach. '
            'I\'ve analysed your spending and I\'m ready to give you '
            'personalised advice. What would you like to know?',
        role: MessageRole.coach,
        timestamp: DateTime.now(),
      ),
    );
  }

  void _addInstantTips() {
    final tips = _svc.getInstantTips(
      transactions: widget.transactions,
      budgets: widget.budgets,
      monthlyIncome: widget.monthlyIncome,
    );
    for (final tip in tips) {
      _messages.add(CoachMessage(
        text: '${tip.icon} ${tip.message}',
        role: MessageRole.coach,
        timestamp: DateTime.now(),
      ));
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _send(String text) async {
    if (text.trim().isEmpty || _loading) return;
    _ctrl.clear();
    setState(() {
      _messages.add(CoachMessage(
        text: text.trim(),
        role: MessageRole.user,
        timestamp: DateTime.now(),
      ));
      _loading = true;
    });
    _scrollToBottom();

    final reply = await _svc.sendMessage(
      userMessage: text.trim(),
      transactions: widget.transactions,
      budgets: widget.budgets,
    );

    if (mounted) {
      setState(() {
        _loading = false;
        _messages.add(CoachMessage(
          text: reply,
          role: MessageRole.coach,
          timestamp: DateTime.now(),
        ));
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              itemCount: _messages.length + (_loading ? 1 : 0),
              itemBuilder: (ctx, i) {
                if (_loading && i == _messages.length) {
                  return _buildShimmer();
                }
                return _buildBubble(_messages[i]);
              },
            ),
          ),
          // Quick chips
          _buildQuickChips(),
          // Input bar
          _buildInputBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
        backgroundColor: _primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome_rounded,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Financial Coach',
                    style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
                Text('Powered by Gemini AI',
                    style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11)),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                        color: Color(0xFF10B981), shape: BoxShape.circle)),
                const SizedBox(width: 5),
                Text('Online',
                    style: GoogleFonts.inter(
                        color: const Color(0xFF10B981),
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      );

  Widget _buildBubble(CoachMessage msg) {
    final isCoach = msg.role == MessageRole.coach;
    final timeStr = DateFormat('h:mm a').format(msg.timestamp);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment:
            isCoach ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isCoach) ...[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: _primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome_rounded,
                  color: _primary, size: 16),
            ),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isCoach
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isCoach ? _coachBg : _userBg,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isCoach ? 4 : 18),
                      bottomRight: Radius.circular(isCoach ? 18 : 4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    msg.text,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      height: 1.5,
                      color: isCoach
                          ? const Color(0xFF1E293B)
                          : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeStr,
                  style: GoogleFonts.inter(
                      fontSize: 10, color: const Color(0xFF94A3B8)),
                ),
              ],
            ),
          ),
          if (!isCoach) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: _primary.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome_rounded,
                color: _primary, size: 16),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: _coachBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (i) => _ShimmerDot(delay: i * 200),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChips() {
    return Container(
      height: 44,
      margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: FinancialCoachService.quickQuestions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final q = FinancialCoachService.quickQuestions[i];
          return GestureDetector(
            onTap: () => _send(q),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _primary.withValues(alpha: 0.25)),
                boxShadow: [
                  BoxShadow(
                    color: _primary.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                q,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _primary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 8, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FF),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextField(
                controller: _ctrl,
                focusNode: _focus,
                textCapitalization: TextCapitalization.sentences,
                style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF1E293B)),
                decoration: InputDecoration(
                  hintText: 'Ask your financial coach…',
                  hintStyle: GoogleFonts.inter(
                      fontSize: 14, color: const Color(0xFF94A3B8)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 12),
                ),
                onSubmitted: _send,
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _send(_ctrl.text),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4B5BD6), Color(0xFF2E3192)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _primary.withValues(alpha: 0.30),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.send_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shimmer dot animation ─────────────────────────────────────────────────────

class _ShimmerDot extends StatefulWidget {
  final int delay;
  const _ShimmerDot({required this.delay});

  @override
  State<_ShimmerDot> createState() => _ShimmerDotState();
}

class _ShimmerDotState extends State<_ShimmerDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
    _anim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: FadeTransition(
          opacity: _anim,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF2E3192),
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
}
