```haskell
classSolution :: MonadWidget t m
              => Dynamic t Bool
              -> m a
              -> m a
classSolution dIn w =




      w
```
=====
We first want to wrap our widget up in a `div` ...
=====
```haskell
classSolution :: MonadWidget t m
              => Dynamic t Bool
              -> m a
              -> m a
classSolution dIn w =



    elClass    "div"  "text-uppercase"            $
      w
```
=====
... with the `text-uppercase` class.
=====
```haskell
classSolution :: MonadWidget t m
              => Dynamic t Bool
              -> m a
              -> m a
classSolution dIn w =



    divClass          "text-uppercase"            $
      w
```
=====
There is a helper function for that as well.
=====
```haskell
classSolution :: MonadWidget t m
              => Dynamic t Bool
              -> m a
              -> m a
classSolution dIn w =
  let
    dClass = bool "" "invisible" <$> dIn
  in
    elDynClass "div"                      dClass  $
      w
```
=====
We can use the `bool` function from `Data.Bool` to help create the necessary `Dynamic t Text`.
=====
```haskell
classSolution :: MonadWidget t m
              => Dynamic t Bool
              -> m a
              -> m a
classSolution dIn w =
  let
    dClass = bool "" " invisible" <$> dIn
  in
    elDynClass "div" ("text-uppercase" <> dClass) $
      w
```
=====
The `IsString` and `Semigroup` instances for `Dynamic` allow us to combine the `Dynamic` and non-`Dynamic` classes.

The space at the start of " invisible" is important, so that we end up with two separate classes rather than a single class name that we don't want.
