import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _editDataFormKey = GlobalKey<FormState>();
  // final FocusNode _passFocusNode = FocusNode();
  final TextEditingController _emailTextControler =
  TextEditingController(text: '');
  final TextEditingController _phoneTextControler =
  TextEditingController(text: '');
  final TextEditingController _genderTextControler =
  TextEditingController(text: '');
  final bool _isLoading=false;
  File? imageFile;

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
    if(croppedImage!=null){
      setState(() {
        imageFile=File(croppedImage.path);
      });
    }
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
                  backgroundColor: Color(0xff1D1D2F),
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
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Color(0xff1D1D2F)),
                            padding: MaterialStatePropertyAll(EdgeInsets.zero),
                            shape: MaterialStatePropertyAll(BeveledRectangleBorder(borderRadius: BorderRadius.zero)),
                            // splashFactory: InkSplash.splashFactory,
                            splashFactory: InkSparkle.splashFactory,
                            overlayColor: const MaterialStatePropertyAll(Color(
                                0x4d5800ff)),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.camera_alt,color: Colors.white,),
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
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Color(0xff1D1D2F)),
                            padding: MaterialStatePropertyAll(EdgeInsets.zero),
                            shape: MaterialStatePropertyAll(BeveledRectangleBorder(borderRadius: BorderRadius.zero)),
                            // splashFactory: InkSplash.splashFactory,
                            splashFactory: InkSparkle.splashFactory,
                            overlayColor: const MaterialStatePropertyAll(Color(
                                0x4d5800ff)),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.photo_library,color: Colors.white,),
                            title: Text('Select profile picture',style: GoogleFonts.dmSans(
                                color: Colors.white
                            ),),
                          ),
                        ),
                        imageFile==null
                            ? ElevatedButton(
                          onPressed:(){},
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Color(0xff1D1D2F)),
                            padding: MaterialStatePropertyAll(EdgeInsets.zero),
                            shape: MaterialStatePropertyAll(BeveledRectangleBorder(borderRadius: BorderRadius.zero)),
                            // splashFactory: InkSplash.splashFactory,
                            splashFactory: InkSparkle.splashFactory,
                            overlayColor: const MaterialStatePropertyAll(Color(
                                0x4d5800ff)),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.delete_forever,color: Colors.grey,),
                            title: Text('Delete profile image',style: GoogleFonts.dmSans(
                                color: Colors.grey
                            ),),
                          ),
                        )
                            : ElevatedButton(
                          onPressed: (){
                            setState(() {
                              imageFile=null;
                            });
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Color(0xff1D1D2F)),
                            padding: MaterialStatePropertyAll(EdgeInsets.zero),
                            shape: MaterialStatePropertyAll(BeveledRectangleBorder(borderRadius: BorderRadius.zero)),
                            // splashFactory: InkSplash.splashFactory,
                            splashFactory: InkSparkle.splashFactory,
                            overlayColor: const MaterialStatePropertyAll(Color(
                                0x4d5800ff)),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.delete_forever,color: Colors.white,),
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
                child: CircleAvatar(
                    radius: 40.r,
                    child:ClipRRect(
                      borderRadius: BorderRadius.circular(40.r),
                      child:imageFile==null
                          ?Icon(Icons.camera_alt_outlined,size:40,color:Colors.white,)
                          :Image.file(imageFile!,fit:BoxFit.cover),
                    )
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h,),
          Form(
            key: _editDataFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Email Account',
                  style: GoogleFonts.dmSans(
                      color: Colors.white, fontSize: 14.sp),
                ),
                SizedBox(
                  height: 8.h,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  // onEditingComplete: () =>
                  //     FocusScope.of(context).requestFocus(_passFocusNode),
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailTextControler,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email should not be empty!';
                    } else if (!value.contains('@')) {
                      return 'Please enter a valid email!';
                    } else {
                      return null;
                    }
                  },
                  style: const TextStyle(color: Colors.white),
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password should not be empty!';
                    }else {
                      return null;
                    }
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
                Text(
                  'Gender',
                  style: GoogleFonts.dmSans(
                      color: Colors.white, fontSize: 14.sp),
                ),
                SizedBox(
                  height: 8.h,
                ),
                TextFormField(
                  textInputAction: TextInputAction.done,
                  // focusNode: _passFocusNode,
                  keyboardType: TextInputType.text,
                  controller: _genderTextControler,
                  //Change it dynamically
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password should not be empty!';
                    } else if (value.length < 8) {
                      return 'Password Should be at least 8 Characters';
                    } else {
                      return null;
                    }
                  },
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(15),
                    filled: true,
                    fillColor: Color(0xff282837),
                    hintText: 'Male',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    prefixIcon: Icon(
                      Icons.male_outlined,
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
                onPressed: (){},
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
