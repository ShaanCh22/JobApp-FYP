import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobseek/profile/profile_page.dart';
import 'package:page_transition/page_transition.dart';

import '../Services/global_methods.dart';
import 'gender_screen.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _editDataFormKey = GlobalKey<FormState>();
  final TextEditingController _emailTextControler =
  TextEditingController(text: '');
  final TextEditingController _phoneTextControler =
  TextEditingController(text: '');
  bool _isLoading = false;
  File? imageFile;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String? imageUrl;
  String? _imgUrl;
  String? _gndr;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getEditProfileData();
  }
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    _getGender();

  }
  Future pickImage()async{
    try{
      final image=await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image==null) return;
      cropImage(image.path);
    }catch(e){
      return 'Failed to pick image';
    }
  }
  Future pickImageCamera()async{
    try{
      final image=await ImagePicker().pickImage(source: ImageSource.camera);
      if (image==null) return;
      cropImage(image.path);
    }catch(e){
      return 'Failed to pick image';
    }
  }
  Future cropImage(filePath)async{
    CroppedFile? croppedImage=await ImageCropper().cropImage(
        sourcePath: filePath,
        maxHeight: 1080,
        maxWidth: 1080
    );
    if(croppedImage==null){
      setState(() {
        imageFile=null;
      });
    }
    if(croppedImage!=null){
      setState(() {
        imageFile=File(croppedImage.path);
      });
    }
  }
  Future uploadProfileData() async{
    final isValid =_editDataFormKey.currentState!.validate();
    if(isValid){
      setState(() {
        _isLoading=true;
      });
      try{
        final User? user=_auth.currentUser;
        final uid=user!.uid;
        final ref=FirebaseStorage.instance.ref().child('userProfileImages').child('$uid.jpg');
        if(imageFile!=null){
          await ref.putFile(imageFile!);
          imageUrl=await ref.getDownloadURL();
          FirebaseFirestore.instance.collection('Users').doc(uid).update({
            'User Image':imageUrl,
            'Phone Number':_phoneTextControler.text,
          });
        }
        FirebaseFirestore.instance.collection('Users').doc(uid).update({
          'Phone Number':_phoneTextControler.text,
        });
        const SnackBar(
          content: Text('Changes saved'),
        );
        Navigator.push(context, PageTransition(child: ProfilePage(), type: PageTransitionType.topToBottom));
      }catch(error){
        setState(() {
          _isLoading=false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
      }
    }
    setState(() {
      _isLoading=false;
    });
  }
  void deletePF(){
    final User? user=_auth.currentUser;
    final uid=user!.uid;
    FirebaseFirestore.instance.collection('Users').doc(uid).update({
      'User Image':'',
    });
  }
  Future _getEditProfileData() async{
    DocumentSnapshot ref = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    setState(() {
      _emailTextControler.text=ref.get('Email');
      _phoneTextControler.text=ref.get('Phone Number');
      _imgUrl=ref.get('User Image');
      _gndr=ref.get('Gender');
    });
  }
  Future _getGender() async{
    DocumentSnapshot ref = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    setState(() {
      _gndr=ref.get('Gender');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text('Edit Profile',style: GoogleFonts.dmSans(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500
        ),),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 20.w),
        children: [
          GestureDetector(
            onTap: (){
              showModalBottomSheet(
                  backgroundColor: const Color(0xff1D1D2F),
                  context: context,
                  builder: (BuildContext context){
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed:(){
                            pickImageCamera();
                            Navigator.pop(context);
                          },
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Color(0xff1D1D2F)),
                            padding: MaterialStatePropertyAll(EdgeInsets.zero),
                            shape: MaterialStatePropertyAll(BeveledRectangleBorder(borderRadius: BorderRadius.zero)),
                            // splashFactory: InkSplash.splashFactory,
                            splashFactory: InkSparkle.splashFactory,
                            overlayColor: MaterialStatePropertyAll(Color(
                                0x4d5800ff)),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.camera_alt,color: Colors.white,),
                            title: Text('Take profile picture',style: GoogleFonts.dmSans(
                                color: Colors.white
                            ),),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: (){
                            pickImage();
                            Navigator.pop(context);
                          },
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Color(0xff1D1D2F)),
                            padding: MaterialStatePropertyAll(EdgeInsets.zero),
                            shape: MaterialStatePropertyAll(BeveledRectangleBorder(borderRadius: BorderRadius.zero)),
                            // splashFactory: InkSplash.splashFactory,
                            splashFactory: InkSparkle.splashFactory,
                            overlayColor: MaterialStatePropertyAll(Color(
                                0x4d5800ff)),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.photo_library,color: Colors.white,),
                            title: Text('Select profile picture',style: GoogleFonts.dmSans(
                                color: Colors.white
                            ),),
                          ),
                        ),
                        _imgUrl=='' ?
                        imageFile==null ?
                        const SizedBox() :
                        ElevatedButton(
                          onPressed: (){
                            setState(() {
                              imageFile=null;
                            });
                            Navigator.pop(context);
                          },
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Color(0xff1D1D2F)),
                            padding: MaterialStatePropertyAll(EdgeInsets.zero),
                            shape: MaterialStatePropertyAll(BeveledRectangleBorder(borderRadius: BorderRadius.zero)),
                            // splashFactory: InkSplash.splashFactory,
                            splashFactory: InkSparkle.splashFactory,
                            overlayColor: MaterialStatePropertyAll(Color(
                                0x4d5800ff)),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.delete_forever,color: Colors.white,),
                            title: Text('Delete profile image',style: GoogleFonts.dmSans(
                                color: Colors.white
                            ),),
                          ),
                        ) :
                        ElevatedButton(
                          onPressed: (){
                            setState(() {
                              deletePF();
                              _imgUrl=null;
                              imageFile=null;
                              imageUrl=null;
                              Navigator.pop(context);
                            });
                            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const EditProfilePage()));
                          },
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Color(0xff1D1D2F)),
                            padding: MaterialStatePropertyAll(EdgeInsets.zero),
                            shape: MaterialStatePropertyAll(BeveledRectangleBorder(borderRadius: BorderRadius.zero)),
                            // splashFactory: InkSplash.splashFactory,
                            splashFactory: InkSparkle.splashFactory,
                            overlayColor: MaterialStatePropertyAll(Color(
                                0x4d5800ff)),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.delete_forever,color: Colors.white,),
                            title: Text('Delete profile image',style: GoogleFonts.dmSans(
                                color: Colors.white
                            ),),
                          ),
                        )
                      ],
                    );
                  });
            },
            child: DottedBorder(
              padding: const EdgeInsets.all(6),
              color: const Color(0xff5800FF),
              borderType: BorderType.Circle,
              dashPattern: const [5,5],
              strokeCap: StrokeCap.round,
              strokeWidth: 2,
              child: Center(
                  child:_imgUrl=='' ?
                  CircleAvatar(
                      radius:40.r,
                      child:ClipRRect(
                        borderRadius:BorderRadius.circular(40.r),
                        child:imageFile==null
                            ?const Icon(Icons.camera_alt_outlined,size:40,color:Colors.white,)
                            :Image.file(imageFile!,fit:BoxFit.cover),
                      )
                  ) :
                  CircleAvatar(
                      radius:40.r,
                      child:ClipRRect(
                        borderRadius:BorderRadius.circular(40.r),
                        child:imageFile==null?
                        Image.network(_imgUrl.toString(),fit:BoxFit.cover)
                            :Image.file(imageFile!,fit:BoxFit.cover),
                      )
                  )
              ),
            ),
          ),
          SizedBox(height: 20.h,),
          Form(
            key: _editDataFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Email
                Text(
                  'Your Email Account',
                  style: GoogleFonts.dmSans(
                      color: Colors.white, fontSize: 14.sp),
                ),
                SizedBox(
                  height: 8.h,
                ),
                TextFormField(
                  enabled: false,
                  textInputAction: TextInputAction.next,
                  // onEditingComplete: () =>
                  //     FocusScope.of(context).requestFocus(_passFocusNode),
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailTextControler,
                  style: const TextStyle(color: Colors.grey),
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(15),
                    filled: true,
                    fillColor: Color(0xff282837),
                    hintText: 'Usermail@gmail.com',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(
                      Icons.mail_outline_sharp,
                      size: 20,
                      color: Colors.grey,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff5800FF),
                        )),
                    enabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                        )),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        )),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                // Phone
                Text(
                  'Phone',
                  style: GoogleFonts.dmSans(
                      color: Colors.white, fontSize: 14.sp),
                ),
                SizedBox(
                  height: 8.h,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  // focusNode: _passFocusNode,
                  keyboardType: TextInputType.phone,
                  controller: _phoneTextControler,
                  //Change it dynamically
                  validator:(value){
                    if(value==null){
                      return ;
                    }
                    return ;
                  },
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(15),
                    filled: true,
                    fillColor: Color(0xff282837),
                    hintText: '+62821 - 3948 - 9384',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    prefixIcon: Icon(
                      Icons.phone_android_outlined,
                      size: 20,
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
                SizedBox(
                  height: 20.h,
                ),
                // Gender
                Text(
                  'Gender',
                  style: GoogleFonts.dmSans(
                      color: Colors.white, fontSize: 14.sp),
                ),
                SizedBox(
                  height: 8.h,
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, PageTransition(child: const GenderScreen(),
                        type: PageTransitionType.rightToLeft));
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xff282837),
                          borderRadius: BorderRadius.circular(4.r)
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.person,color: Colors.grey,),
                        title: Text('$_gndr',style: GoogleFonts.dmSans(
                            color: Colors.white
                        ),),
                      )
                  ),
                ),


              ],
            ),
          ),
          SizedBox(height: 200.h),
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
                  uploadProfileData();
                },
                child: _isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : Text(
                  'Save Change',
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
