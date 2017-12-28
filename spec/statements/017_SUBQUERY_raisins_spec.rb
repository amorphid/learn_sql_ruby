RSpec.describe "SUBQUERY" do
  before do
    LearnSQL.query(%q{
      CREATE TABLE raisins (
        id SERIAL,
        weight_g INT,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      INSERT INTO raisins (weight_g)
      VALUES (1),
             (2),
             (3),
             (3),
             (4);
    })
  end

  after do
    LearnSQL.query("DROP TABLE raisins;")
  end

  it "select raisins which weigh more than average" do
    actual = LearnSQL.query(%q{
      SELECT id,weight_g
      FROM raisins
      WHERE weight_g > (
        SELECT AVG(weight_g)
        FROM raisins
      );
    })
    expected = [
      # id,weight_g
      [3,3],
      [4,3],
      [5,4],
    ]
    expect(actual).to eq(expected)
  end
end
