import Fluent
import FluentPostgresDriver
import Vapor

// Configures MyworkoutGOServerSide application.
//
public func configure(_ app: Application) throws {

  // uncomment to serve files from /Public folder
  // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

  app.databases.use(.postgres(
    hostname: Environment.get("DATABASE_HOST") ?? "localhost",
    username: Environment.get("DATABASE_USERNAME") ?? "MyworkoutGO_username",
    password: Environment.get("DATABASE_PASSWORD") ?? "MyworkoutGO_password",
    database: Environment.get("DATABASE_NAME") ?? "MyworkoutGO_database"
  ), as: .psql)

  app.migrations.add(CreateUser())
  app.migrations.add(AdminUser())
  app.migrations.add(CreateToken())

  app.logger.logLevel = .debug

  try app.autoMigrate().wait()

  try routes(app)
}
