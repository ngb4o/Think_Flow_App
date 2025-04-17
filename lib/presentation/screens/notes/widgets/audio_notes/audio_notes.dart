part of 'audio_notes_imports.dart';

@RoutePage()
class AudioNotesPage extends StatefulWidget {
  const AudioNotesPage({super.key});

  @override
  State<AudioNotesPage> createState() => _AudioNotesPageState();
}

class _AudioNotesPageState extends State<AudioNotesPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "Nhấn nút mic để bắt đầu nói";
  double _confidence = 1;
  late QuillController _quillController;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _quillController = QuillController.basic();
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  void _initSpeech() async {
    _speech = stt.SpeechToText();
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (!available) {
      setState(() {
        _text = "Không thể sử dụng tính năng nhận diện giọng nói";
      });
    }
  }

  void listen() async {
    if (!_isListening) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(
        localeId: 'vi-VN',
        onResult: (val) => setState(() {
          _text = val.recognizedWords;
          if (val.hasConfidenceRating && val.confidence > 0) {
            _confidence = val.confidence;
          }
          // Update QuillEditor content
          _quillController.document = Document.fromJson([
            {'insert': _text + '\n'}
          ]);
        }),
      );
    } else {
      setState(() {
        _isListening = false;
      });
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          QuillSimpleToolbar(
            controller: _quillController,
            config: QuillSimpleToolbarConfig(
              showAlignmentButtons: true,
              showFontFamily: false,
              showFontSize: false,
              showInlineCode: false,
              showColorButton: false,
              showBackgroundColorButton: false,
              showClearFormat: false,
              showListCheck: false,
              showCodeBlock: false,
              showIndent: false,
              showSearchButton: false,
              showSubscript: false,
              showSuperscript: false,
            ),
          ),
          Container(
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: QuillEditor.basic(
              controller: _quillController,
              config: QuillEditorConfig(
                padding: EdgeInsets.all(TSizes.spaceBtwItems),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: TColors.primary,
        duration: Duration(milliseconds: 2000),
        repeat: true,
        child: FloatingActionButton(
          shape: CircleBorder(),
          onPressed: listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
    );
  }
}
