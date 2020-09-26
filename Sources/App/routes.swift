import Fluent
import Vapor

/// Setting up Controllers routes for api endpoints.
///
func routes(_ app: Application) throws {

  let usersController = UsersController()
  try app.register(collection: usersController)
}
