class UselessFactsResponse {
  final String fact;

/*      api properties available. we just use text.
        let id: String
        let text: String
        let source: String
        let sourceUrl: String
        let language: String
        let permalink: String
*/

  UselessFactsResponse({required this.fact});

  factory UselessFactsResponse.fromJson(Map<String, dynamic> json) {
    final fact = json['text'];

    return UselessFactsResponse(fact: fact);
  }
}
