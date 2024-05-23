import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import '../Services/global_methods.dart';
import 'experience_screen.dart';

class UpdateExperienceScreen extends StatefulWidget {
  final String id;
  const UpdateExperienceScreen(this.id, {super.key});

  @override
  State<UpdateExperienceScreen> createState() => _UpdateExperienceScreenState();
}

class _UpdateExperienceScreenState extends State<UpdateExperienceScreen> {
  final _addExpFormKey = GlobalKey<FormState>();
  final TextEditingController _titletext = TextEditingController(text: '');
  final TextEditingController _companytext = TextEditingController(text: '');
  final TextEditingController _locationtext = TextEditingController(text: '');
  final TextEditingController _startDateController =
      TextEditingController(text: '');
  final TextEditingController _endDateController =
      TextEditingController(text: '');
  final TextEditingController _jobdescText = TextEditingController(text: '');
  bool _isLoading = false;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getExpData();
  }

  Future _getExpData() async {
    DocumentSnapshot ref = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Experience')
        .doc(widget.id)
        .get();
    setState(() {
      _titletext.text = ref.get('Title');
      _companytext.text = ref.get('Company Name');
      _locationtext.text = ref.get('Location');
      _startDateController.text = ref.get('Start Date');
      _endDateController.text = ref.get('End Date');
      _jobdescText.text = ref.get('Job Description');
    });
  }

  Future _updateExperienceData() async {
    final isValid = _addExpFormKey.currentState!.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .collection('Experience')
            .doc(widget.id)
            .update({
          'Title': _titletext.text,
          'Company Name': _companytext.text,
          'Location': _locationtext.text,
          'Start Date': _startDateController.text,
          'End Date': _endDateController.text,
          'Job Description': _jobdescText.text,
        });
        Future.delayed(const Duration(seconds: 1)).then((value) => {
              setState(() {
                _isLoading = false;
                Fluttertoast.showToast(
                    msg: 'Changes saved', toastLength: Toast.LENGTH_SHORT);
              })
            });
        Navigator.pop(context);
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
      }
    }
  }

  void _deleteExperienceData() {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Experience');
    ref.doc(widget.id).delete();
    Navigator.pushReplacement(
        context,
        PageTransition(
            child: const ExperienceScreen(),
            type: PageTransitionType.topToBottom));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).colorScheme.onSurface,
            statusBarIconBrightness: Theme.of(context).brightness),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        elevation: 0,
        centerTitle: true,
        title: Text('Edit Experience',
            style: Theme.of(context).textTheme.labelMedium),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _addExpFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text('Title',
                          style: Theme.of(context).textTheme.labelSmall),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        controller: _titletext,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter title!';
                          } else {
                            return null;
                          }
                        },
                        style: Theme.of(context).textTheme.titleSmall,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          contentPadding: const EdgeInsets.all(15),
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.onTertiaryContainer,
                          hintText: 'Ex: UI/UX Designer',
                          hintStyle: Theme.of(context).textTheme.bodySmall,
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide.none),
                          focusedErrorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.redAccent,
                          )),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Color(0xff5800FF),
                          )),
                          errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.redAccent,
                          )),
                        ),
                      ),
                      //Company Name
                      const SizedBox(
                        height: 20,
                      ),
                      Text('Company',
                          style: Theme.of(context).textTheme.labelSmall),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                        keyboardType: TextInputType.text,
                        controller: _companytext,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter company name!';
                          } else {
                            return null;
                          }
                        },
                        style: Theme.of(context).textTheme.titleSmall,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          contentPadding: const EdgeInsets.all(15),
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.onTertiaryContainer,
                          hintText: 'Ex: Microsoft',
                          hintStyle: Theme.of(context).textTheme.bodySmall,
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide.none),
                          focusedErrorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.redAccent,
                          )),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Color(0xff5800FF),
                          )),
                          errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.redAccent,
                          )),
                        ),
                      ),
                      //Location
                      const SizedBox(
                        height: 20,
                      ),
                      Text('Location',
                          style: Theme.of(context).textTheme.labelSmall),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                        keyboardType: TextInputType.text,
                        controller: _locationtext,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter location!';
                          } else {
                            return null;
                          }
                        },
                        style: Theme.of(context).textTheme.titleSmall,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          contentPadding: const EdgeInsets.all(15),
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.onTertiaryContainer,
                          hintText: 'Ex: London, United Kingdom',
                          hintStyle: Theme.of(context).textTheme.bodySmall,
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide.none),
                          focusedErrorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.redAccent,
                          )),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Color(0xff5800FF),
                          )),
                          errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.redAccent,
                          )),
                        ),
                      ),
                      //Start & End Date
                      const SizedBox(
                        height: 20,
                      ),
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Start Date',
                                  style:
                                      Theme.of(context).textTheme.labelSmall),
                              const SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                width: 175,
                                child: TextFormField(
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.none,
                                  style: Theme.of(context).textTheme.titleSmall,
                                  controller: _startDateController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Start date required!';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    isCollapsed: true,
                                    hintText: 'Select date',
                                    hintStyle:
                                        Theme.of(context).textTheme.bodySmall,
                                    contentPadding: const EdgeInsets.all(15),
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .onTertiaryContainer,
                                    suffixIcon: const Icon(
                                      Icons.date_range_outlined,
                                      color: Colors.grey,
                                    ),
                                    enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    focusedErrorBorder:
                                        const OutlineInputBorder(
                                            borderSide: BorderSide(
                                      color: Colors.redAccent,
                                    )),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Color(0xff5800FF),
                                    )),
                                    errorBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.redAccent,
                                    )),
                                  ),
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        builder: (context, child) => Theme(
                                              data: ThemeData().copyWith(
                                                  colorScheme:
                                                      ColorScheme.light(
                                                          background:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background)),
                                              child: child!,
                                            ),
                                        context: context,
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100));
                                    if (pickedDate != null) {
                                      setState(() {
                                        _startDateController.text =
                                            DateFormat('yMMMM')
                                                .format(pickedDate);
                                      });
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('End Date',
                                  style:
                                      Theme.of(context).textTheme.labelSmall),
                              const SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                width: 175,
                                child: TextFormField(
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.none,
                                  style: Theme.of(context).textTheme.titleSmall,
                                  controller: _endDateController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'End date required!';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    isCollapsed: true,
                                    hintText: 'Select date',
                                    hintStyle:
                                        Theme.of(context).textTheme.bodySmall,
                                    contentPadding: const EdgeInsets.all(15),
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .onTertiaryContainer,
                                    suffixIcon: const Icon(
                                      Icons.date_range_outlined,
                                      color: Colors.grey,
                                    ),
                                    enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    focusedErrorBorder:
                                        const OutlineInputBorder(
                                            borderSide: BorderSide(
                                      color: Colors.redAccent,
                                    )),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Color(0xff5800FF),
                                    )),
                                    errorBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.redAccent,
                                    )),
                                  ),
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        builder: (context, child) => Theme(
                                              data: ThemeData().copyWith(
                                                  colorScheme:
                                                      ColorScheme.light(
                                                          background:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background)),
                                              child: child!,
                                            ),
                                        context: context,
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100));
                                    if (pickedDate != null) {
                                      setState(() {
                                        _endDateController.text =
                                            DateFormat('yMMMM')
                                                .format(pickedDate);
                                      });
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      //Job Description
                      const SizedBox(
                        height: 20,
                      ),
                      Text('Job Description',
                          style: Theme.of(context).textTheme.labelSmall),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        maxLength: 150,
                        maxLines: 8,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        controller: _jobdescText,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter description!';
                          } else {
                            return null;
                          }
                        },
                        style: Theme.of(context).textTheme.titleSmall,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          contentPadding: const EdgeInsets.all(15),
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.onTertiaryContainer,
                          hintText: 'job description',
                          hintStyle: Theme.of(context).textTheme.bodySmall,
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide.none),
                          focusedErrorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.redAccent,
                          )),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Color(0xff5800FF),
                          )),
                          errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.redAccent,
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    style: ButtonStyle(
                        splashFactory: InkRipple.splashFactory,
                        overlayColor:
                            const MaterialStatePropertyAll(Color(0x4d5800ff)),
                        padding:
                            const MaterialStatePropertyAll(EdgeInsets.all(15)),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)))),
                    onPressed: () {
                      _deleteExperienceData();
                    },
                    child: Text('Delete Experience',
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 53,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff5800FF),
                          foregroundColor: Colors.black,
                          splashFactory: InkRipple.splashFactory,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onPressed: () {
                        _updateExperienceData();
                      },
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Save',
                              style: GoogleFonts.dmSans(
                                  color: Colors.white,
                                  fontSize: 16,
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
