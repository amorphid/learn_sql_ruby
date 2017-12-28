RSpec.describe "INSERT" do
  before do
    LearnSQL.query(%q{
      CREATE TABLE kiwis (
        id SERIAL,
        serial_number CHARACTER VARYING,
        seed_count INT,
        PRIMARY KEY (id)
      );
    })
  end

  after do
    LearnSQL.query("DROP TABLE kiwis;")
  end

  it "1 kiwi" do
    expect do
      LearnSQL.query(%q{
        INSERT into kiwis (serial_number,seed_count)
        VALUES ('abc123',33);
      })
    end
    .to change {LearnSQL.query("SELECT COUNT(id) FROM kiwis;")}
    .from([[0]]) # [[count]]
    .to([[1]])   # [[count]]
    actual = LearnSQL.query(%q{
      SELECT *
      FROM kiwis;
    })
    expected = [
      # id,serial_number,seed_count
      [1,"abc123",33]
    ]
    expect(actual).to eq(expected)
  end

  it "3 kiwis" do
    expect do
      LearnSQL.query(%q{
        INSERT into kiwis (serial_number,seed_count)
        VALUES ('abc123',11),
               ('def456',22),
               ('ghi789',33);
      })
    end
    .to change {LearnSQL.query("SELECT COUNT(id) FROM kiwis;")}
    .from([[0]]) # [[count]]
    .to([[3]])   # [[count]]
    actual = LearnSQL.query(%q{
      SELECT *
      FROM kiwis
      ORDER BY id;
    })
    expected = [
      # id,serial_number,seed_count
      [1,"abc123",11],
      [2,"def456",22],
      [3,"ghi789",33],
    ]
    expect(actual).to eq(expected)
  end
end
