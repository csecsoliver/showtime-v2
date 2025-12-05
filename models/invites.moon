import Model from require "lapis.db.model"

class Invites extends Model
    @relations: {
        {"workshop", belongs_to: "Workshops"}
        {"user", belongs_to: "Users"}
    }
    