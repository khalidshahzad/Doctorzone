import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo.shade900,
          title: Text(
            'Privacy Policy',
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('End User License Agreement (EULA)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'The end user of this application (DoctorZone.pk) agrees and accepts the following terms and conditions:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '1. DoctorZone.pk is basically a platform to facilitate the patient and doctor/consultant appointment process',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '2. There is no hidden charges for use of basic service i.e. doctor/consultant appointment for patients',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '3. Any value added service provided on this platform will incur listed charges as per schedule announced by DoctorZone.pk',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '4. DoctorZone.pk is a facilitation platform that attempts to provide high quality of service to patients however takes no legal responsibility about ',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '5. Morality\/Legality/Quality of service provided by the doctor\/consultant\nCharges\/fee required by the relevant doctor\/consultant\nConfirmation and execution of appointment. This is between the patient and doctor\/consultant with no responsibility of DoctorZone.pk',
              ),
            )
          ],
        ));
  }
}
