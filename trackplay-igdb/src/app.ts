import { applyMiddlewares, errorHandler } from '@trackplay/core/middlewares'
import { routes } from '@routes/index'
import { config } from '@config/index'
import express from 'express'

/**
 * Main Express application setup.
 *
 * @module app
 */
const app = express()

applyMiddlewares(app, {
  cors: {
    origin: config.CORS_ORIGINS.split(','),
    credentials: true,
  },
})

routes(app)
app.use(errorHandler)

export default app
