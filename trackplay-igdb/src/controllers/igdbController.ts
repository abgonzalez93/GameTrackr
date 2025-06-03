import { IGDBGameFiltersSchema, IGDBGameFilters } from '@trackplay/core/schemas'
import { assertValid, assertExists } from '@trackplay/core/utils'
import { igdbService } from '@services/index'
import { Request, Response } from 'express'

/**
 * Controller for handling routes related to games.
 *
 * @module controllers
 */
export const igdbController = {
  /**
   * Search games by query string.
   *
   * @route GET /games/search
   * @param req - Express request object
   * @param res - Express response object
   */
  search: async (req: Request, res: Response): Promise<void> => {
    const dto = assertValid<IGDBGameFilters>(IGDBGameFiltersSchema, req.query)
    const games = await igdbService.searchGames(dto)
    res.json(games)
  },

  /**
   * Get a game by its IGDB ID.
   *
   * @route GET /games/:id
   * @param req - Express request object
   * @param res - Express response object
   */
  getByIgdbId: async (req: Request, res: Response): Promise<void> => {
    const igdbId = Number(req.params.id)
    const game = await igdbService.getGameById(igdbId)
    assertExists(game, 'Game not found')
    res.json(game)
  },
}
