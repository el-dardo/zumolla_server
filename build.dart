import 'dart:io';
import 'package:stream/rspc.dart' as rspc;

void main() {
  rspc.build(new Options().arguments);/*, filenameMapper: (filePath) {
    print("===> $filePath");
    filePath = filePath.replaceAll("web/client/","web/webapp/");
    filePath = filePath.replaceAll(".rsp.html",".rsp.dart");
    return filePath;
  });
  */      
}

