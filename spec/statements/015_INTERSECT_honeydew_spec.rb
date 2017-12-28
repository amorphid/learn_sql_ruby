RSpec.describe LearnSQL do
  before do
    LearnSQL.query(%q{
      CREATE TABLE honeydew (
        id SERIAL,
        shape CHARACTER VARYING,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      CREATE TABLE imitation_honeydew (
        id SERIAL,
        shape CHARACTER VARYING,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      INSERT INTO honeydew (shape)
      VALUES ('sorta round'),
             ('kinda round'),
             ('actually round'),
             ('basically a brick');
    })
    LearnSQL.query(%q{
      INSERT INTO imitation_honeydew (shape)
      VALUES ('actually round'),
             ('basically a brick'),
             ('not very melony'),
             ('battleship');
    })
  end

  after do
    LearnSQL.query("DROP TABLE honeydew;")
    LearnSQL.query("DROP TABLE imitation_honeydew;")
  end

  describe "INTERSECT" do
    it "honeydew shapes which are counterfeited" do
      actual = LearnSQL.query(%q{
        SELECT shape
        FROM honeydew
        INTERSECT
        SELECT shape
        FROM imitation_honeydew
        ORDER BY shape;
      })
      expected = [
        # shape
        ['actually round'],
        ['basically a brick'],
      ]
      expect(actual).to eq(expected)
    end
  end
end
