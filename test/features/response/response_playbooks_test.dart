import 'package:flutter_test/flutter_test.dart';
import 'package:orvika/features/response/domain/response_playbooks.dart';

void main() {
  test('response playbooks have unique identifiers and actionable content', () {
    const playbooks = ResponsePlaybooks.playbooks;
    expect(playbooks, hasLength(5));
    expect(playbooks.map((item) => item.id).toSet().length, playbooks.length);

    for (final playbook in playbooks) {
      expect(playbook.title, isNotEmpty);
      expect(playbook.summary, isNotEmpty);
      expect(playbook.firstAction, isNotEmpty);
      expect(playbook.steps, isNotEmpty);
      expect(playbook.preserve, isNotEmpty);
      expect(playbook.avoid, isNotEmpty);
      expect(playbook.limit, isNotEmpty);
    }
  });

  test('playbooks cover the planned incident scenarios', () {
    expect(
      ResponsePlaybooks.playbooks.map((item) => item.scenario).toSet(),
      equals(ResponseScenario.values.toSet()),
    );
  });

  test('lookup returns a matching playbook and null for an unknown id', () {
    expect(ResponsePlaybooks.byId('payment-fraud')?.scenario,
        ResponseScenario.paymentFraud);
    expect(ResponsePlaybooks.byId('unknown'), isNull);
  });

  test('guidance avoids claiming that ORVIKA detects or remediates incidents', () {
    for (final playbook in ResponsePlaybooks.playbooks) {
      expect(playbook.limit.toLowerCase(), isNot(contains('automatically')));
    }
  });
}
