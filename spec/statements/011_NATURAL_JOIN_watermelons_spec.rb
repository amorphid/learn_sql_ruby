RSpec.describe LearnSQL do
  before do
    LearnSQL.query(%q{
      CREATE TABLE watermelons (
        id SERIAL,
        variety CHARACTER VARYING,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      CREATE TABLE genes (
        id SERIAL,
        watermelon_id INT,
        trait CHARACTER VARYING,
        sequence CHARACTER VARYING,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      INSERT INTO watermelons (variety)
      VALUES ('Carolina Cross'),
             ('Golden Midget'),
             ('Orangeglo');
    })
    LearnSQL.query(%q{
      INSERT INTO genes (watermelon_id,trait,sequence)
      VALUES (1,'Red Flesh','ACAAGATG'),
             (2,'Pink Flesh','ACAAGATG'),
             (3,'Orange Flesh','CCTATGTC');
    })
  end

  after do
    LearnSQL.query("DROP TABLE watermelons;")
    LearnSQL.query("DROP TABLE genes;")
  end

  describe "NATURAL JOIN" do
    it "watermelons and genes" do
      actual = LearnSQL.query(%q{
        SELECT *
        FROM watermelons
        NATURAL JOIN genes
        ORDER BY watermelons.id;
      })
      expected = [
        # watermelons.id,watermelons.variety,genes.watermelon_id,
        #   watermelons.trait,watermelons.sequence
        [1, "Carolina Cross", 1, "Red Flesh", "ACAAGATG"],
        [2, "Golden Midget", 2, "Pink Flesh", "ACAAGATG"],
        [3, "Orangeglo", 3, "Orange Flesh", "CCTATGTC"]
      ]
      expect(actual).to eq(expected)
    end
  end
end
