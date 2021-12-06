import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabata/presentation/widgets/edit_seq_widget.dart';

class EditSeqPage extends StatelessWidget {
  const EditSeqPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: const EditSeqWidget());
  }
}
