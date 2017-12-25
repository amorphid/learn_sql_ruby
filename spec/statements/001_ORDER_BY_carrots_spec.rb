RSpec.describe LearnSQL do
  before do
    LearnSQL.query(%q{
      CREATE TABLE carrots (
        id serial,
        length_mm int,
        carotene_mcg int,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      INSERT INTO carrots (length_mm,carotene_mcg)
      VALUES (177,8286),
             (179,8287),
             (178,8285);
    })
  end

  after do
    LearnSQL.query("DROP TABLE carrots;")
  end

  describe "ORDER BY" do
    it "length_mm using default order" do
      actual = LearnSQL.query(%q{
        SELECT length_mm,carotene_mcg
        FROM carrots
        ORDER BY length_mm;
      })
      expected = [
        # length_mm,carotene_mcg
        [177,8286],
        [178,8285],
        [179,8287],
      ]
      expect(actual).to eq(expected)
    end

    it "length_mm ascending" do
      actual = LearnSQL.query(%q{
        SELECT length_mm,carotene_mcg
        FROM carrots
        ORDER BY length_mm ASC;
      })
      expected = [
        # length_mm,carotene_mcg
        [177,8286],
        [178,8285],
        [179,8287],
      ]
      expect(actual).to eq(expected)
    end

    it "length_mm descending" do
      actual = LearnSQL.query(%q{
        SELECT length_mm,carotene_mcg
        FROM carrots
        ORDER BY length_mm DESC;
      })
      expected = [
        # length_mm,carotene_mcg
        [179,8287],
        [178,8285],
        [177,8286],
      ]
      expect(actual).to eq(expected)
    end
  end
end
