import 'dart:convert';

const seedAuctionsJson = '''
[
  {
    "id": "a1",
    "title": "Vintage Murano Glass Vase",
    "category": "Decor",
    "desc": "Hand-blown Murano glass vase in emerald gradient with signature swirl base.",
    "media": [
      "assets/images/vase_emerald.png",
      "assets/images/vase_detail.png"
    ],
    "startPrice": 520.0,
    "minIncrement": 25.0,
    "reservePrice": 700.0,
    "currentBid": 640.0,
    "endAt": "2025-01-15T20:00:00.000Z",
    "location": "Dubai",
    "condition": "Mint",
    "status": "live",
    "ownerId": "u1"
  },
  {
    "id": "a2",
    "title": "Mid-Century Glass Chandelier",
    "category": "Lighting",
    "desc": "Italian brass + glass chandelier with cascading prism leaves, rewired and polished.",
    "media": [
      "assets/images/chandelier.png",
      "assets/images/chandelier_detail.png"
    ],
    "startPrice": 1200.0,
    "minIncrement": 50.0,
    "reservePrice": 1600.0,
    "currentBid": 1450.0,
    "endAt": "2025-01-20T18:30:00.000Z",
    "location": "Riyadh",
    "condition": "Excellent",
    "status": "live",
    "ownerId": "u2"
  },
  {
    "id": "a3",
    "title": "Art Deco Mirror Pair",
    "category": "Decor",
    "desc": "Pair of frameless Art Deco wall mirrors with bevelled edges, restored.",
    "media": [
      "assets/images/mirror.png"
    ],
    "startPrice": 320.0,
    "minIncrement": 20.0,
    "reservePrice": 450.0,
    "currentBid": 360.0,
    "endAt": "2025-01-18T15:00:00.000Z",
    "location": "Abu Dhabi",
    "condition": "Very Good",
    "status": "live",
    "ownerId": "u3"
  }
]
''';

const seedRequestsJson = '''
[
  {
    "id": "r1",
    "title": "Searching for smoked glass coffee table",
    "category": "Furniture",
    "specs": "Prefer oval or rounded rectangle top, brass legs, minor wear acceptable.",
    "budget": 800.0,
    "qty": 1,
    "deadline": "2025-02-01T00:00:00.000Z",
    "location": "Dubai",
    "condition": "Lightly Used",
    "priority": "High",
    "ownerId": "u4",
    "status": "live"
  },
  {
    "id": "r2",
    "title": "Pair of frosted pendant lamps",
    "category": "Lighting",
    "specs": "Need matching pair, diameter 30-35cm, matte brass hardware.",
    "budget": 1200.0,
    "qty": 2,
    "deadline": "2025-01-25T00:00:00.000Z",
    "location": "Doha",
    "condition": "New",
    "priority": "Medium",
    "ownerId": "u2",
    "status": "live"
  }
]
''';

const seedUsersJson = '''
[
  {
    "id": "u1",
    "name": "Laila",
    "avatar": "assets/images/avatar_laila.png",
    "rating": 4.8,
    "locale": "ar"
  },
  {
    "id": "u2",
    "name": "Omar",
    "avatar": "assets/images/avatar_omar.png",
    "rating": 4.6,
    "locale": "en"
  },
  {
    "id": "u3",
    "name": "Sara",
    "avatar": "assets/images/avatar_sara.png",
    "rating": 4.9,
    "locale": "ar"
  },
  {
    "id": "u4",
    "name": "Noor",
    "avatar": "assets/images/avatar_noor.png",
    "rating": 4.4,
    "locale": "en"
  }
]
''';

List<Map<String, dynamic>> decodeSeed(String json) {
  return List<Map<String, dynamic>>.from(jsonDecode(json) as List<dynamic>);
}
