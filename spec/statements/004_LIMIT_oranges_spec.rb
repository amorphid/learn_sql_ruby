RSpec.describe "LIMIT" do
  before do
    LearnSQL.query(%q{
      CREATE TABLE oranges (
        id serial,
        has_seeds bool,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      INSERT INTO oranges (has_seeds)
      VALUES (true),
             (true),
             (false),
             (false),
             (true);
    })
  end

  after do
    LearnSQL.query("DROP TABLE oranges;")
  end

  it "2 rows" do
    actual = LearnSQL.query(%q{
      SELECT *
      FROM oranges
      LIMIT 2;
    })
    expected = [
      # id,has_seeds
      [1,true],
      [2,true],
    ]
    expect(actual).to eq(expected)
  end

  it "3 rows" do
    actual = LearnSQL.query(%q{
      SELECT *
      FROM oranges
      LIMIT 3
      OFFSET 2;
    })
    expected = [
      # id,has_seeds
      [3,false],
      [4,false],
      [5,true],
    ]
    expect(actual).to eq(expected)
  end
end
