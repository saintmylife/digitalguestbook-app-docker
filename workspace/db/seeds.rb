# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Setting.create([
    {
        no_undian: false,
        nama_meja: false,
        nama_undangan: false,
        nama_angpao: false,
        jumlah_souvenir: false,
        jumlah_undangan: false,
        count_person: false,
    }
])

TypeOfEvent.create([
    {name: 'Weddings'},
    {name: 'Concert'},
    {name: 'Gatherings'},
    {name: 'Moving'},
])

Event.create([
    {
        name: 'Dummy Event',
        date: Date.current().to_formatted_s(:iso8601),
        event_owner: 'Dummy Event Owner',
        status: true,
        type_of_event_id: 1,
        code: 'DE'
    }
])