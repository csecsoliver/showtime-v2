import create_table, types, add_column from require "lapis.db.schema"

{
    [1]: =>
        create_table "users", {
            {"id", types.integer primary_key: true}
            {"username", types.text unique: true}
            {"passhash", types.text}
            {"role", types.string default: "guest"}
        }
        create_table "workshops", {
            {"id", types.integer primary_key: true}
            {"user_id", types.integer}
            {"created_at", types.integer}
            {"date", types.integer}
        }
        create_table "files", {
            {"id", types.integer primary_key:true}
            {"workshop_id", types.integer}
            {"path", types.text}
        }
        create_table "participants", {
            {"id", types.integer primary_key:true}
            {"user_id", types.integer}
            {"workshop_id", types.integer}
        }

    [2]: =>
        
    [3]: =>
        add_column "posts", "thumbnail_path", types.text default: ""
    [4]: =>
        add_column "users", "coins", types.integer default: 0
        add_column "users", "social", types.text default: ""
        add_column "users", "upload_token", types.text default: ""
        add_column "posts", "color", types.text default: ""
}