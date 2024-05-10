import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Home/other_view_profile.dart';
import 'Widgets/shimmer_jobcard.dart';


class SearchUser extends StatefulWidget {
  const SearchUser({super.key});

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  final TextEditingController _searchQueryController=TextEditingController();
  String searchQuery = 'Search query';
  void _clearSearchQuery(){
    setState(() {
      _searchQueryController.clear();
      _updateSearchQuery('');
    });
  }
  void _updateSearchQuery(String newQuery){
    setState(() {
      searchQuery=newQuery;
    });
  }

  Widget _buildSearchField(){
    return TextFormField(
      autocorrect: true,
      controller: _searchQueryController,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: (){
              _clearSearchQuery();
            },
            icon: const Icon(Icons.close,color: Colors.grey,),
          ),
          hintText: 'Search for users',
          border: InputBorder.none,
          hintStyle: GoogleFonts.dmSans(color: Colors.grey)
      ),
      style: Theme.of(context).textTheme.titleSmall,
      onChanged: (query)=>_updateSearchQuery(query),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).colorScheme.onSurface,
            statusBarIconBrightness: Theme.of(context).brightness
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        elevation: 0,
        title: _buildSearchField(),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .where('Name',isGreaterThanOrEqualTo: searchQuery.toLowerCase().toUpperCase())
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const ShimmerJobCard();
          }
          else if(snapshot.connectionState==ConnectionState.active){
            if(snapshot.data.docs.isNotEmpty==true){
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context,index){
                  return Card(
                    color:Theme.of(context).colorScheme.onPrimaryContainer,
                    child: InkWell(
                      splashFactory: InkRipple.splashFactory,
                      // splashColor: Color(0xff5800FF),
                      overlayColor: const MaterialStatePropertyAll(Color(
                          0x4d5800ff)),
                      onTap: (){
                            String id=snapshot.data!.docs[index]['Id'];
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>OthersViewProfileScreen(id: id)));
                            },
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left: 15.w),
                        leading:CircleAvatar(
                               radius: 22.r,
                               child: ClipRRect(
                               borderRadius: BorderRadius.circular(22.r),
                               child:snapshot.data.docs[index]['User Image']=="" ?
                                const Icon(Icons.error,size:25,color:Colors.red,) :
                               Image.network(snapshot.data.docs[index]['User Image']))),
                        title: Text(
                            '${snapshot.data.docs[index]['Name']}',
                            style: Theme.of(context).textTheme.headlineMedium),
                        subtitle: Text(
                          '${snapshot.data.docs[index]['About Me']}',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        trailing: Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            else{
              return Center(
                child: Text('There is no user',style: Theme.of(context).textTheme.labelMedium,),
              );
            }
          }
          return Center(
            child: Text('Something went wrong!',style: Theme.of(context).textTheme.labelMedium,),
          );
        },
      ),
    );
  }
}
