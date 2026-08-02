import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/Material.dart';
import 'package:newf/core/extension/context.dart';
import 'package:newf/core/extension/double.dart';
import 'package:newf/core/theming/app_values.dart';

class DialougeChooseImage extends StatelessWidget {
  const DialougeChooseImage({super.key,required  this.chooseCameraData,required this.chooseGalleryData});
  final (String ,void Function()? )  chooseCameraData,chooseGalleryData;
  @override
  Widget build(BuildContext context) {
    return Dialog(

        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.s10)),
        alignment: Alignment.bottomCenter,
        insetPadding: const EdgeInsets.symmetric(vertical: AppSizes.s12, horizontal: AppSizes.s12),
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment:  .center,
             children: [
              5.verticalSpace,
              Padding(
                  padding: EdgeInsets.symmetric( vertical: 15 ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 1,
                          child:
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              border: .all(
                                 color:  context.theme.primaryColor
                              )
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                chooseCameraData .$2?.call();
                              },
                              style: ElevatedButton.styleFrom(
                                   padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: context.theme.scaffoldBackgroundColor
                              ),
                              child: Text(
                                chooseCameraData .$1  ,
                                style:   TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: context.theme.primaryColor
                                ),
                              ),
                            ),
                          )
                      ),
                      10.horizontalSpace,
                      Expanded(
                          flex: 1,
                          child:
                          ElevatedButton(
                            onPressed:   () {
                              Navigator.pop(context);
                              chooseGalleryData .$2?.call();
                            } ,
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: context.theme.primaryColor
                            ),
                            child: Text(
                                chooseGalleryData .$1 ,
                              style:   TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:  context.theme.scaffoldBackgroundColor
                              ),
                            ),
                          )
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    ),
        // child: ShowDialogChooseImageUser(
        //     onTapImageCamera: () async => await _pickImg(
        //       context,
        //       isSquareOnly: isSquareOnly,
        //       cropped: cropped,
        //       enableCompression: false,
        //       isGallery: false,
        //     ).then(filePicked),
        //     onTapImageGallery: () async => multiGallerySelect
        //         ? await _pickMultiImg(
        //       context,
        //       false,
        //     ).then((value) {
        //       if (multiFilePicked != null) {
        //         multiFilePicked(value);
        //       }
        //     })
        //         : _pickImg(
        //       context,
        //       isSquareOnly: isSquareOnly,
        //       cropped: cropped,
        //       enableCompression: false,
        //       isGallery: true,
        //     ).then((val) {
        //       StaticMethod.printDepug("file size :    ${val?.lengthSync()}");
        //       filePicked(val);
        //     }))
    );
  }
}
extension showDialougePick on DialougeChooseImage{
 void toShowDialougePick(BuildContext context)async=>await showDialog(
   context: context,
   builder: (context) => this,
 );
}