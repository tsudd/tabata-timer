import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tabata/data/models/timer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditSeqWidget extends StatefulWidget {
  const EditSeqWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditSeqWidget();
  }
}

class _EditSeqWidget extends State<EditSeqWidget> {
  final _formKey = GlobalKey<FormState>();

  String title = '';
  String wormUp = '';
  String workout = '';
  String rest = '';
  String cycles = '';
  String cooldown = '';

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(30)
                    ],
                    validator: (value) => _handleTitleValidation(value),
                    onChanged: (value) => {wormUp = value},
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter the title',
                        labelText: 'Title'),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4)
                    ],
                    validator: (value) => _handleTimeValidation(value),
                    onChanged: (value) => {wormUp = value},
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter warm-up time",
                        labelText: "Warm-up"),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) => _handleTimeValidation(value),
                    onChanged: (value) => {workout = value},
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter workout time",
                        labelText: "Workout"),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) => _handleTimeValidation(value),
                    onChanged: (value) => {rest = value},
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter rest time",
                        labelText: "Rest"),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) => _handleTimeValidation(value),
                    onChanged: (value) => {cycles = value},
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter cycles amount",
                        labelText: "Cycles"),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) => _handleTimeValidation(value),
                    onChanged: (value) => {cooldown = value},
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter cooldown time",
                        labelText: "Cooldown"),
                    style: Theme.of(context).textTheme.bodyText1,
                  )
                ]),
              ),
              Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ConstrainedBox(
                      constraints: const BoxConstraints(
                          minHeight: 40,
                          minWidth: 300,
                          maxHeight: 50,
                          maxWidth: 350),
                      child: ElevatedButton(
                          onPressed: () => _submitInput(context),
                          child: Text(
                            "Add",
                            style: Theme.of(context).textTheme.button,
                          ))))
            ]));
  }

  void _submitInput(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      var t = TTimer(
          cooldown: int.parse(cooldown),
          color: Colors.red,
          cycles: int.parse(cycles),
          rest: int.parse(rest),
          title: title,
          workout: int.parse(workout),
          wormUp: int.parse(wormUp));
      Navigator.of(context).pop(t);
    }
  }

  String? _handleTimeValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter duration";
    }
    if (value.length > 4) {
      return "Duration is too long";
    }
    return null;
  }

  String? _handleTitleValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Title must be non-empty";
    }
    return null;
  }
}
