RSpec.describe "CROSS JOIN" do
  before do
    LearnSQL.query(%q{
      CREATE TABLE grapes (
        id SERIAL,
        color CHARACTER VARYING,
        is_seedless BOOLEAN,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      CREATE TABLE skus (
        id SERIAL,
        size CHARACTER VARYING,
        price_cents INT,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      INSERT INTO grapes (color,is_seedless)
      VALUES ('green',TRUE),
             ('green',FALSE),
             ('purple',TRUE),
             ('purple',FALSE);
    })
    LearnSQL.query(%q{
      INSERT INTO skus (size,price_cents)
      VALUES ('S',199),
             ('L',399);
    })
  end

  after do
    LearnSQL.query("DROP TABLE grapes;")
    LearnSQL.query("DROP TABLE skus;")
  end

  it "All permutations of possible grape SKUs" do
    actual = LearnSQL.query(%q{
      SELECT grapes.color,grapes.is_seedless,skus.size,skus.price_cents
      FROM grapes
      CROSS JOIN skus
      ORDER BY grapes.id,skus.id;
    })
    expected = [
      # grapes.color,grapes.is_seedless,skus.size,skus.price_cents
      ["green",true,"S",199],
      ["green",true,"L",399],
      ["green",false,"S",199],
      ["green",false,"L",399],
      ["purple",true,"S",199],
      ["purple",true,"L",399],
      ["purple",false,"S",199],
      ["purple",false,"L",399],
    ]
    expect(actual).to eq(expected)
  end
end
