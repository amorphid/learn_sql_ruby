RSpec.describe "SELECT" do
  before do
    LearnSQL.query(%q{
      CREATE TABLE bananas (
        id serial,
        color character varying,
        is_ripe bool,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      INSERT INTO bananas (color,is_ripe)
      VALUES ('green',false),
             ('yellow',true);
    })
  end

  after do
    LearnSQL.query("DROP TABLE bananas;")
  end

  it "all for all bananas" do
    actual = LearnSQL.query("SELECT * FROM bananas;")
    expected = [
      #id,color,is_ripe
      [1,"green",false],
      [2,"yellow",true],
    ]
    expect(actual).to eq(expected)
  end

  it "color,is_ripe for all banana" do
    actual = LearnSQL.query("SELECT color,is_ripe FROM bananas;")
    expected = [
      #color,is_ripe
      ["green",false],
      ["yellow",true],
    ]
    expect(actual).to eq(expected)
  end
end
