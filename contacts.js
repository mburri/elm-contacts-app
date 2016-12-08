var faker = require('faker')

function generateContacts () {
  var contacts = [];

  for (var id = 0; id < 50; id++) {
    var firstName = faker.name.firstName()
    var lastName = faker.name.firstName()
    var phoneNumber = faker.phone.phoneNumberFormat()

    contacts.push({
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phoneNumber
    })
  }

  return { 'contacts': contacts }
}

module.exports = generateContacts
