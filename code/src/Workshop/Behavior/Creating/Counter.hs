{-|
Copyright   : (c) 2018, Commonwealth Scientific and Industrial Research Organisation
License     : BSD3
Maintainer  : dave.laing.80@gmail.com
Stability   : experimental
Portability : non-portable
-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecursiveDo #-}
module Workshop.Behavior.Creating.Counter (
    counterProblem
  ) where

import Reflex.Dom.Core

import Util.Bootstrap
import Util.Exercises
import Util.File

import Workshop.Behavior.Creating.Counter.Exercise
import Workshop.Behavior.Creating.Counter.Solution

mk :: MonadWidget t m
   => (Event t (Int -> Int) -> m (Behavior t Int, Event t Int))
   -> Event t ()
   -> Event t ()
   -> m (Event t (), Event t ())
mk fn eAddIn eClearIn = card $ mdo
  (eAddOut, eClearOut) <- divClass "row" $ do
    eA <- divClass "col-6" $ buttonClass "Add" "btn btn-block"
    eC <- divClass "col-6" $ buttonClass "Clear" "btn btn-block"
    pure (eA, eC)

  let
    eAdd = leftmost [eAddIn, eAddOut]
    eClear = leftmost [eClearIn, eClearOut]
    eFn = leftmost [ (+ 1) <$ eAdd, const 0 <$ eClear]

  (b, e) <- fn eFn
  let
    d = unsafeDynamic b e

  divClass "row" $ do
    divClass "col-6" $ text "Count"
    divClass "col-6" $ display d

  pure (eAddOut, eClearOut)

counterProblem :: MonadWidget t m => m (Problem t m)
counterProblem =
  pure $ Problem counterGoal counterEx "../pages/behaviors/creating/counter/solution.md"

counterGoal :: MonadWidget t m => m ()
counterGoal =
  loadMarkdown "../pages/behaviors/creating/counter/goal.md"

counterEx :: MonadWidget t m => m ()
counterEx = mdo
  [a, b, c] <- loadMarkdownSingle "../pages/behaviors/creating/counter/exercise.md"
  a
  (eAddEx, eClearEx)   <- mk counterExercise eAddSol eClearSol
  b
  (eAddSol, eClearSol) <- mk counterSolution eAddEx eClearEx
  c
