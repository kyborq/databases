const { MongoClient, ObjectId } = require("mongodb");

const url = "mongodb://127.0.0.1:27017";
const config = {
  useNewUrlParser: true,
  useUnifiedTopology: true,
};

MongoClient.connect(url, config, (err, client) => {
  if (err) {
    return console.log(err);
  }

  const db = client.db("bookshop");

  const author = db.collection("author");
  const books = db.collection("books");
  const order = db.collection("order");
  const publishing = db.collection("publishing");
  const shop = db.collection("shop");

  // 3.2 вставка записи
  // вставка одной записи insertOne
  db.shop.insertOne({
    name: "BookShop",
    address: "Улица Пушкина, дом Колотушкина",
    url: "https://google.com/",
    phone: "8(800)555-35-35",
  });

  // вставка нескольких записей insertMany
  db.publishing.insertMany([
    {
      name: "ТопИздат",
      emails: ["topizdat@mail.ru", "hehezdat@mail.ru", "izdevatelstvo@mail.ru"],
      closed: false,
    },
    {
      name: "Не издательство",
      emails: ["neizdat@mail.ru", "noizdat@mail.ru"],
    },
  ]);

  db.author.insertMany([
    {
      firstName: "Иван",
      lastName: "Иванов",
      parentName: "Иванович",
      birthdate: "2000-11-05",
      city: "Москва",
    },
    {
      firstName: "Андрей",
      lastName: "Колотушкин",
      parentName: "Александрович",
      birthdate: "1999-02-25",
      city: "Йошкар-Ола",
    },
    {
      firstName: "Потап",
      lastName: "Благородный",
      parentName: "Маркович",
      birthdate: "1800-02-25",
      city: "Йошкар-Ола",
    },
    {
      firstName: "Алексей",
      lastName: "Клифонов",
      parentName: "Нурфсисович",
      birthdate: "1980-07-12",
      city: "Йошкар-Ола",
    },
    {
      firstName: "Олег",
      lastName: "Эшпепов",
      parentName: "Керимович",
      birthdate: "1980-07-12",
      city: "Йошкар-Ола",
    },
  ]);

  db.books.insertMany([
    {
      title: "Книга",
      released: {
        year: "2022",
        city: "Moscow",
      },
    },
    {
      title: "Книга",
      released: {
        year: "2019",
        city: "Moscow",
      },
    },
  ]);

  // 3.3 удаление записей
  // удаление одной записи по условию deleteOne
  db.author.deleteOne({ firstName: "Андрей", lastName: "Колотушкин" });

  // удаление нескольких записей по условию deleteMany
  db.author.deleteMany([
    {
      firstName: "Олег",
      lastName: "Эшпепов",
    },
    {
      firstName: "Алексей",
      lastName: "Клифонов",
    },
  ]);

  // 3.4 поиск записей
  // поиск по ID
  db.author.find({ _id: ObjectId("627e4d207f895d0b526ef42c") });

  // поиск записи по атрибуту первого уровня
  db.shop.find({ name: "BookShop" });

  // поиск записи по вложенному атрибуту
  db.books.find({ "released.year": "2022" });

  // Поиск записи по нескольким атрибутам (логический оператор AND)
  db.books.find({ "released.year": "2022", "released.city": "Moscow" });
  // или же
  db.books.find({
    $and: [{ "released.year": "2022" }, { "released.city": "Moscow" }],
  });

  // Поиск записи по одному из условий (логический оператор OR)
  db.books.find({
    $or: [{ "released.year": "2022" }, { "released.year": "2019" }],
  });

  // Поиск с использованием оператора сравнения
  db.books.find({
    released: {
      year: {
        $gt: "2018",
      },
    },
  });

  // Поиск с использованием двух операторов сравнения
  db.books.find({
    released: {
      year: {
        $gt: "2018",
        $lt: "2020",
      },
    },
  });

  // Поиск по значению в массиве
  db.publishing.find({
    emails: "topizdat@mail.ru",
  });
  db.publishing.find({
    emails: { $in: ["topizdat@mail.ru"] },
  });

  // Поиск по количеству элементов в массиве
  db.publishing.find({
    emails: { $size: 3 },
  });

  // Поиск записей без атрибута
  db.publishing.find({
    closed: null,
  });

  // 3.5 Обновление записей
  // Изменить значение атрибута у записи
  db.publishing.updateOne({ name: "ТопИздат" }, { $set: { closed: true } });

  // Удалить атрибуту записи
  db.publishing.updateOne({ name: "ТопИздат" }, { $unset: { closed: true } });

  // Добавить атрибут записи
  db.publishing.updateOne(
    { name: "ТопИздат" },
    { $set: { address: "Улица пушкина дом колотушкина" } }
  );
});
