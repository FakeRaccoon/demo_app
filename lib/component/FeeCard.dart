import 'package:atana/component/Fee.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';

typedef OnDelete();

class FeeForm extends StatefulWidget {
  final FeeData feeData;
  final state = _FeeFormState();
  final OnDelete onDelete;

  FeeForm({Key key, this.onDelete, this.feeData}) : super(key: key);
  @override
  _FeeFormState createState() => state;

  bool isValid() => state.validate();
}

class _FeeFormState extends State<FeeForm> {
  final form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Form(
        key: form,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Perkiraan Biaya',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  onChanged: (String val) {
                    widget.feeData.fee = val;
                    print(val);
                  },
                  initialValue: widget.feeData.fee,
                  onSaved: (val) {
                    // widget.feeData.fee = val;
                    // print(val);
                  },
                  validator: (val) => val.isNotEmpty ? null : 'Isi perkiraan biaya',
                  keyboardType: TextInputType.number,
                  inputFormatters: [CurrencyTextInputFormatter(decimalDigits: 0, symbol: 'Rp ')],
                  decoration: InputDecoration(
                    hintText: 'Biaya',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Deskripsi Biaya',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: TextFormField(
                  initialValue: widget.feeData.feeDesc,
                  onSaved: (val) => widget.feeData.feeDesc = val,
                  validator: (val) => val.isNotEmpty ? null : 'Isi deskripsi biaya',
                  decoration: InputDecoration(
                    hintText: 'Deskripsi biaya',
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                  alignment: Alignment.centerRight, child: FlatButton(onPressed: widget.onDelete, child: Text('Hapus')))
            ],
          ),
        ),
      ),
    );
  }

  ///form validator
  bool validate() {
    var valid = form.currentState.validate();
    if (valid) form.currentState.save();
    return valid;
  }
}
