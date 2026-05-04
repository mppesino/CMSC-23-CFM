import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_sharing/component/buttons.dart';
import 'package:food_sharing/component/layouts.dart';
import 'package:food_sharing/component/sections.dart';
import 'package:food_sharing/theme/app_theme.dart';

class SearchPage extends StatefulWidget{
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>{
  final TextEditingController _searchController = TextEditingController();

  final List<String> _dietKeywords = ['Dairy-Free', 'Gluten-Free', 'Halal', 'Pescetarian', 'Vegan', 'Vegetarian', ]; //Dietary Restrictions


  final List<String> _foodCategoryKeywords = ['Beverage', 'Canned/Packaged', 'Grains', 'Proteins & Dairy', 'Raw Ingredients', 'Snacks'];  //Food Categories
  final Set<String> _selectedKeywords = {};

  @override
  void initState(){
    super.initState();
    _searchController.addListener(() => setState(() {}));   //listens when user inputs in the search bar, which updates UI accordingly 
  }

  void _toggleKeyword(String keyword){  //keywords can be toggled by user 
    setState(() {
      _selectedKeywords.contains(keyword)? _selectedKeywords.remove(keyword) : _selectedKeywords.add(keyword);
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      
      body: Column(

          children: [

              Container(
                width: double.infinity,
                color: BrandColors.mediumGreen,
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                child: _buildSearchBar()
              ),
              
             Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
          
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Column(
                    children: [
                      _buildSection('Dietary Restrictions', _dietKeywords),
                      _buildSection('Food Categories', _foodCategoryKeywords),
                    ],
                  ),
                ),
              ),
            ),

          ],

      )
    );
  }

  Widget _buildSearchBar() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: const Color.fromRGBO(59, 109, 17, 1)),
    ),

    child: Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        //selected keywords are added rounded rectangular bubbles:
        ..._selectedKeywords.map((tag) => Chip(
          label: Text(tag, style: const TextStyle(color: Colors.white, fontSize: 12)),
          backgroundColor: const Color.fromRGBO(59, 109, 17, 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onDeleted: () => _toggleKeyword(tag),
          deleteIconColor: Colors.white,
        )),

        //plain text input for keywords not in the list:
        IntrinsicWidth(
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(hintText: "Search...", border: InputBorder.none, isDense: true),
            style: const TextStyle(fontSize: 14),
          ),
        ),

      ],
    ),

  );
}

  Widget _buildSection(String title, List<String> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,

          //selected keywords are colored
          children: tags.map((tag) {
            final isSelected = _selectedKeywords.contains(tag);
            return GestureDetector(
              onTap: () => _toggleKeyword(tag),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? BrandColors.mediumGreen : Colors.transparent,
                  border: Border.all(color: BrandColors.mediumGreen),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(tag, style: TextStyle(
                  fontSize: 13, 
                  color: isSelected ? Colors.white : BrandColors.mediumGreen)
                ),
              ),
            );
          }).toList(),

        ),
        const SizedBox(height: 20),
      ],
    );
  }


}




