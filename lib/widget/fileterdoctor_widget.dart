import '../screens/selected_doctor_screen.dart';
import 'package:flutter/material.dart';
import '../ip.dart' as Ip;

// ignore: must_be_immutable
class SearchedDoctorWidget extends StatelessWidget {
  var filteredDoctor;
  SearchedDoctorWidget({this.filteredDoctor});

  @override
  Widget build(BuildContext context) {
    //print(filteredDoctor.length);
    return ListView.builder(
      padding: EdgeInsets.all(5),
      itemCount: filteredDoctor['personaldata'].length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Card(
            elevation: 1,
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  margin: const EdgeInsets.only(bottom: 30, left: 8, right: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: DecorationImage(
                        scale: 1,
                        // ignore: unrelated_type_equality_checks
                        image: (filteredDoctor == '' || filteredDoctor == null)
                            ? NetworkImage(
                                '${Ip.serverip}/uploads/${filteredDoctor['personaldata'][index]['pic']}',
                              )
                            : AssetImage(
                                'asset/user.png',
                              ),
                        fit: BoxFit.fill),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 83),
                    child: Column(
                      children: [],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            filteredDoctor['personaldata'][index]['fullname'] ==
                                    null
                                ? ""
                                : filteredDoctor['personaldata'][index]
                                    ['fullname'],
                            style: TextStyle(fontSize: 17, color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: Row(
                        children: [
                          Text(
                            'M.B.B.S, F.C.P.S',
                            style:
                                TextStyle(fontSize: 17, color: Colors.black45),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: filteredDoctor['personaldata'][index]
                                  ['fullname'] !=
                              null
                          ? Text(
                              filteredDoctor['experiences'][index] +
                                  'years experience'.toString(),
                              style: TextStyle(fontSize: 17, color: Colors.red),
                              overflow: TextOverflow.ellipsis,
                            )
                          : Text(''),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: Row(
                        children: [
                          Text(
                            'Orthopedic',
                            style:
                                TextStyle(fontSize: 17, color: Colors.black45),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(',General Sergeon')
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          contentPadding: EdgeInsets.all(8),
          onTap: () {
            Navigator.of(context)
                .pushNamed(SelectedDoctorProfileScreen.routeName, arguments: {
              'docUID': filteredDoctor['personaldata'][index]['id']
            });
          },
        );
      },
    );
  }
}
