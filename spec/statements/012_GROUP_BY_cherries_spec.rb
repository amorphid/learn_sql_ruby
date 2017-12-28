RSpec.describe "GROUP BY" do
  before do
    LearnSQL.query(%q{
      CREATE TABLE cherries (
        id SERIAL,
        cultivar CHARACTER VARYING,
        is_sweet BOOLEAN,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      INSERT INTO cherries (cultivar,is_sweet)
      VALUES ('Accolade',TRUE),
             ('Autumnalis',FALSE),
             ('Pandora',TRUE),
             ('Pendula Rosea',FALSE),
             ('Tibetan cherry',TRUE),
             ('Kiku-shidare-zakura',TRUE);
    })
  end

  after do
    LearnSQL.query("DROP TABLE cherries;")
  end

  it "is_sweet w/ count" do
    actual = LearnSQL.query(%q{
      SELECT is_sweet,COUNT (id) AS count
      FROM cherries
      GROUP BY is_sweet
      ORDER BY is_sweet DESC;
    })
    expected = [
      # is_sweet,count
      [true,4],
      [false,2],
    ]
    expect(actual).to eq(expected)
  end
end
