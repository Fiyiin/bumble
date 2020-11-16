import 'dart:ui';

import 'package:flutter_svg/svg.dart';

SvgPicture buildSvgIcon(String path, {int color}) {
  return SvgPicture.asset(
    'asset/images/$path.svg',
    color: color != null ? Color(color) : null,
  );
}
