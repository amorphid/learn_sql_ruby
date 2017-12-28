RSpec.describe LearnSQL do
  before do
    LearnSQL.query(%q{
      CREATE TABLE mangos (
        id SERIAL,
        ripeness CHARACTER VARYING,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      INSERT INTO mangos (ripeness)
      VALUES ('unripe'),('unripe'),('unripe'),('unripe'),('unripe'),
             ('unripe'),('unripe'),('unripe'),('unripe'),('unripe'),
             ('ripe'),('ripe'),('ripe'),('ripe'),('ripe'),
             ('rotten'),('rotten'),('rotten'),('rotten'),('rotten'),
             ('rotten'),('rotten'),('rotten'),('rotten'),('rotten'),
             ('rotten'),('rotten'),('rotten'),('rotten'),('rotten');
    })
  end

  after do
    LearnSQL.query("DROP TABLE mangos;")
  end

  describe "HAVING" do
    it "more than 9 mangos in a ripeness group" do
      actual = LearnSQL.query(%q{
        SELECT ripeness,COUNT (id)
        FROM mangos
        GROUP BY ripeness
        HAVING COUNT (id) > 9
        ORDER BY count;
      })
      expected = [
        # ripeness,count
        ['unripe',10],
        ['rotten',15],
      ]
      expect(actual).to eq(expected)
    end
  end
end
