import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: AppLocalizations.of(context)!.init_title,
                inputFormatters: [LengthLimitingTextInputFormatter(30)],
                validator: (value) => _handleTitleValidation(value),
                onChanged: (value) => {title = value},
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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4)
                ],
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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4)
                ],
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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4)
                ],
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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4)
                ],
                validator: (value) => _handleTimeValidation(value),
                onChanged: (value) => {cooldown = value},
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter cooldown time",
                    labelText: "Cooldown"),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              ConstrainedBox(
                  constraints: const BoxConstraints(
                      minHeight: 40,
                      minWidth: 300,
                      maxHeight: 50,
                      maxWidth: 350),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(currentColor)),
                      onPressed: () => _pickColor(context),
                      child: Text(
                        AppLocalizations.of(context)!.color_pick,
                        style: Theme.of(context).textTheme.button,
                      )))
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
                        AppLocalizations.of(context)!.add_btn,
                        style: Theme.of(context).textTheme.button,
                      )))),
        ]));
  }

  void _submitInput(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      var t = TTimer(
          cooldown: int.parse(cooldown),
          color: currentColor,
          cycles: int.parse(cycles),
          rest: int.parse(rest),
          title: title,
          workout: int.parse(workout),
          wormUp: int.parse(wormUp));
      Navigator.of(context).pop(t);
    }
  }

  void _pickColor(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.color_pick,
                style: Theme.of(context).textTheme.bodyText1),
            content: SingleChildScrollView(
                child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (value) => setState(() {
                pickerColor = value;
              }),
            )),
            actions: <Widget>[
              ElevatedButton(
                child: Text(
                  AppLocalizations.of(context)!.done_btn,
                  style: Theme.of(context).textTheme.button,
                ),
                onPressed: () {
                  setState(() => currentColor = pickerColor);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  String? _handleTimeValidation(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.empty_input;
    }
    return null;
  }

  String? _handleTitleValidation(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.empty_title;
    }
    return null;
  }
}
