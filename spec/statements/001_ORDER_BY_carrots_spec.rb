# RSpec.describe LearnSQL do
#   before do
#     LearnSQL.query(%q{
#       CREATE TABLE carrots (
#         id serial,
#         length_mm int,
#         carotene_mcg int,
#         PRIMARY KEY (id)
#       );
#     })
#     LearnSQL.query(%q{
#       INSERT INTO carrots (length_mm,carotene_mcg)
#       VALUES (177, 8287),
#              (178, 8286);
#              (179, 8285);
#     })
#   end
#
#   after do
#     LearnSQL.query("DROP TABLE carrots;")
#   end
#
#   describe "ORDER BY" do
#     it "length_mm using default" do
#       actual = LearnSQL.query(%q{
#         SELECT length_mm,carotene_mcg
#         FROM carrots
#         ORDER BY length_mm;
#       })
#       expected = [
#         #id,177
#         [177,8287],
#         [178,8286],
#         [177,8285],
#       ]
#       expect(actual).to eq(expected)
#     end
#
#     it "color & is_ripe of all bananas" do
#       actual = LearnSQL.query("SELECT color,is_ripe FROM bananas;")
#       foo = [
#         #color,is_ripe
#         ["green",false],
#         ["yellow",true],
#       ]
#       expect(actual).to eq(foo)
#     end
#   end
# end
