# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Business.create(
  name: 'OHSO',
  national: false,
  articles_attributes: [
    {
      url: 'https://www.azfamily.com/news/continuing_coverage/coronavirus_coverage/ohso-brewery-delivers-gallons-of-hand-sanitizer---in/article_165fea08-6ed8-11ea-9a47-f3fba573b251.html'
    }
  ],
  locations_attributes: [
    {
      name: 'Arcadia',
      address: '4900 E. Indian School Rd. Phoenix, AZ 85018'
    },
    {
      name: 'Gilbert',
      address: '335 N. Gilbert Rd. Suite 102 Gilbert, AZ 85234'
    }
  ]
)