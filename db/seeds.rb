Resort.destroy_all
User.destroy_all

Resort.create ({name: "Breckenridge", lat: 39.4817, long: -106.0384})
Resort.create ({name: "Keystone", lat: 39.5792, long: -105.9347})
Resort.create ({name: "Vail", lat: 39.6403, long: -106.3742})
Resort.create ({name: "Crested Butte", lat: 38.8697, long: -106.9878})
Resort.create ({name: "Beaver Creek", lat: 39.6042, long: -106.5165})

nate = User.create username: "ncrotes", password_string: "password", age: 32, location: "Denver", favorite_resort: "Breckenridge"
