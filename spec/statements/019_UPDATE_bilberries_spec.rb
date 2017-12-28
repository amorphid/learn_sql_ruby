RSpec.describe "UPDATE" do
  before do
    LearnSQL.query(%q{
      CREATE TABLE bilberries (
        id SERIAL,
        is_ripe BOOLEAN,
        PRIMARY KEY (id)
      );
    })
    LearnSQL.query(%q{
      INSERT into bilberries (is_ripe)
      VALUES (false),
             (false),
             (false);
    })
  end

  after do
    LearnSQL.query("DROP TABLE bilberries;")
  end

  it "1 bilberry" do
    expect {
      LearnSQL.query(%q{
        UPDATE bilberries
        SET is_ripe = TRUE
        WHERE id = 1;
      })
    }
    .to change {
      LearnSQL.query(%{
        SELECT id,is_ripe
        FROM bilberries
        WHERE id = 1;
      })
    }
    .from([
      # id,is_ripe
      [1,false]
    ])
    .to([
      # id,is_ripe
      [1,true]
    ])
  end

  it "all bilberries" do
    expect {
      LearnSQL.query(%q{
        UPDATE bilberries
        SET is_ripe = TRUE;
      })
    }
    .to change {
      LearnSQL.query(%{
        SELECT *
        FROM bilberries
        ORDER BY id;
      })
    }
    .from([
      # id,is_ripe
      [1,false],
      [2,false],
      [3,false],
    ])
    .to([
      # id,is_ripe
      [1,true],
      [2,true],
      [3,true],
    ])
  end
end
