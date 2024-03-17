import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Services/global_methods.dart';

class AboutMeScreen extends StatefulWidget {
  const AboutMeScreen({super.key});
  @override
  State<AboutMeScreen> createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  final _aboutdataFormKey = GlobalKey<FormState>();
  final TextEditingController _aboutmeController =
  TextEditingController(text: '');
  String? gender;
  bool _isLoading = false;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAboutData();
  }

  Future _getAboutData() async{
    DocumentSnapshot ref = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    setState(() {
      _aboutmeController.text=ref.get('About Me');
    });
  }
  Future uploadAboutData() async{
    final isValid =_aboutdataFormKey.currentState!.validate();
    if(isValid){
      setState(() {
        _isLoading=true;
      });
      try{
        final User? user=_auth.currentUser;
        final uid=user!.uid;
        FirebaseFirestore.instance.collection('Users').doc(uid).update({
          'About Me':_aboutmeController.text
        });
        Future.delayed(const Duration(seconds:1)).then((value) => {
          setState(() {
            _isLoading=false;
            Fluttertoast.showToast(
                msg: 'Changes saved', toastLength: Toast.LENGTH_SHORT);
          })
        });
      }catch(error){
        setState(() {
          _isLoading=false;
        });
        GlobalMethod.showErrorDialog(
            error: error.toString(),
            ctx: context);
      }
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text('About Me',style: GoogleFonts.dmSans(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500
        ),),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 20.w),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading:Text('Summary',style: GoogleFonts.dmSans(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500
            ),),
            trailing: Text('Maximum 150 words',style: GoogleFonts.dmSans(
                color: Colors.grey,
                fontSize: 15.sp
            ),),
          ),
          SizedBox(height: 24.h,),
          Form(
            key: _aboutdataFormKey,
            child: TextFormField(
              maxLength: 150,
              maxLines: 8,
              textInputAction: TextInputAction.next,
              // focusNode: _passFocusNode,
              keyboardType: TextInputType.text,
              controller: _aboutmeController,
              style: const TextStyle(
                color: Colors.white,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return;
                }else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                isCollapsed: true,
                contentPadding: EdgeInsets.all(15),
                filled: true,
                fillColor: Color(0xff282837),
                hintText: 'Write your bio...',
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder:
                UnderlineInputBorder(borderSide: BorderSide.none),
                focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.redAccent,
                    )),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff5800FF),
                    )),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.redAccent,
                    )),
              ),
            ),
          ),
          SizedBox(height: 35.h,),
          SizedBox(
            width: double.infinity,
            height: 53.h,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    splashFactory: InkRipple.splashFactory,
                    backgroundColor: const Color(0xff5800FF),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r))),
                onPressed: (){
                  uploadAboutData();
                },
                child: _isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : Text(
                  'Submit',
                  style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold),
                )),
          ),

        ],
      ),
    );
  }
}
