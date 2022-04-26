# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Setting.create(no_undian: false, nama_meja:true, nama_undangan:false, nama_angpao:true, jumlah_souvenir:false, jumlah_undangan:false, count_person:true)
typeEvent = ['Weddings','Concert','Gatherings','Moving']
typeEvent.each do |type|
    TypeOfEvent.create(name: type)
end
event = Event.create(name: 'Testing Event',event_owner: 'System',status: true,type_of_event_id: 1,code:'TST')
Guest.create({
    event_id:event.id,
    guest_id:'TSY0001',
    nama:'System Test',
    kategori:'Keluarga',
    jumlah_undangan: '2'
    })