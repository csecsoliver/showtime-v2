import Model, enum from require "lapis.db.model"

class Users extends Model
    @relations: {
        {"workshops", has_many: "Workshops"} -- these are the workshops they own (but only if their role allows it)
        {"participations", has_many: "Participations"}
    }
    @role: enum {
        admin: 99
        teacher: 20
        guest: 10
    }