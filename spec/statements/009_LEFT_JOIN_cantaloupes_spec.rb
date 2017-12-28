RSpec.describe "LEFT JOIN" do
  before do
    LearnSQL.query(%q{
      CREATE TABLE cantaloupes (
        id SERIAL,
        serial_number CHARACTER VARYING,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      CREATE TABLE bites (
        id SERIAL,
        cantaloupe_id INT,
        biter CHARACTER VARYING,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      INSERT INTO cantaloupes (serial_number)
      VALUES ('ab12'),
             ('de34'),
             ('fg56'),
             ('hi78');
    })
    LearnSQL.query(%q{
      INSERT INTO bites (cantaloupe_id,biter)
      VALUES (1,'Bob'),
             (3,'Bob'),
             (3,'Susie'),
             (4,'Dave');
    })
  end

  after do
    LearnSQL.query("DROP TABLE cantaloupes;")
    LearnSQL.query("DROP TABLE bites;")
  end

  it "Serial numbers of each unbitten cantaloupes" do
    actual = LearnSQL.query(%q{
      SELECT cantaloupes.serial_number
      FROM cantaloupes
      LEFT JOIN bites
      ON cantaloupes.id = bites.cantaloupe_id
      WHERE bites.cantaloupe_id IS NULL;
    })
    expected = [
      # cantaloupes.serial_number
      ["de34"]
    ]
    expect(actual).to eq(expected)
  end

  it "unbitten cantaloupes & cantaloupes bitten by Bob" do
    actual = LearnSQL.query(%q{
      SELECT cantaloupes.id,cantaloupes.serial_number,bites.biter
      FROM cantaloupes
      LEFT JOIN bites
      ON cantaloupes.id = bites.cantaloupe_id
      WHERE bites.biter IS NULL
      OR bites.biter = 'Bob'
      ORDER BY cantaloupes.id;
    })
    expected = [
      # cantaloupes.id,cantaloupes.serial_number,bites.biter
      [1,"ab12","Bob"],
      [2,"de34",nil],
      [3,"fg56","Bob"],
    ]
    expect(actual).to eq(expected)
  end
end
