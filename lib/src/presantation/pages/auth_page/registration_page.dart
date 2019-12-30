import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:qr/src/domain/entities/exceptions.dart';
import 'package:qr/src/presantation/locale/strings.dart' as qrLocale;
import 'package:qr/src/presantation/pages/auth_page/auth_payload.dart';
import 'package:qr/src/presantation/routes.dart' as routes;
import 'package:qr/src/presantation/widgets/auth_button.dart';
import 'package:qr/src/presantation/widgets/auth_layout.dart';
import 'package:qr/src/presantation/widgets/info_dialog.dart';
import 'package:qr/src/presantation/widgets/without_error_text_form_field.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formStateKey = GlobalKey<FormState>();

  FocusNode _positionFieldFocusNode = FocusNode();
  FocusNode _phoneFieldFocusNode = FocusNode();

  bool _isCreateAccountButtonActive = false;

  String _name;
  String _position;
  String _phone;

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: _buildRegistrationForm(),
    );
  }

  Widget _buildRegistrationForm() {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
              isDense: true,
            ),
      ),
      child: AuthContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildTitle(),
            SizedBox(height: 32.0),
            Form(
              key: _formStateKey,
              onChanged: _onFormChanged,
              child: Column(
                children: <Widget>[
                  _buildNameFormField(),
                  _buildEmailFormField(),
                  _buildPositionFormField(),
                  _buildPhoneFormField(),
                  SizedBox(height: 32.0),
                  _buildCreateAccountButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      qrLocale.registration,
    );
  }

  void _onFormChanged() {
    bool isFormFieldValidated = _formStateKey.currentState.validate();
    if (_isCreateAccountButtonActive != isFormFieldValidated) {
      setState(
        () => _isCreateAccountButtonActive = isFormFieldValidated,
      );
    }
  }

  Widget _buildNameFormField() {
    final GooglePayload payload = ModalRoute.of(context).settings.arguments;

    return WithoutErrorTextFormField(
      decoration: InputDecoration(labelText: qrLocale.name),
      initialValue: payload.name,
      validator: _validateIsEmpty,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: _onNameSubmitted,
      onSaved: _onSavedName,
    );
  }

  void _onNameSubmitted(_) {
    FocusScope.of(context).requestFocus(_positionFieldFocusNode);
  }

  void _onSavedName(String newValue) {
    _name = newValue;
  }

  Widget _buildPositionFormField() {
    return WithoutErrorTextFormField(
      decoration: InputDecoration(labelText: qrLocale.position),
      validator: _validateIsEmpty,
      textInputAction: TextInputAction.next,
      focusNode: _positionFieldFocusNode,
      onFieldSubmitted: _onPositionSubmitted,
      onSaved: _onSavedPosition,
    );
  }

  String _validateIsEmpty(String value) {
    if (value.isEmpty) {
      return '';
    } else {
      return null;
    }
  }

  void _onPositionSubmitted(_) {
    FocusScope.of(context).requestFocus(_phoneFieldFocusNode);
  }

  void _onSavedPosition(String newValue) {
    _position = newValue;
  }

  Widget _buildEmailFormField() {
    final GooglePayload payload = ModalRoute.of(context).settings.arguments;

    return WithoutErrorTextFormField(
      decoration: InputDecoration(labelText: qrLocale.email),
      initialValue: payload.email,
      enabled: false,
    );
  }

  Widget _buildPhoneFormField() {
    return WithoutErrorTextFormField(
      decoration: InputDecoration(
        labelText: qrLocale.phone,
        hintText: qrLocale.phoneExample,
      ),
      keyboardType: TextInputType.phone,
      validator: _validatePhone,
      focusNode: _phoneFieldFocusNode,
      onFieldSubmitted: (_) => _register(),
      onSaved: _onSavedPhone,
    );
  }

  void _onSavedPhone(String newValue) {
    _phone = newValue;
  }

  String _validatePhone(String value) {
    RegExp regExp = RegExp(r'^\+380\d{9}$');

    if (regExp.hasMatch(value)) {
      return null;
    } else {
      return '';
    }
  }

  Widget _buildCreateAccountButton() {
    return AuthButton(
      title: qrLocale.createAccount,
      isButtonActive: _isCreateAccountButtonActive,
      onPressed: _register,
    );
  }

  Future _register() async {
    if (_formStateKey.currentState.validate()) {
      _formStateKey.currentState.save();
      try {
        await _signUpViaGoogle();
        _createRoute();
      } on UserIsAlreadyRegisteredException {
        _errorDialog(qrLocale.userAlreadyRegistered);
      } catch (e) {
        print('Unknown error $e');
      }
    }
  }

  Future<void> _signUpViaGoogle() async {
    final GooglePayload payload = ModalRoute.of(context).settings.arguments;

    final registrationPayload = GoogleRegistrationPayload(
      _name,
      _position,
      payload.email,
      _phone,
      payload.googleId,
    );

    print(registrationPayload);
    //todo: sign up with google
  }

  void _createRoute() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      routes.inventories,
      (_) => false,
    );
  }

  Future<void> _errorDialog(String info) async {
    await showInfoDialog(
      context: context,
      errorMessage: info,
      onPressed: _returnToSignUpScreen,
    );
  }

  void _returnToSignUpScreen() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _phoneFieldFocusNode.dispose();
    super.dispose();
  }
}
