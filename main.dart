import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: AbstractFactoryExample(),
        ),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Hello, World!', style: Theme.of(context).textTheme.headline4);
  }
}

abstract class IWidgetsFactory {
  String getTitle();
  IActivityIndicator createActivityIndicator();
  ISlider createSlider();
  ISwitch createSwitch();
}

class MaterialWidgetsFactory implements IWidgetsFactory {
  @override
  String getTitle() {
    return 'Android widgets';
  }
  
  @override
  IActivityIndicator createActivityIndicator() {
    return AndroidActivityIndicator();
  }
  
  @override
  ISlider createSlider() {
    return AndroidSlider();
  }
  
  @override
  ISwitch createSwitch() {
    return AndroidSwitch();
  }
}

class CupertinoWidgetsFactory implements IWidgetsFactory {
  @override
  String getTitle() {
    return 'iOS widgets';
  }
  
  @override
  IActivityIndicator createActivityIndicator() {
    return IosActivityIndicator();
  }
  
  @override
  ISlider createSlider() {
    return IosSlider();
  }
  
  @override
  ISwitch createSwitch() {
    return IosSwitch();
  }
}

abstract class IActivityIndicator {
  Widget render();
}

class AndroidActivityIndicator implements IActivityIndicator {
  @override
  Widget render() {
    return CircularProgressIndicator(
      backgroundColor: Color(0xFFECECEC),
      valueColor: AlwaysStoppedAnimation<Color>(
        Colors.black.withOpacity(0.65),
      ),
    );
  }
}

class IosActivityIndicator implements IActivityIndicator {
  @override
  Widget render() {
    return CupertinoActivityIndicator();
  }
}

abstract class ISlider {
  Widget render(double value, ValueSetter<double> onChanged);
}

class AndroidSlider implements ISlider {
  @override
  Widget render(double value, ValueSetter<double> onChanged) {
    return Slider(
      activeColor: Colors.black,
      inactiveColor: Colors.grey,
      min: 0.0,
      max: 100.0,
      value: value,
      onChanged: onChanged,
    );
  }
}

class IosSlider implements ISlider {
  @override
  Widget render(double value, ValueSetter<double> onChanged) {
    return CupertinoSlider(
      min: 0.0,
      max: 100.0,
      value: value,
      onChanged: onChanged,
    );
  }
}

abstract class ISwitch {
  Widget render(bool value, ValueSetter<bool> onChanged);
}

class AndroidSwitch implements ISwitch {
  @override
  Widget render(bool value, ValueSetter<bool> onChanged) {
    return Switch(
      activeColor: Colors.black,
      value: value,
      onChanged: onChanged,
    );
  }
}

class IosSwitch implements ISwitch {
  @override
  Widget render(bool value, ValueSetter<bool> onChanged) {
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
    );
  }
}

class AbstractFactoryExample extends StatefulWidget {
  @override
  _AbstractFactoryExampleState createState() => _AbstractFactoryExampleState();
}

class _AbstractFactoryExampleState extends State<AbstractFactoryExample> {
  final List<IWidgetsFactory> widgetsFactoryList = [
    MaterialWidgetsFactory(),
    CupertinoWidgetsFactory(),
  ];
  
  int _selectedFactoryIndex = 0;
  
  IActivityIndicator _activityIndicator;
  
  ISlider _slider;
  double _sliderValue = 50.0;
  String get _sliderValueString => _sliderValue.toStringAsFixed(0);
  
  ISwitch _switch;
  bool _switchValue = false;
  String get _switchValueString => _switchValue ? 'ON' : 'OFF';
  
  @override
  void initState() {
    super.initState();
    _createWidgets();
  }
  
  void _createWidgets() {
    _activityIndicator = widgetsFactoryList[_selectedFactoryIndex].createActivityIndicator();
    _slider = widgetsFactoryList[_selectedFactoryIndex].createSlider();
    _switch = widgetsFactoryList[_selectedFactoryIndex].createSwitch();
  }
  
  void _setSelectedFactoryIndex(int index) {
    setState(() {
      _selectedFactoryIndex = index;
      _createWidgets();
    });
  }
  
  void _setSliderValue(double value) {
    setState(() {
      _sliderValue = value;
    });
  }
  
  void _setSwitchValue(bool value) {
    setState(() {
      _switchValue = value;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: <Widget>[
            FactorySelection(
              widgetsFactoryList: widgetsFactoryList,
              selectedIndex: _selectedFactoryIndex,
              onChanged: _setSelectedFactoryIndex,
            ),
            const SizedBox(height: 10.0),
            Text(
              'Widgets showcase',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 10.0),
            Text(
              'Process indicator',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 10.0),
            _activityIndicator.render(),
            const SizedBox(height: 10.0),
            Text(
              'Slder ($_sliderValueString%)',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 10.0),
            _slider.render(_sliderValue, _setSliderValue),
            const SizedBox(height: 10.0),
            Text(
              'Switch ($_switchValueString)',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 10.0),
            _switch.render(_switchValue, _setSwitchValue),
          ]
        )
      )
    );
  }
}

class FactorySelection extends StatelessWidget {
  final List<IWidgetsFactory> widgetsFactoryList;
  final int selectedIndex;
  final ValueSetter<int> onChanged;
  
  const FactorySelection({
    @required this.widgetsFactoryList,
    @required this.selectedIndex,
    @required this.onChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (var i=0; i<widgetsFactoryList.length; i++)
          RadioListTile(
            title: Text(widgetsFactoryList[i].getTitle()),
            value: i,
            groupValue: selectedIndex,
            selected: i == selectedIndex,
            activeColor: Colors.black,
            controlAffinity: ListTileControlAffinity.platform,
            onChanged: onChanged,
          ),
      ]
    );
  }
}
