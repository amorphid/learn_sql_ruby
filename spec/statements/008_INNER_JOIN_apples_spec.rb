RSpec.describe LearnSQL do
  before do
    LearnSQL.query(%q{
      CREATE TABLE apples (
        id SERIAL,
        variety CHARACTER VARYING,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      CREATE TABLE votes (
        id SERIAL,
        apple_id INT,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      INSERT INTO apples (variety)
      VALUES ('Gala'),
             ('Fuji'),
             ('McIntosh'),
             ('Cortland');
    })
    LearnSQL.query(%q{
      INSERT INTO votes (apple_id)
      VALUES ('2'),
             ('2'),
             ('3'),
             ('3'),
             ('3'),
             ('4');
    })
  end

  after do
    LearnSQL.query("DROP TABLE apples;")
    LearnSQL.query("DROP TABLE votes;")
  end

  describe "INNER JOIN" do
    it "apple votes" do
      actual = LearnSQL.query(%q{
        SELECT apples.id,votes.id,apples.variety
        FROM apples
        INNER JOIN votes
        ON apples.id = votes.apple_id
        ORDER BY apples.id,votes.id;
      })
      expected = [
        # apples.id,votes.id,apples.variety
        [2,1,"Fuji"],
        [2,2,"Fuji"],
        [3,3,"McIntosh"],
        [3,4,"McIntosh"],
        [3,5,"McIntosh"],
        [4,6,"Cortland"],
      ]
      expect(actual).to eq(expected)
    end

    it "apples varieties with votes" do
      actual = LearnSQL.query(%q{
        SELECT DISTINCT apples.variety
        FROM apples
        INNER JOIN votes
        ON apples.id = votes.apple_id
        ORDER BY apples.variety;
      })
      expected = [
        # apples.variety
        ["Cortland"],
        ["Fuji"],
        ["McIntosh"],
      ]
      expect(actual).to eq(expected)
    end
  end
end
