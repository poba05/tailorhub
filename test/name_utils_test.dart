import 'package:flutter_test/flutter_test.dart';
import 'package:tailorhub/utils/name_utils.dart';

void main() {
  test('returns empty for blank names', () {
    expect(getInitials(''), isEmpty);
    expect(getInitials('   '), isEmpty);
  });

  test('returns first letter for a single-name entry', () {
    expect(getInitials('alice'), 'A');
  });

  test('returns first and last initials for a full name', () {
    expect(getInitials('Jane Doe'), 'JD');
    expect(getInitials('  jane    doe  '), 'JD');
  });
}
