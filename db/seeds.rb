# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Event.delete_all
Item.delete_all
EventItem.delete_all
Seller.delete_all

s1 = Seller.create!(name: 'ほげ茶', password: 'password', password_confirmation: 'password')
s2 = Seller.create!(name: 'nullpo', password: 'password', password_confirmation: 'password')
s3 = Seller.create!(name: 'foo@tara', password: 'password', password_confirmation: 'password')
s4 = Seller.create!(name: '熱田盛子', password: 'password', password_confirmation: 'password')
s5 = Seller.create!(name: 'ぼんJIN', password: 'password', password_confirmation: 'password')
s6 = Seller.create!(name: 'CHRONICLE of Tears', password: 'password', password_confirmation: 'password')
s7 = Seller.create!(name: '暇人 THE future', password: 'password', password_confirmation: 'password')
s8 = Seller.create!(name: 'こっこ', password: 'password', password_confirmation: 'password')
s9 = Seller.create!(name: 'eバラ', password: 'password', password_confirmation: 'password')
s10 = Seller.create!(name: '洒蘭・Do', password: 'password', password_confirmation: 'password')

touhou = s1.events.create!(name: '東方紅楼夢(第13回)')
comcity = s1.events.create!(name: 'COMIC CITY 大阪112')
kurobasu = s4.events.create!(name: 'DC RETURNS 15')
onepeace = s4.events.create!(name: 'GRANDLINE CRUISE 10')
hrak = s8.events.create!(name: 'どうやら出番のようだ! 9')

# event_id:1-10
yugio = s8.events.create!(name: '俺のターン 3')
naruto = s4.events.create!(name: '全忍集結 8')
singeki = s8.events.create!(name: '第16回壁外調査博')
giasu = s2.events.create!(name: 'FULL CODE 5')
sutamyu = s3.events.create!(name: '星春★スターステップ 3')

tg1 = s1.items.create!(name: 'GENSOUM@STER')
tc1 = s2.items.create!(name: '東方魔烈槍')
zc1 = s3.items.create!(name: 'かいけつゾロリのたのしー！どうぶつえん')
kbc1 = s4.items.create!(name: '野生解放！火神くん！')
kbc2 = s5.items.create!(name: '城凛ドキドキクリスマス')
opc1 = s4.items.create!(name: '正義は勝つって!? そりゃそうだろ ドン勝だけが正義だ！')
opa1 = s6.items.create!(name: 'ハンコックモチーフポチ袋')
hrakc1 = s8.items.create!(name: 'それでもお前は俺の嫁（勝デク♀）')
hrakc2 = s9.items.create!(name: '1番の理解者（出勝）（全年齢）')
ygc1 = s7.items.create!(name: 'こんなドローはいやだ！（4コマ）')

# item_id: 1-17
yga1 = s10.items.create!(name: '赤遊イラストつきトートバッグ（ARC-V）')
nc1 = s4.items.create!(name: '曲げない欲求')
nc2 = s4.items.create!(name: '追憶の里')
na1 = s5.items.create!(name: 'ナルサス ポストカードセット')
sgc1 = s8.items.create!(name: '交差する剣（リヴァエレ）')
sgc2 = s3.items.create!(name: '巨人フレンズ（クロスオーバー）')
sgg1 = s1.items.create!(name: 'シンゲキブレイド ベータ版')

# event_item_id: 1-20
ttg1 = touhou.event_items.create!(price: 1400, item: tg1)
ttc1 = touhou.event_items.create!(price: 600, item: tc1)
ctc1 = comcity.event_items.create!(price: 800, item: tc1)
czc1 = comcity.event_items.create!(price: 100, item: zc1)
ckbc1 = comcity.event_items.create!(price: 200, item: kbc1)
chrakc2 = comcity.event_items.create!(price: 700, item: hrakc2)
kkbc1 = kurobasu.event_items.create!(price: 200, item: kbc1)
kkbc2 = kurobasu.event_items.create!(price: 800, item: kbc2)
oopc1 = onepeace.event_items.create!(price: 0, item: opc1)
oopa1 = onepeace.event_items.create!(price: 400, item: opa1)
hhrakc1 = hrak.event_items.create!(price: 800, item: hrakc1)
hhrakc2 = hrak.event_items.create!(price: 600, item: hrakc2)
yygc1  =yugio.event_items.create!(price: 300, item: ygc1)
yyga1 = yugio.event_items.create!(price: 600, item: yga1)
nnc1 = naruto.event_items.create!(price: 1400, item: nc1)
nnc2 = naruto.event_items.create!(price: 800, item: nc2)
nna1 = naruto.event_items.create!(price: 300, item:na1)
ssgc1 = singeki.event_items.create!(price: 100, item: sgc1)
ssgc2 = singeki.event_items.create!(price: 200, item: sgc2)
ssgg1 = singeki.event_items.create!(price: 2000, item: sgg1)

ttg1.logs.create!(diff_count: 100)
ttc1.logs.create!(diff_count: 20)
ctc1.logs.create!(diff_count: 30)
czc1.logs.create!(diff_count: 10)
ckbc1.logs.create!(diff_count: 0)
chrakc2.logs.create!(diff_count: 20)
kkbc1.logs.create!(diff_count: 11)
kkbc2.logs.create!(diff_count: 48)
oopc1.logs.create!(diff_count: 58)
oopa1.logs.create!(diff_count: 99)
hhrakc1.logs.create!(diff_count: 20000)
hhrakc2.logs.create!(diff_count: 247)
yygc1.logs.create!(diff_count: 111)
yyga1.logs.create!(diff_count: 91)
nnc1.logs.create!(diff_count: 4)
nnc2.logs.create!(diff_count: 590)
nna1.logs.create!(diff_count: 90)
ssgc1.logs.create!(diff_count: 517)
ssgc2.logs.create!(diff_count: 777)
ssgg1.logs.create!(diff_count: 24)
