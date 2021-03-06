```haskell
higherOrderSolution :: (Reflex t, MonadFix m, MonadHold t m)
                    => Event t Bool
                    -> Event t ()
                    -> m (Dynamic t Int)
higherOrderSolution eClickable eClick = do










  _
```
=====
We have two modes of operation to consider ...
=====
```haskell
higherOrderSolution :: (Reflex t, MonadFix m, MonadHold t m)
                    => Event t Bool
                    -> Event t ()
                    -> m (Dynamic t Int)
higherOrderSolution eClickable eClick = do
  let
    eReset = const 0 <$ eClick
    eAdd   = (+ 1)   <$ eClick







  _
```
=====
... so we create an `Event` based on `eClick` for each of these modes of operation.
=====
```haskell
higherOrderSolution :: (Reflex t, MonadFix m, MonadHold t m)
                    => Event t Bool
                    -> Event t ()
                    -> m (Dynamic t Int)
higherOrderSolution eClickable eClick = do
  let
    eReset = const 0 <$ eClick
    eAdd   = (+ 1)   <$ eClick

    eeMode = bool eReset eAdd <$> eClickable





  _
```
=====
We can then build an `Event` which fires every time the mode of operation changes, and has as a value the `Event` to use while we are in that mode of operation.
=====
```haskell
higherOrderSolution :: (Reflex t, MonadFix m, MonadHold t m)
                    => Event t Bool
                    -> Event t ()
                    -> m (Dynamic t Int)
higherOrderSolution eClickable eClick = do
  let
    eReset = const 0 <$ eClick
    eAdd   = (+ 1)   <$ eClick

    eeMode = bool eReset eAdd <$> eClickable

  deScore <- holdDyn eReset eeMode



  _
```
=====
We can use `holdDyn` to turn this `Event` of `Event`s into a `Dynamic` of `Event`s which captures the changes to the inner `Event` over the lifetime of our application ...
=====
```haskell
higherOrderSolution :: (Reflex t, MonadFix m, MonadHold t m)
                    => Event t Bool
                    -> Event t ()
                    -> m (Dynamic t Int)
higherOrderSolution eClickable eClick = do
  let
    eReset = const 0 <$ eClick
    eAdd   = (+ 1)   <$ eClick

    eeMode = bool eReset eAdd <$> eClickable

  deScore <- holdDyn eReset eeMode
  let
    eScore = switchDyn deScore

  _
```
=====
... and then flatten it into a regular `Event`, which will always be the `Event` for the current mode of operation.
=====
```haskell
higherOrderSolution :: (Reflex t, MonadFix m, MonadHold t m)
                    => Event t Bool
                    -> Event t ()
                    -> m (Dynamic t Int)
higherOrderSolution eClickable eClick = do
  let
    eReset = const 0 <$ eClick
    eAdd   = (+ 1)   <$ eClick

    eeMode = bool eReset eAdd <$> eClickable

  deScore <- holdDyn eReset eeMode
  let
    eScore = switchDyn deScore

  foldDyn ($) 0 eScore
```
=====
We then use `foldDyn` to turn the `Event t (Int -> Int)` into a `Dynamic t Int`.
=====
```haskell
higherOrderSolution :: (Reflex t, MonadFix m, MonadHold t m)
                    => Event t Bool
                    -> Event t ()
                    -> m (Dynamic t Int)
higherOrderSolution eClickable eClick = do
  let
    eReset = const 0 <$ eClick
    eAdd   = (+ 1)   <$ eClick

    eeMode = bool eReset eAdd <$> eClickable

  eScore <- switchHold eReset eeMode



  foldDyn ($) 0 eScore
```
=====
In this case we can simplify the switching using `switchHold` to flatten the `Event` of `Event`s directly.
