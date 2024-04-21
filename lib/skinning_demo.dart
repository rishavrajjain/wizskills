import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';

/// Basic skinning example. The skinning states is set in the Rive editor and
/// triggers are used to change the value.
class SkinningDemo extends StatefulWidget {
  const SkinningDemo({super.key});

  @override
  State<SkinningDemo> createState() => _SkinningDemoState();
}

class _SkinningDemoState extends State<SkinningDemo> {
  Artboard? _teddyArtboard;

  static const _skinMapping = {
    "Skin_0": "Plain",
    "Skin_1": "Summer",
    "Skin_2": "Elvis",
    "Skin_3": "Superhero",
    "Skin_4": "Astronaut"
  };

  String _currentState = 'Plain';

  SMITrigger? _skin;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'Motion',
      onStateChange: _onStateChange,
    );

    artboard.addController(controller!);
    _skin = controller.findInput<bool>('Skin') as SMITrigger;
  }

  void _onStateChange(String stateMachineName, String stateName) {
    if (stateName.contains("Skin_")) {
      setState(() {
        _currentState = _skinMapping[stateName] ?? 'Plain';
      });
    }
  }

  void _swapSkin() {
    _skin?.fire();
  }

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFFefcb7d);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skinning Demo'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'Choose an Avatar',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: 400,
            height: 400,
            child: Rive(
              artboard: _teddyArtboard!,
              fit: BoxFit.fitWidth,
            ),
          )
        ],
      ),
    );
  }
}
