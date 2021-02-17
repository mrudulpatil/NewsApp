import 'package:cached_network_image/cached_network_image.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:news_app/common/news_api.dart';
import 'package:news_app/common/secret.dart';
import 'package:news_app/common_widgets/text_form_widget.dart';
import 'package:news_app/common_widgets/widgets.dart';
import 'package:news_app/models/category_model.dart';
import 'package:news_app/common/data.dart';



import 'query_news.dart';
import 'category_news.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading;
  var newslist;
  TextEditingController searchController = TextEditingController();
  List<CategorieModel> categories = List<CategorieModel>();
  final FocusNode _searchControllerFocus = FocusNode();
  void getNews() async {
    News news = News();
    await news.getNews();
    newslist = news.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    _loading = true;
    // TODO: implement initState
    super.initState();

    categories = getCategories();
    getNews();
  }

  Widget _buildSearch() {
    return TextFormFieldWidget(
      hintText: "Search",
      textInputType: TextInputType.text,
      actionKeyboard: TextInputAction.send,
      functionValidate: commonValidation,
      controller: searchController,
      focusNode: _searchControllerFocus,
      onSubmitField:()  {
        // Use this method to change cursor focus
        // First param - Current Controller
        // Second param - The Controller you want to focus on the next button press
       // changeFocus(context, editingController, _passwordControllerFocus);
        query=searchController.text;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QueryNews(
                  newsQuery: query.toLowerCase(),
                )));
      },
      parametersValidate: "Please enter keywords.",
      prefixIcon: Icon(
          Icons.search), // Don't pass image in case of no prefix Icon
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SafeArea(

          child: _loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:_buildSearch()
                          // TextFormFieldWidget(
                          //
                          //
                          //   onSubmitField: (value)
                          //   {
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => QueryNews(
                          //               newsQuery: value.toLowerCase(),
                          //             )));
                          //   },
                          //   controller: editingController,
                          //   // decoration: InputDecoration(
                          //   //   //focusColor: Colors.black,
                          //   //     labelText: "Search",
                          //   //     hintText: "Search",
                          //   //     prefixIcon: Icon(Icons.search),
                          //   //
                          //   //   // enabledBorder: UnderlineInputBorder(
                          //   //   //   borderSide: BorderSide(color: Colors.cyan),
                          //   //   // ),
                          //   //   // focusedBorder: UnderlineInputBorder(
                          //   //   //   borderSide: BorderSide(color: Colors.cyan),
                          //   //   // ),
                          //   //   // border: OutlineInputBorder(
                          //   //     //     borderSide: const BorderSide(color: Colors.black, width: 2.0),
                          //   //     //     borderRadius: BorderRadius.all(Radius.circular(25.0)))
                          //   //
                          //   // ),
                          // ),
                        ),
                        ),
                        /// Categories
                        ///
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 70,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                return CategoryCard(
                                  imageAssetUrl:
                                      categories[index].imageAssetUrl,
                                  categoryName: categories[index].categorieName,
                                );
                              }),
                        ),

                        /// News Article
                        Container(
                          margin: EdgeInsets.only(top: 16),
                          child: ListView.builder(
                              itemCount: newslist.length,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return NewsTile(
                                  imgUrl: newslist[index].urlToImage ?? "",
                                  title: newslist[index].title ?? "",
                                  desc: newslist[index].description ?? "",
                                  content: newslist[index].content ?? "",
                                  posturl: newslist[index].articleUrl ?? "",
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
        ),


    );
  }
}

class CategoryCard extends StatelessWidget {
  final String imageAssetUrl, categoryName;

  CategoryCard({this.imageAssetUrl, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryNews(
                      newsCategory: categoryName.toLowerCase(),
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 14),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                imageUrl: imageAssetUrl,
                height: 60,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 60,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black26),
              child: Text(
                categoryName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}
