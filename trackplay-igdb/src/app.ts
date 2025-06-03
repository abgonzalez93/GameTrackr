import { middlewares, errorHandler } from '@middlewares/index'
import { routes } from '@routes/index'
import express from 'express'

/**
 * Main Express application setup.
 *
 * @module app
 */
const app = express()

middlewares(app)
routes(app)
app.use(errorHandler)

export default app
