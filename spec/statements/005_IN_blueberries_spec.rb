RSpec.describe LearnSQL do
  before do
    LearnSQL.query(%q{
      CREATE TABLE blueberries (
        id serial,
        growing_area character varying,
        PRIMARY KEY (id)
      );
    })
    sql = %q{
      INSERT INTO blueberries (growing_area)
      VALUES ($1),
             ($2),
             ($3),
             ($4),
             ($2);
    }
    params = [
      "United States",
      "Canada",
      "Europe",
      "Southern Hemisphere"
    ]
    LearnSQL.query(sql,params)
  end

  after do
    LearnSQL.query("DROP TABLE blueberries;")
  end

  describe "IN" do
    it "North America" do
      actual = LearnSQL.query(%q{
        SELECT id,growing_area
        FROM blueberries
        WHERE growing_area IN ('Canada','United States')
        ORDER BY id;
      })
      expected = [
        # id,growing_area
        [1,"United States"],
        [2,"Canada"],
        [5,"Canada"],
      ]
      expect(actual).to eq(expected)
    end
  end

  describe "NOT IN" do
    it "North America" do
      actual = LearnSQL.query(%q{
        SELECT id,growing_area
        FROM blueberries
        WHERE growing_area NOT IN ('Canada','United States')
        ORDER BY id;
      })
      expected = [
        # id,growing_area
        [3,"Europe"],
        [4,"Southern Hemisphere"],
      ]
      expect(actual).to eq(expected)
    end
  end
end
