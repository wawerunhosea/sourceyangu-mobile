//  
// camera_display: Camera => camera_display: ImagePickerDialog
// Widgets => 
// camera_display:ImagePickerDialog => camera_display:_handleImageFlow 
// _handleImageFlow: > camera capture ? pick from gallery
// _handleImageFlow => image_handler: imageCropper
//_handleImageFlow =>  image_handler: compressToWebP

//  _handleImageFlow: Get.back(result: compressed); this result is given to ImagePickerDialog
// ImagePickerDialog returns imageBytes to camera via final imageBytes = await Get.dialog(ImagePickerDialog());
// camera returns imageBytes to 

// widgetslayer2: WebPPreviewScreen => interim_widgets, widget: UploadProgressOverlay
// image upload done by interim widget controller: final result = await uploadWebPImage(imageBytes);
// hosted in IMAGESEARCH PAGE, it gets its props passed when being called