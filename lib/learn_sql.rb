# dependencies
require "pg"

# learn_sql
require "learn_sql/version"

module LearnSQL
  DB = "learn_sql_ruby".freeze

  class << self
    def query(sql,params=[])
      raise "not connected" unless @conn
      raise "query not terminated by semicolon" unless sql.strip =~ /;\z/
      @conn.exec_params(sql,params).values
    end

    def prepare()
      conn = PG.connect(dbname: "template1")
      conn.exec("CREATE DATABASE #{LearnSQL::DB}")
      conn.close
      :ok
    end

    def start()
      raise "already started" if @conn
      # open connection to database (and create database if necessary)
      @conn ||= begin
        PG.connect(dbname: DB)
      rescue
        raise "run `rake db:setup` to create & seed database"
      end
      # configure connection to return native types (e.g. return `1`, not `"1"`)
      @conn.type_map_for_results = PG::BasicTypeMapForResults.new(@conn)
      :ok
    end

    def stop()
      raise "not started" unless @conn
      @conn.close
      @conn = nil
      :ok
    end

    def teardown()
      conn = PG.connect(dbname: "template1")
      conn.exec("DROP DATABASE #{LearnSQL::DB}")
      conn.close()
      :ok
    end
  end
end
