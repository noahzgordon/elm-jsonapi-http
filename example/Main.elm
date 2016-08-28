module Main exposing (main)

import Html
import Html.App
import Platform.Cmd exposing ((!))
import Platform.Sub exposing (Sub)


main =
    Html.App.program
        { init = initialModel ! []
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }


view model =
    Html.text "Hello there"


update _ model =
    model ! []


initialModel =
    {}
