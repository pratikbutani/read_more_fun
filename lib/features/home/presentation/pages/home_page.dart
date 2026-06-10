import 'package:bubble/bubble.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_more_fun/core/localization/app_localizations.dart';
import 'package:read_more_fun/core/services/draft_service.dart';
import 'package:read_more_fun/core/services/language_service.dart';
import 'package:read_more_fun/core/services/theme_service.dart';
import 'package:read_more_fun/core/services/spacing_service.dart';
import 'package:read_more_fun/features/settings/presentation/pages/settings_page.dart';
import 'package:read_more_fun/core/utils/whatsapp_formatter.dart';
import 'package:read_more_fun/features/history/presentation/history_page.dart';
import 'package:read_more_fun/features/templates/presentation/templates_page.dart';
import 'package:read_more_fun/features/templates/data/static_templates.dart';
import 'package:share_plus/share_plus.dart';

enum PresetMode { freeText, spoiler, joke, quiz }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title});

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ValueNotifier<String> _introTextNotifier =
      ValueNotifier<String>("");
  final ValueNotifier<String> _readMoreTextNotifier =
      ValueNotifier<String>("");
  final ValueNotifier<bool> _isReadMoreClickedNotifier =
      ValueNotifier<bool>(false);

  PresetMode _selectedMode = PresetMode.freeText;

  late TextEditingController _introController;
  late TextEditingController _readMoreController;
  late TextEditingController _spoilerQuestionController;
  late TextEditingController _spoilerAnswerController;
  late TextEditingController _jokeSetupController;
  late TextEditingController _jokePunchlineController;
  late TextEditingController _quizQuestionController;
  late TextEditingController _quizOptionsController;
  late TextEditingController _quizAnswerController;

  late FocusNode _introFocusNode;
  late FocusNode _readMoreFocusNode;
  late FocusNode _spoilerQFocusNode;
  late FocusNode _spoilerAFocusNode;
  late FocusNode _jokeSFocusNode;
  late FocusNode _jokePFocusNode;
  late FocusNode _quizQFocusNode;
  late FocusNode _quizOFocusNode;
  late FocusNode _quizAFocusNode;

  FocusNode? _lastFocusedNode;

  bool _isInitialized = false;
  String _lastLang = 'en';

  @override
  void initState() {
    super.initState();
    _introController = TextEditingController();
    _readMoreController = TextEditingController();

    _spoilerQuestionController = TextEditingController();
    _spoilerAnswerController = TextEditingController();
    _jokeSetupController = TextEditingController();
    _jokePunchlineController = TextEditingController();
    _quizQuestionController = TextEditingController();
    _quizOptionsController = TextEditingController();
    _quizAnswerController = TextEditingController();

    _introFocusNode = FocusNode();
    _readMoreFocusNode = FocusNode();
    _spoilerQFocusNode = FocusNode();
    _spoilerAFocusNode = FocusNode();
    _jokeSFocusNode = FocusNode();
    _jokePFocusNode = FocusNode();
    _quizQFocusNode = FocusNode();
    _quizOFocusNode = FocusNode();
    _quizAFocusNode = FocusNode();

    _setupFocusListeners();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLang = LanguageService.activeLanguageNotifier.value;
    if (!_isInitialized) {
      _introController.text = context.translate('free_text_intro_hint');
      _readMoreController.text = context.translate('free_text_read_more_hint');
      _introTextNotifier.value = context.translate('free_text_intro_hint');
      _readMoreTextNotifier.value = context.translate('free_text_read_more_hint');
      _lastLang = currentLang;
      _isInitialized = true;
    } else if (_lastLang != currentLang) {
      final oldIntroHint = AppLocalizations.getValue(_lastLang, 'free_text_intro_hint');
      final oldReadMoreHint = AppLocalizations.getValue(_lastLang, 'free_text_read_more_hint');

      if (_introController.text == oldIntroHint) {
        _introController.text = context.translate('free_text_intro_hint');
        _introTextNotifier.value = context.translate('free_text_intro_hint');
      }
      if (_readMoreController.text == oldReadMoreHint) {
        _readMoreController.text = context.translate('free_text_read_more_hint');
        _readMoreTextNotifier.value = context.translate('free_text_read_more_hint');
      }
      _syncPresetToNotifier();
      _lastLang = currentLang;
    }
  }

  void _setupFocusListeners() {
    _introFocusNode.addListener(() => _updateLastFocused(_introFocusNode));
    _readMoreFocusNode
        .addListener(() => _updateLastFocused(_readMoreFocusNode));
    _spoilerQFocusNode
        .addListener(() => _updateLastFocused(_spoilerQFocusNode));
    _spoilerAFocusNode
        .addListener(() => _updateLastFocused(_spoilerAFocusNode));
    _jokeSFocusNode.addListener(() => _updateLastFocused(_jokeSFocusNode));
    _jokePFocusNode.addListener(() => _updateLastFocused(_jokePFocusNode));
    _quizQFocusNode.addListener(() => _updateLastFocused(_quizQFocusNode));
    _quizOFocusNode.addListener(() => _updateLastFocused(_quizOFocusNode));
    _quizAFocusNode.addListener(() => _updateLastFocused(_quizAFocusNode));
  }

  void _updateLastFocused(FocusNode node) {
    if (node.hasFocus) {
      _lastFocusedNode = node;
    }
  }

  @override
  void dispose() {
    _introTextNotifier.dispose();
    _readMoreTextNotifier.dispose();
    _isReadMoreClickedNotifier.dispose();

    _introController.dispose();
    _readMoreController.dispose();
    _spoilerQuestionController.dispose();
    _spoilerAnswerController.dispose();
    _jokeSetupController.dispose();
    _jokePunchlineController.dispose();
    _quizQuestionController.dispose();
    _quizOptionsController.dispose();
    _quizAnswerController.dispose();

    _introFocusNode.dispose();
    _readMoreFocusNode.dispose();
    _spoilerQFocusNode.dispose();
    _spoilerAFocusNode.dispose();
    _jokeSFocusNode.dispose();
    _jokePFocusNode.dispose();
    _quizQFocusNode.dispose();
    _quizOFocusNode.dispose();
    _quizAFocusNode.dispose();

    super.dispose();
  }

  void _applyFormat(String marker) {
    TextEditingController? activeController;
    ValueNotifier<String>? activeNotifier;

    if (_lastFocusedNode == _introFocusNode) {
      activeController = _introController;
      activeNotifier = _introTextNotifier;
    } else if (_lastFocusedNode == _readMoreFocusNode) {
      activeController = _readMoreController;
      activeNotifier = _readMoreTextNotifier;
    } else if (_lastFocusedNode == _spoilerQFocusNode) {
      activeController = _spoilerQuestionController;
    } else if (_lastFocusedNode == _spoilerAFocusNode) {
      activeController = _spoilerAnswerController;
    } else if (_lastFocusedNode == _jokeSFocusNode) {
      activeController = _jokeSetupController;
    } else if (_lastFocusedNode == _jokePFocusNode) {
      activeController = _jokePunchlineController;
    } else if (_lastFocusedNode == _quizQFocusNode) {
      activeController = _quizQuestionController;
    } else if (_lastFocusedNode == _quizOFocusNode) {
      activeController = _quizOptionsController;
    } else if (_lastFocusedNode == _quizAFocusNode) {
      activeController = _quizAnswerController;
    }

    if (activeController != null) {
      WhatsAppFormatter.applyFormatting(activeController, marker);
      if (activeNotifier != null) {
        activeNotifier.value = activeController.text;
      } else {
        _syncPresetToNotifier();
      }
    }
  }

  void _syncPresetToNotifier() {
    _isReadMoreClickedNotifier.value = false;
    switch (_selectedMode) {
      case PresetMode.freeText:
        break;
      case PresetMode.spoiler:
        _introTextNotifier.value = _spoilerQuestionController.text.isEmpty
            ? context.translate('spoiler_q_hint')
            : _spoilerQuestionController.text;
        _readMoreTextNotifier.value = _spoilerAnswerController.text.isEmpty
            ? context.translate('spoiler_a_hint')
            : _spoilerAnswerController.text;
        break;
      case PresetMode.joke:
        _introTextNotifier.value = _jokeSetupController.text.isEmpty
            ? context.translate('joke_q_hint')
            : _jokeSetupController.text;
        _readMoreTextNotifier.value = _jokePunchlineController.text.isEmpty
            ? context.translate('joke_a_hint')
            : _jokePunchlineController.text;
        break;
      case PresetMode.quiz:
        String intro = _quizQuestionController.text.isEmpty
            ? context.translate('quiz_q_hint')
            : _quizQuestionController.text;
        if (_quizOptionsController.text.isNotEmpty) {
          intro += "\n\n${_quizOptionsController.text}";
        }
        _introTextNotifier.value = intro;
        _readMoreTextNotifier.value = _quizAnswerController.text.isEmpty
            ? context.translate('quiz_answer_prefix', ['4'])
            : context.translate('quiz_answer_prefix', [_quizAnswerController.text]);
        break;
    }
  }

  String _finalTextForClipBoard() {
    return _introTextNotifier.value +
        WhatsAppFormatter.getLovelyString(times: SpacingService.spacingNotifier.value) +
        _readMoreTextNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.translate("app_title"),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.textColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: context.textColor),
            tooltip: context.translate("settings_title"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              left: 16.0, top: 8.0, right: 16.0, bottom: bottom + 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _getHeaderSubtitleWidget(),
              const SizedBox(height: 16),
              _buildPresetSelector(),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildFormattingToolbar(),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(),
                      ),
                      _buildInputFieldsForSelectedMode(),
                      const SizedBox(height: 24),
                      Text(
                        context.translate("message_preview"),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: context.textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _getProperTextChild(),
                      const SizedBox(height: 24),
                      _getActionButtonsGrid(theme),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.showSnackBar(context.translate('snackbar_sharing'));
          WhatsAppFormatter.shareApp(context, spacingTimes: SpacingService.spacingNotifier.value);
        },
        tooltip: context.translate('share_app'),
        child: const Icon(Icons.share_outlined),
      ),
    );
  }

  Widget _getHeaderSubtitleWidget() {
    return Text(
      context.translate("app_subtitle"),
      style: TextStyle(
        fontSize: 14,
        color: context.textColor.withValues(alpha: 0.6),
      ),
      textAlign: TextAlign.center,
    );
  }



  Widget _buildPresetSelector() {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SegmentedButton<PresetMode>(
          style: SegmentedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
          segments: [
            ButtonSegment(
              value: PresetMode.freeText,
              label: Text(context.translate("preset_custom"),
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w400)),
              icon: const Icon(Icons.edit_outlined, size: 18),
            ),
            ButtonSegment(
              value: PresetMode.spoiler,
              label: Text(context.translate("preset_spoiler"),
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w400)),
              icon: const Icon(Icons.visibility_off_outlined, size: 18),
            ),
            ButtonSegment(
              value: PresetMode.joke,
              label: Text(context.translate("preset_joke"),
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w400)),
              icon: const Icon(Icons.mood_outlined, size: 18),
            ),
            ButtonSegment(
              value: PresetMode.quiz,
              label: Text(context.translate("preset_quiz"),
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w400)),
              icon: const Icon(Icons.quiz_outlined, size: 18),
            ),
          ],
          selected: {_selectedMode},
          onSelectionChanged: (selection) {
            setState(() {
              _selectedMode = selection.first;
              _syncPresetToNotifier();
            });
          },
          showSelectedIcon: false,
        ),
      ),
    );
  }

  Widget _buildFormattingToolbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildToolbarButton(
          label: "B",
          tooltip: context.translate("bold_tooltip"),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          onPressed: () => _applyFormat("*"),
        ),
        const SizedBox(width: 16),
        _buildToolbarButton(
          label: "I",
          tooltip: context.translate("italic_tooltip"),
          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
          onPressed: () => _applyFormat("_"),
        ),
        const SizedBox(width: 16),
        _buildToolbarButton(
          label: "S",
          tooltip: context.translate("strikethrough_tooltip"),
          style: const TextStyle(
              decoration: TextDecoration.lineThrough, fontSize: 16),
          onPressed: () => _applyFormat("~"),
        ),
      ],
    );
  }

  Widget _buildToolbarButton({
    required String label,
    required String tooltip,
    required TextStyle style,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: FilledButton.tonal(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: style.copyWith(color: context.textColor),
        ),
      ),
    );
  }

  Widget _buildInputFieldsForSelectedMode() {
    switch (_selectedMode) {
      case PresetMode.freeText:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _getTextInputLabelWidget(
                context.translate("free_text_intro_label")),
            const SizedBox(height: 6),
            _buildMaterialTextField(
              controller: _introController,
              focusNode: _introFocusNode,
              hintText: context.translate("free_text_intro_hint"),
              maxLines: 1,
              onChanged: (val) {
                _introTextNotifier.value =
                    val.isEmpty ? context.translate("free_text_intro_hint") : val;
              },
            ),
            const SizedBox(height: 16),
            _getTextInputLabelWidget(
                context.translate("free_text_read_more_label")),
            const SizedBox(height: 6),
            _buildMaterialTextField(
              controller: _readMoreController,
              focusNode: _readMoreFocusNode,
              hintText: context.translate("free_text_read_more_hint"),
              maxLines: 4,
              onChanged: (val) {
                _readMoreTextNotifier.value =
                    val.isEmpty ? context.translate("free_text_read_more_hint") : val;
              },
            ),
          ],
        );

      case PresetMode.spoiler:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _getTextInputLabelWidget(context.translate("spoiler_q_label")),
            const SizedBox(height: 6),
            _buildMaterialTextField(
              controller: _spoilerQuestionController,
              focusNode: _spoilerQFocusNode,
              hintText: context.translate("spoiler_q_hint"),
              maxLines: 1,
              onChanged: (_) => _syncPresetToNotifier(),
            ),
            const SizedBox(height: 16),
            _getTextInputLabelWidget(context.translate("spoiler_a_label")),
            const SizedBox(height: 6),
            _buildMaterialTextField(
              controller: _spoilerAnswerController,
              focusNode: _spoilerAFocusNode,
              hintText: context.translate("spoiler_a_hint"),
              maxLines: 3,
              onChanged: (_) => _syncPresetToNotifier(),
            ),
          ],
        );

      case PresetMode.joke:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _getTextInputLabelWidget(context.translate("joke_q_label")),
            const SizedBox(height: 6),
            _buildMaterialTextField(
              controller: _jokeSetupController,
              focusNode: _jokeSFocusNode,
              hintText: context.translate("joke_q_hint"),
              maxLines: 1,
              onChanged: (_) => _syncPresetToNotifier(),
            ),
            const SizedBox(height: 16),
            _getTextInputLabelWidget(context.translate("joke_a_label")),
            const SizedBox(height: 6),
            _buildMaterialTextField(
              controller: _jokePunchlineController,
              focusNode: _jokePFocusNode,
              hintText: context.translate("joke_a_hint"),
              maxLines: 3,
              onChanged: (_) => _syncPresetToNotifier(),
            ),
          ],
        );

      case PresetMode.quiz:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _getTextInputLabelWidget(context.translate("quiz_q_label")),
            const SizedBox(height: 6),
            _buildMaterialTextField(
              controller: _quizQuestionController,
              focusNode: _quizQFocusNode,
              hintText: context.translate("quiz_q_hint"),
              maxLines: 1,
              onChanged: (_) => _syncPresetToNotifier(),
            ),
            const SizedBox(height: 12),
            _getTextInputLabelWidget(context.translate("quiz_o_label")),
            const SizedBox(height: 6),
            _buildMaterialTextField(
              controller: _quizOptionsController,
              focusNode: _quizOFocusNode,
              hintText: context.translate("quiz_o_hint"),
              maxLines: 3,
              onChanged: (_) => _syncPresetToNotifier(),
            ),
            const SizedBox(height: 12),
            _getTextInputLabelWidget(context.translate("quiz_a_label")),
            const SizedBox(height: 6),
            _buildMaterialTextField(
              controller: _quizAnswerController,
              focusNode: _quizAFocusNode,
              hintText: context.translate("quiz_a_hint"),
              maxLines: 2,
              onChanged: (_) => _syncPresetToNotifier(),
            ),
          ],
        );
    }
  }

  Widget _buildMaterialTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hintText,
    required int maxLines,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      enableInteractiveSelection: true,
      textCapitalization: TextCapitalization.sentences,
      style: GoogleFonts.lora(fontSize: 14, color: context.textColor),
      cursorWidth: 1.5,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _getTextInputLabelWidget(dynamic title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: context.textColor.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  Widget _getProperTextChild() {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;

    BubbleStyle styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1E2428)
          : Colors.white,
      elevation: 8 * px,
      radius: const Radius.circular(8),
      margin: const BubbleEdges.only(top: 8.0),
      alignment: Alignment.topLeft,
    );

    TextStyle defaultStyle = GoogleFonts.lora(
        color: context.textColor.withValues(alpha: 0.8), fontSize: 14.0);
    TextStyle linkStyle = GoogleFonts.lora(
        color: Colors.blue,
        decoration: TextDecoration.underline,
        fontSize: 14.0);

    return ListenableBuilder(
        listenable: Listenable.merge([
          _isReadMoreClickedNotifier,
          _introTextNotifier,
          _readMoreTextNotifier,
          SpacingService.spacingNotifier,
        ]),
        builder: (ctx, child) {
          bool isReadMoreClicked = _isReadMoreClickedNotifier.value;
          String introText = _introTextNotifier.value;
          String readMoreText = _readMoreTextNotifier.value;

          return Bubble(
            style: styleMe,
            child: isReadMoreClicked
                ? RichText(
                    text: TextSpan(style: defaultStyle, children: [
                    ...WhatsAppFormatter.parseWhatsAppText(
                        introText, defaultStyle),
                    TextSpan(
                        text: WhatsAppFormatter.getLovelyString(
                            times: SpacingService.spacingNotifier.value),
                        style: defaultStyle),
                    ...WhatsAppFormatter.parseWhatsAppText(
                        '\n\n\n$readMoreText', defaultStyle),
                  ]))
                : RichText(
                    text: TextSpan(style: defaultStyle, children: [
                    ...WhatsAppFormatter.parseWhatsAppText(
                        introText, defaultStyle),
                    TextSpan(
                        text: WhatsAppFormatter.getLovelyString(
                            times: SpacingService.spacingNotifier.value),
                        style: defaultStyle),
                    TextSpan(text: ' ... ', style: defaultStyle),
                    TextSpan(
                        text: context.translate("read_more_link"),
                        style: linkStyle,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _isReadMoreClickedNotifier.value =
                                !_isReadMoreClickedNotifier.value;
                          })
                  ])),
          );
        });
  }

  Widget _getActionButtonsGrid(ThemeData theme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  DraftService.saveDraft(
                      _introTextNotifier.value, _readMoreTextNotifier.value);
                  await Clipboard.setData(
                      ClipboardData(text: _finalTextForClipBoard()));
                  if (!mounted) return;
                  context.showSnackBar(context.translate('snackbar_copied'));
                },
                icon: const Icon(Icons.copy_outlined, size: 18),
                label: Text(context.translate('button_copy')),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: () {
                  DraftService.saveDraft(
                      _introTextNotifier.value, _readMoreTextNotifier.value);
                  context.showSnackBar(context.translate('snackbar_wait'));
                  Share.share(_finalTextForClipBoard());
                },
                icon: const Icon(Icons.share, size: 18),
                label: Text(context.translate('button_whatsapp')),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: () async {
                  final result =
                      await Navigator.of(context).push(_createRoute());
                  if (!mounted) return;
                  if (result is TemplateItem) {
                    setState(() {
                      _selectedMode = PresetMode.freeText;
                      _introController.text = result.intro;
                      _readMoreController.text = result.readMore;
                      _introTextNotifier.value = result.intro;
                      _readMoreTextNotifier.value = result.readMore;
                      _isReadMoreClickedNotifier.value = false;
                    });
                  }
                },
                icon: const Icon(Icons.bookmarks_outlined, size: 18),
                label: Text(context.translate('button_templates')),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: () async {
                  final Draft? selectedDraft = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const HistoryPage()),
                  );
                  if (!mounted) return;
                  if (selectedDraft != null) {
                    setState(() {
                      _selectedMode = PresetMode.freeText;
                      _introController.text = selectedDraft.intro;
                      _readMoreController.text = selectedDraft.readMore;
                      _introTextNotifier.value = selectedDraft.intro;
                      _readMoreTextNotifier.value = selectedDraft.readMore;
                      _isReadMoreClickedNotifier.value = false;
                    });
                  }
                },
                icon: const Icon(Icons.history_outlined, size: 18),
                label: Text(context.translate('button_history')),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const MyTemplatesPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
