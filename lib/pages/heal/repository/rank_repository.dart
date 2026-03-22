import 'package:fe/pages/heal/models/rank_model.dart';

class UserRankRepository {
  final List<Map<String, dynamic>> _mockUserRankMaps = [
    {
        "id": "a5dfe76b-479c-4999-9daa-bdd712688833",
        "username": "yuuka",
        "first_name": "Yuukat",
        "last_name": "Kawai",
        "gender": "female",
        "birthdate": "2001-04-19",
        "phone": "0812345678",
        "email": "yuuka12@example.com",
        "image_url": "https://storage.googleapis.com/growth-journal-images/images/effc2c32-bda3-49c2-acba-573990fa5d3e-scaled_1000013428.jpg",
        "level": 5,
        "points": 8,
        "ranking": 1,
        "updated_at": "2026-03-22T06:51:51.278331Z"
    },
    {
        "id": "51144a7a-e7cf-4580-a95c-f024b2f62ded",
        "username": "admin",
        "first_name": "Admin",
        "last_name": "Admin",
        "gender": "female",
        "birthdate": "2000-01-01",
        "phone": "1234567890",
        "email": "nuttanicha.ka@ku.th",
        "level": 5,
        "points": 8,
        "ranking": 1,
        "updated_at": "2026-03-22T07:23:58Z"
    },
    {
        "id": "4c7d4ac4-9e4b-49e3-a527-2b11f63454b3",
        "username": "yuuka_2",
        "first_name": "Yuukate",
        "last_name": "Kawai",
        "gender": "female",
        "birthdate": "2006-01-01",
        "phone": "0812345678",
        "email": "yuuka2@example.com",
        "image_url": "https://storage.googleapis.com/growth-journal-images/images/47981da1-c31b-4c78-81bb-3a0159e5e0e8-scaled_0a37d2e2a264540e5090c85a11c4afb5.jpg",
        "level": 2,
        "points": 36,
        "ranking": 2,
        "updated_at": "2026-03-21T00:00:00Z"
    },
    {
        "id": "efb7653a-d7f5-43ef-b255-696b237bc519",
        "username": "test",
        "first_name": "test",
        "last_name": "test",
        "gender": "female",
        "birthdate": "2003-01-23",
        "phone": "9874563220",
        "email": "nut.nutta2327@gmail.com",
        "level": 1,
        "points": 8,
        "ranking": 3,
        "updated_at": "2026-03-22T06:51:51.278331Z"
    },
    {
        "id": "e8122532-09ec-4701-b693-66336ef6ae60",
        "username": "NuttaNut",
        "first_name": "Nuttanicha",
        "last_name": "Kaeopholsri",
        "gender": "female",
        "birthdate": "2003-11-23",
        "phone": "1234567890",
        "email": "nuttanicha.kaeo@gmail.com",
        "image_url": "https://storage.googleapis.com/growth-journal-images/images/414cee5e-80dc-43c9-992d-a54f883a561e-scaled_1000008824.jpg",
        "level": 0,
        "points": 52,
        "ranking": 4,
        "updated_at": "2026-03-22T06:51:51.278331Z"
    },
    {
        "id": "f0d53a87-c0a5-4895-ac44-d3a07cead9d9",
        "username": "SunsuSunset",
        "first_name": "Sunsu",
        "last_name": "Sunset",
        "gender": "female",
        "birthdate": "2000-01-25",
        "phone": "0810987654",
        "email": "fresh2346@gmail.com",
        "level": 0,
        "points": 17,
        "ranking": 5,
        "updated_at": "2026-03-22T06:51:51.278331Z"
    },
    {
        "id": "d07671ea-53eb-442a-af88-07acf2aea615",
        "username": "yuuka_3",
        "first_name": "Yuuka",
        "last_name": "Kawai",
        "gender": "female",
        "birthdate": "2001-04-19",
        "phone": "0812345678",
        "email": "yuukaw3@example.com",
        "level": 0,
        "points": 0,
        "ranking": 6,
        "updated_at": null
    },
    {
        "id": "aaf4ab7f-5d10-437c-818d-188608389ade",
        "username": "yuuka_",
        "first_name": "Yuuka",
        "last_name": "Kawai",
        "gender": "female",
        "birthdate": "2001-04-19",
        "phone": "0812345678",
        "email": "yuuka1@example.com",
        "level": 0,
        "points": 0,
        "ranking": 6,
        "updated_at": null
    },
    {
        "id": "309b430f-2289-45f3-9c61-9ce933191d90",
        "username": "SunSet",
        "first_name": "Fresh",
        "last_name": "Nutta",
        "gender": "female",
        "birthdate": "2000-01-17",
        "phone": "1234567890",
        "email": "nutta.nut2327@gmail.com",
        "level": 0,
        "points": 0,
        "ranking": 6,
        "updated_at": null
    }
  ];

  Future<List<UserRank>> getAllUserRanks() async {
    await Future.delayed(const Duration(milliseconds: 500)); // จำลองโหลดจาก API
    return _mockUserRankMaps.map((e) => UserRank.fromMap(e)).toList();
  }
}
