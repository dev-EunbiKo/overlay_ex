import 'package:flutter/material.dart';
import 'package:overlay_ex/pages/widgets/custom_dropdown.dart';

class UserInputPage extends StatefulWidget {
  const UserInputPage({super.key});

  @override
  State<UserInputPage> createState() => _UserInputPageState();
}

class _UserInputPageState extends State<UserInputPage> {
  String? selectedValue;
  final List<String> items = [
    'Flutter',
    'Swift',
    'Kotlin',
    'Objective-C',
    'Vue.js',
  ];

  OverlayEntry? _textFieldOverlayEntry;

  OverlayEntry? _overlayEntry;
  String _searchText = '';

  @override
  void dispose() {
    super.dispose();
    _hideTextField();
    _hideOverlay();
  }

  /// markNeedsBuild를 이용하여 오버레이만 업데이트
  void _updateSearch(String value) {
    _searchText = value;
    _overlayEntry?.markNeedsBuild();
  }

  OverlayEntry _createSearchOverlay() {
    return OverlayEntry(
      builder:
          (context) => Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: _updateSearch,
                    decoration: InputDecoration(
                      hintText: 'Input Search Text',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  if (_searchText.isNotEmpty)
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          final item = _getFilteredResults()[index];
                          return ListTile(
                            title: Text(item),
                            onTap: () => _hideOverlay(),
                          );
                        },
                        itemCount: _getFilteredResults().length,
                      ),
                    ),
                ],
              ),
            ),
          ),
    );
  }

  List<String> _getFilteredResults() {
    final allItems = ['Flutter', 'Dart', 'Widget', 'OverlayEntry'];
    return allItems
        .where((item) => item.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
  }

  void _showOverlay() {
    _overlayEntry = _createSearchOverlay();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // FocusScope를 이용한 TextField 오버레이
  void _showTextField() {
    if (_textFieldOverlayEntry == null) {
      _textFieldOverlayEntry = _createFocusableOverlay();
      Overlay.of(context).insert(_textFieldOverlayEntry!);
    }
  }

  // FocusScope를 이용한 TextField 오버레이 제거
  void _hideTextField() {
    _textFieldOverlayEntry?.remove();
    _textFieldOverlayEntry = null;
  }

  // FocusScope를 이용한 TextField 오버레이 생성
  OverlayEntry _createFocusableOverlay() {
    return OverlayEntry(
      builder:
          (context) => Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            left: MediaQuery.of(context).size.width * 0.1,
            width: MediaQuery.of(context).size.width * 0.8,
            // autofocus 기능 사용을 위해서는 FocusScope 사용 필요
            child: FocusScope(
              node: FocusScopeNode(),
              child: Material(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700.withAlpha(150),
                  ),
                  width: 300,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Input Text.',
                          prefixIcon: Icon(Icons.search),
                        ),

                        onChanged: (value) {
                          _textFieldOverlayEntry?.markNeedsBuild();
                        },
                        onSubmitted: (value) {
                          _hideTextField();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Development Framework',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            CustomDropdown(
              items: items,
              value: selectedValue,
              hint: 'Select Framework',
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
              },
            ),
            SizedBox(height: 20),
            if (selectedValue != null)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(50),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Selected >>> $selectedValue',
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            SizedBox(height: 20),
            ElevatedButton(onPressed: _showTextField, child: Text('TextField')),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showOverlay,
              child: Text('OnlyOverlayBuild'),
            ),
          ],
        ),
      ),
    );
  }
}
