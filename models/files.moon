import Model from require "lapis.db.model"

class Files extends Model
    @relations: {
        {"workshops", belongs_to: "Workshops"}
    }