// Padrão para descobrir capicuas

patternFind = function() {

    var phones = db.phones.find({}, {"display": 1, "_id": 0}).toArray();

    for (let i=0; i < phones.length; i++) {

        var phone = phones[i].display.split("-")[1];

        if (phone == phone.split("").reverse().join("")) {

            print(phone);

        }

    }

    print("Done!");

}