import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../model/cart_model.dart';

class GroceryItemTile extends StatelessWidget {
  final String itemName;
  String itemPrice;
  final String imagePath;
  final color;
  bool textScanning = false;
  XFile? imageFile;
  String scannedText = "";
  String scannedPrice = "0";
  final currencyFormat = NumberFormat("#,##0.00", "en_US");

 
  void Function()? onPressed;

  GroceryItemTile({
    super.key,
    required this.itemName,
    required this.itemPrice,
    required this.imagePath,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final providerCartModel = Provider.of<CartModel>(context);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color[100],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // item image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Image.asset(
                imagePath,
                height: 40,
              ),
            ),

            // item name
            Text(
              itemName,
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.grey,
                  shadowColor: Colors.grey[400],
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                ),
                onPressed: () {
                  getImage(providerCartModel, ImageSource.camera);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 1,
                      ),
                      Text(
                        "Camera",
                        style: TextStyle(
                            fontSize: 7, color: Colors.grey[600]),
                      )
                    ],
                  ),
                ),
            )),

            /*MaterialButton(
              onPressed: onPressed,
              color: color,
              child: Text(
                'Add to Cart: \$' + itemPrice,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )*/
          ],
        ),
      ),
    );
  }

 void getImage(var providerCartModel, ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        final imageTemp = XFile(pickedImage.path);
        //setState(() => imageFile = imageTemp);
        getRecognisedText(providerCartModel, imageTemp);//pickedImage);
        //log(imageTemp.path);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
	  scannedText = "Error occured while scanning";
      //setState(() =>{});
    }
  }

  void getRecognisedText(var providerCartModel, XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
      }
    }

    final priceRegex = RegExp(r'[\$\£\€]*(\d+(?:\.\d{1,2})?)', multiLine: true);
    var priceString = priceRegex.allMatches(scannedText).map((m) => m.group(0));
    if(priceString.isNotEmpty){
      var price =  priceString.elementAt(0)!.replaceAll(RegExp(r'/(?:[$])\s*\d+(?:\.\d{2})?/'),'');
      var valPrice = price.replaceAll('\$', '');
      var p = double.parse(valPrice);
      itemPrice = valPrice;
      scannedPrice = valPrice;
      var index = (itemName == "Groceries") ? 0: 1; 
      providerCartModel.addItemToCart(index, scannedPrice);
      //productPrices.add(p);
      //total = total + p; 
    }
    textScanning = false;
    //setState(() {});
    //setState(() => {});
  }

  //@override
 // void initState() {
  //  super.initState();
 // }

}