import 'package:intl/intl.dart';
import 'package:leam/src/models/user/user_data_model.dart';


String getStatusText(UserDataModel user) {
  if (user.isOnline!) {
    return 'Online';
  } else if (user.lastSeen != null) {
    return 'Last seen ${formatLastSeen(user.lastSeen!)}';
  } else {
    return 'Offline';
  }
}

String formatLastSeen(DateTime lastSeen) {
  final now = DateTime.now();
  final difference = now.difference(lastSeen);

  if (difference.inSeconds < 60) {
    return 'just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h ago';
  } else if (difference.inDays == 1) {
    return 'yesterday at ${DateFormat('HH:mm').format(lastSeen)}';
  } else if (difference.inDays < 7) {
    return '${DateFormat('EEEE').format(lastSeen)} at ${DateFormat('HH:mm').format(lastSeen)}';
  } else {
    return 'on ${DateFormat('dd/MM/yyyy').format(lastSeen)}';
  }
}
