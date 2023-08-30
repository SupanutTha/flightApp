import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:flutter/material.dart';

class AutocompleteTextfield extends StatefulWidget {
  final String initialText;
  final TextEditingController controller;
  const AutocompleteTextfield({Key? key, required this.initialText, required this.controller});
  @override
  _AutocompleteTextfieldState createState() => _AutocompleteTextfieldState();
}

class _AutocompleteTextfieldState extends State<AutocompleteTextfield> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Column(
        children: [
          TypeAheadField<String>(
            textFieldConfiguration: TextFieldConfiguration(
              controller: widget.controller,
              decoration: InputDecoration(
                labelText: widget.initialText,
                border: UnderlineInputBorder()
              ),
            ),
            suggestionsCallback: (String pattern) {
              if (pattern.isEmpty) {
                return const Iterable<String>.empty();
              }
              return iataCodes.where((String option) {
                return option.contains(pattern.toUpperCase());
              });
            },
            itemBuilder: (BuildContext context, String suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            onSuggestionSelected: (String suggestion) {
              widget.controller.text = suggestion;
              debugPrint('You just selected $suggestion');
            },
          ),
        ],
      ),
    );
  }
}
List<String> iataCodes = [
  'POM', 'KEF', 'PRN', 'YEG', 'YHZ', 'YOW', 'YUL', 'YVR', 'YWG', 'YYC', 'YYJ',
  'YYT', 'YYZ', 'ALG', 'OUA', 'ACC', 'ABV', 'QUO', 'KAN', 'LOS', 'NIM', 'TUN',
  'BRU', 'CRL', 'LGG', 'SXF', 'DRS', 'FRA', 'FMO', 'HAM', 'CGN', 'DUS', 'MUC',
  'NUE', 'LEJ', 'STR', 'TXL', 'HAJ', 'BRE', 'DTM', 'FKB', 'TLL', 'HEL', 'BFS',
  'BHD', 'BHX', 'MAN', 'DSA', 'CWL', 'BRS', 'LPL', 'LTN', 'BOH', 'SOU', 'LGW',
  'LHR', 'LBA', 'NCL', 'EMA', 'ABZ', 'GLA', 'EDI', 'NWI', 'STN', 'EXT', 'LKZ',
  'MHZ', 'FFD', 'BZZ', 'AMS', 'EIN', 'ORK', 'DUB', 'SNN', 'BLL', 'CPH', 'AAL',
  'LUX', 'BOO', 'BGO', 'OSL', 'TOS', 'TRD', 'SVG', 'GDN', 'KRK', 'KTW', 'WMI',
  'POZ', 'WAW', 'WRO', 'GOT', 'MMX', 'LLA', 'ARN', 'RMS', 'RIX', 'VNO', 'CPT',
  'GRJ', 'DUR', 'JNB', 'GBE', 'SHO', 'MRU', 'LUN', 'TNR', 'LAD', 'MPM', 'SEZ',
  'NDJ', 'HRE', 'WDH', 'FIH', 'BKO', 'SPC', 'LPA', 'TFS', 'TFN', 'FNA', 'ROB',
  'CMN', 'DSS', 'DKR', 'NKC', 'SID', 'ADD', 'HGA', 'CAI', 'HRG', 'LXR', 'NBO',
  'MBA', 'TIP', 'KGL', 'JUB', 'KRT', 'DAR', 'ZNZ', 'EBB', 'AAP', 'ABQ', 'ADW',
  'AFW', 'AGS', 'AMA', 'ATL', 'AUS', 'AVL', 'BAB', 'BAD', 'BDL', 'BFI', 'BGR',
  'BHM', 'BIL', 'BLV', 'BMI', 'BNA', 'BOI', 'BOS', 'BUF', 'BWI', 'CAE', 'CBM',
  'CHA', 'CHS', 'CID', 'CLE', 'CLT', 'CMH', 'COS', 'CRP', 'CRW', 'CVG', 'CVS',
  'DAB', 'DAL', 'DAY', 'DBQ', 'DCA', 'DEN', 'DFW', 'DLF', 'DLH', 'DOV', 'DSM',
  'DTW', 'DYS', 'EDW', 'END', 'ERI', 'EWR', 'FFO', 'FLL', 'FSM', 'FTW', 'FWA',
  'GEG', 'GPT', 'GRB', 'GSB', 'GSO', 'GSP', 'GUS', 'HIB', 'HMN', 'HOU', 'HSV',
  'HTS', 'IAD', 'IAH', 'ICT', 'IND', 'JAN', 'JAX', 'JFK', 'JLN', 'LAS', 'LAX',
  'LBB', 'LCK', 'LEX', 'LFI', 'LFT', 'LGA', 'LIT', 'LTS', 'LUF', 'MBS', 'MCF',
  'MCI', 'MCO', 'MDW', 'MEM', 'MGE', 'MGM', 'MHT', 'MIA', 'MKE', 'MLI', 'MLU',
  'MOB', 'MSN', 'MSP', 'MSY', 'MUO', 'OAK', 'OKC', 'OMA', 'ONT', 'ORD', 'ORF',
  'PAM', 'PBI', 'PDX', 'PHF', 'PHL', 'PHX', 'PIA', 'PIT', 'PVD', 'PWM', 'RDU',
  'RFD', 'RIC', 'RND', 'RNO', 'ROA', 'ROC', 'RST', 'RSW', 'SAN', 'SAT', 'SAV',
  'SBN', 'SDF', 'SEA', 'SFB', 'SFO', 'SGF', 'SJC', 'SKA', 'SLC', 'SMF', 'SNA',
  'SPI', 'SPS', 'SRQ', 'SSC', 'STL', 'SUS', 'SUU', 'SUX', 'SYR', 'SZL', 'TCM',
  'TIK', 'TLH', 'TOL', 'TPA', 'TRI', 'TUL', 'TUS', 'TYS', 'VBG', 'VPS', 'WRB',
  'TIA', 'BOJ', 'SOF', 'VAR', 'LCA', 'PFO', 'AKT', 'ZAG', 'ALC', 'BCN', 'MAD',
  'AGP', 'PMI', 'SCQ', 'BOD', 'TLS', 'LYS', 'MRS', 'NCE', 'CDG', 'ORY', 'BSL',
  'ATH', 'HER', 'SKG', 'BUD', 'BRI', 'CTA', 'PMO', 'CAG', 'MXP', 'BGY', 'TRN',
  'GOA', 'LIN', 'BLQ', 'TSF', 'VRN', 'VCE', 'CIA', 'FCO', 'NAP', 'PSA', 'LJU',
  'PRG', 'TLV', 'VDA', 'MLA', 'VIE', 'FAO', 'TER', 'PDL', 'OPO', 'LIS', 'SJJ',
  'OTP', 'GVA', 'ZRH', 'ESB', 'ADA', 'AYT', 'GZT', 'ISL', 'ADB', 'DLM', 'ERZ',
  'TZX', 'ISE', 'BJV', 'SAW', 'IST', 'SKP', 'BEG', 'TGD', 'BTS', 'PUJ', 'SDQ',
  'GUA', 'KIN', 'ACA', 'GDL', 'HMO', 'MEX', 'MTY', 'PVR', 'SJD', 'TIJ', 'CUN',
  'PTY', 'LIR', 'SAL', 'HAV', 'VRA', 'GCM', 'NAS', 'BZE', 'RAR', 'PPT', 'AKL',
  'CHC', 'WLG', 'BAH', 'DMM', 'DHA', 'JED', 'MED', 'RUH', 'IKA', 'THR', 'MHD',
  'SYZ', 'TBZ', 'AMM', 'KWI', 'BEY', 'DQM', 'MNH', 'AUH', 'DXB', 'DWC', 'SHJ',
  'MCT', 'ISB', 'SKT', 'BGW', 'BSR', 'ALP', 'DAM', 'LTK', 'DOH', 'FAI', 'ANC',
  'GUM', 'CGY', 'HNL', 'KNH', 'KHH', 'TPE', 'NRT', 'KIX', 'CTS', 'FUK', 'KOJ',
  'NGO', 'FSZ', 'ITM', 'HND', 'OKO', 'MWX', 'KUV', 'CJU', 'PUS', 'ICN', 'OSN',
  'GMP', 'CJJ', 'OKA', 'DNA', 'CRK', 'MNL', 'DVO', 'CEB', 'GRV', 'EZE', 'BEL',
  'BSB', 'CNF', 'CWB', 'MAO', 'FLN', 'GIG', 'GRU', 'NAT', 'CGH', 'SSA', 'SCL',
  'LTX', 'UIO', 'BOG', 'VVI', 'LIM', 'CUZ', 'MVD', 'BLA', 'CCS', 'PTP', 'SJU',
  'NBE', 'SXM', 'ALA', 'TSE', 'FRU', 'KGF', 'GYD', 'EVN', 'TBS', 'KHV', 'KBP',
  'SIP', 'HRK', 'ODS', 'LED', 'MSQ', 'KJA', 'OVB', 'ROV', 'AER', 'SVX', 'ASB',
  'TAS', 'ZIA', 'DME', 'SVO', 'VKO', 'KZN', 'UFA', 'KUF', 'BOM', 'GOI', 'CMB',
  'HRI', 'PNH', 'REP', 'CCU', 'DAC', 'HKG', 'ATQ', 'DEL', 'MFM', 'KTM', 'BLR',
  'COK', 'CCJ', 'HYD', 'MAA', 'TRV', 'MLE', 'DMK', 'BKK', 'CNX', 'HKT', 'DAD',
  'HAN', 'SGN', 'MDL', 'RGN', 'UPG', 'DPS', 'DJJ', 'SUB', 'SOQ', 'BWN', 'CGK',
  'KNO', 'KUL', 'SIN', 'BNE', 'MEL', 'YNT', 'ADL', 'PER', 'CBR', 'SYD', 'PEK',
  'PKX', 'HET', 'NAY', 'TSN', 'TYN', 'CAN', 'CSX', 'KWL', 'NNG', 'SZX', 'CGO',
  'WUH', 'HAK', 'SYX', 'XIY', 'UBN', 'ULN', 'KMG', 'XMN', 'FOC', 'HGH', 'TNA',
  'NGB', 'NKG', 'PVG', 'SHA', 'WNZ', 'CKG', 'KWE', 'CTU', 'URC', 'HRB', 'DLC',
  'SHE','KBV'
];
