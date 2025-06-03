import { Express, json } from 'express'
import compression from 'compression'
import helmet from 'helmet'
import cors from 'cors'

/**
 * Registers global middlewares for the Express app.
 *
 * @module middlewares
 */
export const middlewares = (app: Express): void => {
  app.use(helmet())
  app.use(
    cors({
      origin: 'https://api.trackplay.localhost',
      credentials: true,
    }),
  )
  app.use(compression())
  app.use(json())
}
