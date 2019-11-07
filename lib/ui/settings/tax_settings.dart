import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:invoiceninja_flutter/ui/app/buttons/elevated_button.dart';
import 'package:invoiceninja_flutter/ui/app/form_card.dart';
import 'package:invoiceninja_flutter/ui/app/forms/app_dropdown_button.dart';
import 'package:invoiceninja_flutter/ui/app/forms/app_form.dart';
import 'package:invoiceninja_flutter/ui/app/forms/bool_dropdown_button.dart';
import 'package:invoiceninja_flutter/ui/app/invoice/tax_rate_dropdown.dart';
import 'package:invoiceninja_flutter/ui/settings/settings_scaffold.dart';
import 'package:invoiceninja_flutter/ui/settings/tax_settings_vm.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';

class TaxSettings extends StatefulWidget {
  const TaxSettings({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final TaxSettingsVM viewModel;

  @override
  _TaxSettingsState createState() => _TaxSettingsState();
}

class _TaxSettingsState extends State<TaxSettings> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final viewModel = widget.viewModel;
    final company = viewModel.company;
    final settings = viewModel.settings;
    final state = viewModel.state;

    return SettingsScaffold(
      title: localization.taxSettings,
      onSavePressed: viewModel.onSavePressed,
      body: AppForm(
        formKey: _formKey,
        children: <Widget>[
          FormCard(
            children: <Widget>[
              AppDropdownButton(
                labelText: localization.invoiceTaxRates,
                // TODO remove this
                showBlank: true,
                value: settings.numberOfInvoiceTaxRates == null
                    ? ''
                    : '${settings.numberOfInvoiceTaxRates}',
                onChanged: (value) => viewModel.onSettingsChanged(
                    settings.rebuild(
                        (b) => b..numberOfInvoiceTaxRates = int.parse(value))),
                items: List<int>.generate(3, (i) => i + 1)
                    .map((value) => DropdownMenuItem<String>(
                          child: Text('$value'),
                          value: '$value',
                        ))
                    .toList(),
              ),
              BoolDropdownButton(
                iconData: FontAwesomeIcons.percent,
                label: localization.inclusiveTaxes,
                value: settings.enableInclusiveTaxes,
                onChanged: (value) => viewModel.onSettingsChanged(
                    settings.rebuild((b) => b..enableInclusiveTaxes = value)),
              ),
            ],
          ),
          if (settings.enableFirstInvoiceTaxRate)
            FormCard(
              children: <Widget>[
                TaxRateDropdown(
                  taxRates: company.taxRates,
                  onSelected: (taxRate) =>
                      viewModel.onSettingsChanged(settings.rebuild((b) => b
                        ..defaultTaxName1 = taxRate.name
                        ..defaultTaxRate1 = taxRate.rate)),
                  labelText: localization.defaultTaxRate,
                  initialTaxName: settings.defaultTaxName1,
                  initialTaxRate: settings.defaultTaxRate1,
                ),
                if (settings.enableSecondInvoiceTaxRate)
                  TaxRateDropdown(
                    taxRates: company.taxRates,
                    onSelected: (taxRate) =>
                        viewModel.onSettingsChanged(settings.rebuild((b) => b
                          ..defaultTaxName2 = taxRate.name
                          ..defaultTaxRate2 = taxRate.rate)),
                    labelText: localization.defaultTaxRate,
                    initialTaxName: settings.defaultTaxName2,
                    initialTaxRate: settings.defaultTaxRate2,
                  ),
                if (settings.enableThirdInvoiceTaxRate)
                  TaxRateDropdown(
                    taxRates: company.taxRates,
                    onSelected: (taxRate) =>
                        viewModel.onSettingsChanged(settings.rebuild((b) => b
                          ..defaultTaxName3 = taxRate.name
                          ..defaultTaxRate3 = taxRate.rate)),
                    labelText: localization.defaultTaxRate,
                    initialTaxName: settings.defaultTaxName3,
                    initialTaxRate: settings.defaultTaxRate3,
                  ),
              ],
            ),
          if (!state.uiState.settingsUIState.isFiltered)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                label: localization.configureRates.toUpperCase(),
                onPressed: () => viewModel.onConfigureRatesPressed(context),
              ),
            ),
        ],
      ),
    );
  }
}