import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../Services/global_methods.dart';
import '../presistent/presestent.dart';

class UpdateJobScreen extends StatefulWidget {
  final String jobid;
  const UpdateJobScreen({super.key, required this.jobid});

  @override
  State<UpdateJobScreen> createState() => _UpdateJobScreenState();
}

class _UpdateJobScreenState extends State<UpdateJobScreen> {
  final TextEditingController _jobcategorytext =
      TextEditingController(text: '');
  final TextEditingController _jobtitletext = TextEditingController(text: '');
  final TextEditingController _jobtypetext = TextEditingController(text: '');
  final TextEditingController _joblocationtext =
      TextEditingController(text: '');
  final TextEditingController _jobdescription = TextEditingController(text: '');
  final TextEditingController _jobsalarytext = TextEditingController(text: '');
  final TextEditingController _jobexperiencetext =
      TextEditingController(text: '');
  String dt = DateFormat('MMM d, y').format(DateTime.now());
  final _jobdataformkey = GlobalKey<FormState>();
  bool _isLoading = false;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String? userImage;
  String? userName;

  _showJobCategoryDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.background,
              title: Text(
                'Job Category',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: Presistent.jobCateegoryList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          setState(() {
                            _jobcategorytext.text =
                                Presistent.jobCateegoryList[index];
                          });
                          Navigator.pop(context);
                        },
                        child: Text(Presistent.jobCateegoryList[index],
                            style: Theme.of(context).textTheme.titleSmall));
                  },
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.grey,
                    thickness: 0.3,
                  ),
                ),
              ));
        });
  }

  _showJobTypeDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.background,
              title: Text(
                'Job Types',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: Presistent.jobTypeList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          setState(() {
                            _jobtypetext.text = Presistent.jobTypeList[index];
                          });
                          Navigator.pop(context);
                        },
                        child: Text(Presistent.jobTypeList[index],
                            style: Theme.of(context).textTheme.titleSmall));
                  },
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.grey,
                    thickness: 0.3,
                  ),
                ),
              ));
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getJobData();
  }

  Future _getJobData() async {
    DocumentSnapshot ref = await FirebaseFirestore.instance
        .collection('Jobs')
        .doc(widget.jobid)
        .get();
    setState(() {
      _jobtypetext.text = ref.get('JobType');
      _jobtitletext.text = ref.get('JobTitle');
      _jobsalarytext.text = ref.get('JobSalary');
      _joblocationtext.text = ref.get('JobLocation');
      _jobexperiencetext.text = ref.get('JobExperience');
      _jobdescription.text = ref.get('JobDescription');
      _jobcategorytext.text = ref.get('JobCategory');
    });
  }

  Future _updateJobData() async {
    final isValid = _jobdataformkey.currentState!.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        FirebaseFirestore.instance.collection('Jobs').doc(widget.jobid).update({
          'JobType': _jobtypetext.text,
          'JobTitle': _jobtitletext.text,
          'JobSalary': _jobsalarytext.text,
          'JobLocation': _joblocationtext.text,
          'JobExperience': _jobexperiencetext.text,
          'JobDescription': _jobdescription.text,
          'JobCategory': _jobcategorytext.text,
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

  void _deleteJobData() {
    FirebaseFirestore.instance.collection('Jobs').doc(widget.jobid).delete();
    Navigator.pop(context);
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
          title: Text('Edit Job Post',
              style: Theme.of(context).textTheme.labelMedium),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {
                  _deleteJobData();
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tell us who you're hiring",
                      style: Theme.of(context).textTheme.displayLarge),
                  const SizedBox(
                    height: 8,
                  ),
                  Text('Please enter few details below.',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: _jobdataformkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Job Category
                        Text('Job Category',
                            style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.none,
                          keyboardType: TextInputType.none,
                          readOnly: true,
                          controller: _jobcategorytext,
                          onTap: () {
                            _showJobCategoryDialog();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please select job category!';
                            } else {
                              return null;
                            }
                          },
                          style: Theme.of(context).textTheme.titleSmall,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.all(15),
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                            hintText: 'Select job Category',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            suffixIcon: const Icon(
                              Icons.arrow_drop_down,
                              size: 25,
                              color: Colors.grey,
                            ),
                            prefixIcon: const Icon(
                              Icons.category_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
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
                        //Job Title
                        const SizedBox(
                          height: 20,
                        ),
                        Text('Job Title',
                            style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                          keyboardType: TextInputType.text,
                          controller: _jobtitletext,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Job title should not be empty!';
                            } else {
                              return null;
                            }
                          },
                          style: Theme.of(context).textTheme.titleSmall,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.all(15),
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                            hintText: 'Enter job title',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            prefixIcon: const Icon(
                              Icons.title_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
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
                        //Job Type
                        const SizedBox(
                          height: 20,
                        ),
                        Text('Job Type',
                            style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.none,
                          keyboardType: TextInputType.none,
                          readOnly: true,
                          controller: _jobtypetext,
                          onTap: () {
                            _showJobTypeDialog();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Job Type should not be empty!';
                            } else {
                              return null;
                            }
                          },
                          style: Theme.of(context).textTheme.titleSmall,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.all(15),
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                            hintText: 'Enter job type',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            suffixIcon: const Icon(
                              Icons.arrow_drop_down,
                              size: 25,
                              color: Colors.grey,
                            ),
                            prefixIcon: const Icon(
                              Icons.title_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
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
                        //Job Experience
                        const SizedBox(
                          height: 20,
                        ),
                        Text('Required Experience',
                            style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                          keyboardType: TextInputType.number,
                          controller: _jobexperiencetext,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Experience should not be empty!';
                            } else {
                              return null;
                            }
                          },
                          style: Theme.of(context).textTheme.titleSmall,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.all(15),
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                            hintText: 'Experience Required',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            prefixIcon: const Icon(
                              Icons.title_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
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
                        //Job Salary
                        const SizedBox(
                          height: 20,
                        ),
                        Text('Job Salary',
                            style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                          keyboardType: TextInputType.text,
                          controller: _jobsalarytext,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Job Salary should not be empty!';
                            } else {
                              return null;
                            }
                          },
                          style: Theme.of(context).textTheme.titleSmall,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.all(15),
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                            hintText: 'Enter job Salary',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            prefixIcon: const Icon(
                              Icons.title_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
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
                        //Job Location
                        const SizedBox(
                          height: 20,
                        ),
                        Text('Job Location',
                            style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                          keyboardType: TextInputType.text,
                          controller: _joblocationtext,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Job location should not be empty!';
                            } else {
                              return null;
                            }
                          },
                          style: Theme.of(context).textTheme.titleSmall,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.all(15),
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                            hintText: 'Enter job location',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            prefixIcon: const Icon(
                              Icons.title_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
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
                          textInputAction: TextInputAction.none,
                          keyboardType: TextInputType.none,
                          controller: _jobdescription,
                          style: Theme.of(context).textTheme.titleSmall,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Job description should not be empty!';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            isCollapsed: true,
                            hintText: 'Enter Job Description',
                            hintStyle: Theme.of(context).textTheme.bodySmall,
                            contentPadding: const EdgeInsets.all(15),
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                            prefixIcon: const Icon(
                              Icons.description_outlined,
                              color: Colors.grey,
                            ),
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
                          onTap: () {
                            showModalBottomSheet(
                                backgroundColor:
                                    Theme.of(context).colorScheme.background,
                                context: context,
                                builder: (BuildContext context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          maxLines: 50,
                                          maxLength: 1000,
                                          textInputAction: TextInputAction.done,
                                          // onEditingComplete: ()=> FocusScope.of(context).requestFocus(_passFocusNode),
                                          keyboardType: TextInputType.text,
                                          controller: _jobdescription,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Job description should not be empty!';
                                            } else {
                                              return null;
                                            }
                                          },
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                          decoration: InputDecoration(
                                            isCollapsed: true,
                                            contentPadding:
                                                const EdgeInsets.all(15),
                                            filled: true,
                                            fillColor: Theme.of(context)
                                                .colorScheme
                                                .onTertiaryContainer,
                                            hintText: 'Enter job title',
                                            hintStyle: const TextStyle(
                                                color: Colors.grey),
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                                    borderSide:
                                                        BorderSide.none),
                                            focusedErrorBorder:
                                                const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                              color: Colors.redAccent,
                                            )),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                              color: Color(0xff5800FF),
                                            )),
                                            errorBorder:
                                                const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                              color: Colors.redAccent,
                                            )),
                                          ),
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
                                                splashFactory:
                                                    InkRipple.splashFactory,
                                                backgroundColor:
                                                    const Color(0xff5800FF),
                                                foregroundColor: Colors.black,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8))),
                                            onPressed: () {
                                              Navigator.pop(context);
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
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  );
                                });
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
                          _updateJobData();
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
        ));
  }
}
