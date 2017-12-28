RSpec.describe "UNION" do
  before do
    LearnSQL.query(%q{
      CREATE TABLE pineapple_2016_sales (
        id SERIAL,
        sku CHARACTER VARYING,
        gross_cents BIGINT,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      CREATE TABLE pineapple_2017_sales (
        id SERIAL,
        sku CHARACTER VARYING,
        gross_cents BIGINT,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      INSERT INTO pineapple_2016_sales (sku,gross_cents)
      VALUES ('wee',12345),
             ('not so wee',54321),
             ('frikkin huge',1234554321);
    })
    LearnSQL.query(%q{
      INSERT INTO pineapple_2017_sales (sku,gross_cents)
      VALUES ('wee',56789),
             ('not so wee',98765),
             ('frikkin huge',5678998765);
    })
  end

  after do
    LearnSQL.query("DROP TABLE pineapple_2016_sales;")
    LearnSQL.query("DROP TABLE pineapple_2017_sales;")
  end

  it "combined 2016 & 2017 sales for each SKU" do
    actual = LearnSQL.query(%q{
      SELECT pineapple_2016_sales.sku,pineapple_2016_sales.gross_cents
      FROM pineapple_2016_sales
      UNION
      SELECT pineapple_2017_sales.sku,pineapple_2017_sales.gross_cents
      FROM pineapple_2017_sales
      ORDER BY sku DESC,gross_cents ASC;
    })
    expected = [
      # sku,gross_cents
      ['wee',12345],
      ['wee',56789],
      ['not so wee',54321],
      ['not so wee',98765],
      ['frikkin huge',1234554321],
      ['frikkin huge',5678998765],
    ]
    expect(actual).to eq(expected)
  end
end
