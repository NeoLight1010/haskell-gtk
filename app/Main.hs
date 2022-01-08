{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedLists #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad
import GI.Gtk.Declarative
import GI.Gtk.Declarative.App.Simple
import GI.Gtk.Objects hiding (Widget)

data State = Clicked | NotClicked

data Event = ButtonClicked | Quit

update' :: State -> Event -> Transition State Event
update' _ Quit = Exit
update' _ ButtonClicked = Transition Clicked (return Nothing)

drawWindow w s =
  bin
    Window
    [ #title := "Hello World!",
      on #deleteEvent $ const (True, Quit)
    ]
    $ w s

drawBody :: State -> Widget Event
drawBody Clicked = widget Button [#label := "Thank you!"]
drawBody NotClicked =
  widget
    Button
    [ #label := "Click me!",
      on #clicked ButtonClicked
    ]

main :: IO ()
main =
  void $
    run
      App
        { view = drawWindow drawBody,
          update = update',
          inputs = [],
          initialState = NotClicked
        }
