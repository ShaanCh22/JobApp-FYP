import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobseek/profile/skill_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uuid/uuid.dart';
import '../Services/global_methods.dart';


class AddSkillScreen extends StatefulWidget {
  const AddSkillScreen({super.key});

  @override
  State<AddSkillScreen> createState() => _AddSkillScreenState();
}

class _AddSkillScreenState extends State<AddSkillScreen> {
  final _addExpFormKey = GlobalKey<FormState>();
  final Uuid _skillid=const Uuid();
  final TextEditingController _skilltext = TextEditingController(text: '');
  bool _isLoading = false;
  final User? _user=FirebaseAuth.instance.currentUser;

  Future _submitExpData() async{
    final isValid = _addExpFormKey.currentState!.validate();
    if(isValid) {
      setState(() {
        _isLoading=true;
      });
      try{
        FirebaseFirestore.instance.collection('Users').doc(_user?.uid).collection('Skills').doc(_skillid.v1()).set({
          'Title':_skilltext.text,
        });
        const SnackBar(
          content: Text('Changes saved'),
        );
        Navigator.pushReplacement(context, PageTransition(
            child: const SkillScreen(),
            type: PageTransitionType.topToBottom,
            duration: const Duration(milliseconds: 300)
        ));
      }catch(error){
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
      }
      Fluttertoast.showToast(
          msg: 'Submitted', toastLength: Toast.LENGTH_SHORT);
    }
    setState(() {
      _isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text('Add Skills',style: GoogleFonts.dmSans(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500
        ),),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 20.w,right: 20.w,bottom: 25.h),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _addExpFormKey,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        'Skill',
                        style: GoogleFonts.dmSans(
                            color: Colors.white, fontSize: 14.sp),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        controller: _skilltext,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Skill is a required field!';
                          }
                          else{
                            return null;
                          }
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          contentPadding: EdgeInsets.all(15),
                          filled: true,
                          fillColor: Color(0xff282837),
                          hintText: 'Ex: UI/UX Designer',
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent,)
                          ),
                          focusedBorder:OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff5800FF),)
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent,)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h,),
                SizedBox(
                  width: double.infinity,
                  height: 53.h,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff5800FF),
                          foregroundColor: Colors.black,
                          splashFactory: InkRipple.splashFactory,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r))),
                      onPressed: (){
                        _submitExpData();
                      },
                      child: _isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : Text(
                        'Save',
                        style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


