String numberFormat(double x) {
  List<String> parts = x.toString().split('.');
  RegExp re = RegExp(r'\B(?=(\d{3})+(?!\d))');

  parts[0] = parts[0].replaceAll(re, '.');
  if (parts.length == 1) {
    parts.add('00');
  } else {
    parts[1] = parts[1].padRight(2, '0').substring(0, 2);
  }
  return parts.join(',');
}

String simplyFormat({required DateTime time, bool dateOnly = false}) {
  String year = time.year.toString();

  // Add "0" on the left if month is from 1 to 9
  String month = time.month.toString().padLeft(2, '0');

  // Add "0" on the left if day is from 1 to 9
  String day = time.day.toString().padLeft(2, '0');

  // Add "0" on the left if hour is from 1 to 9
  String hour = time.hour.toString().padLeft(2, '0');

  // Add "0" on the left if minute is from 1 to 9
  String minute = time.minute.toString().padLeft(2, '0');

  // Add "0" on the left if second is from 1 to 9
  String second = time.second.toString();

  // If you only want year, month, and date
  if (dateOnly == false) {
    return "$year-$month-$day $hour:$minute:$second";
  }

  // return the "yyyy-MM-dd HH:mm:ss" format
  return "$year-$month-$day";
}

String obtenerMes(int mes) {
  switch (mes) {
    case 1:
      {
        return '01';
      }
      break;

    case 2:
      {
        return '02';
      }
      break;

    case 3:
      {
        return '03';
      }
      break;

    case 4:
      {
        return '04';
      }
      break;

    case 5:
      {
        return '05';
      }
      break;

    case 6:
      {
        return '06';
      }
      break;

    case 7:
      {
        return '07';
      }
      break;

    case 8:
      {
        return '08';
      }
      break;

    case 9:
      {
        return '09';
      }
      break;

    case 10:
      {
        return '10';
      }
      break;

    case 11:
      {
        return '11';
      }
      break;

    case 12:
      {
        return '12';
      }
      break;

    default:
      {
        return '0';
      }
      break;
  }
}
