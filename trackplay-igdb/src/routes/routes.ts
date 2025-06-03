import { igdbRoutes } from '@routes/index'
import { Express } from 'express'

/**
 * Registers all application routes.
 *
 * @param app - The Express application instance
 * @module routes
 */
export const routes = (app: Express): void => {
  app.use('/', igdbRoutes)
}
