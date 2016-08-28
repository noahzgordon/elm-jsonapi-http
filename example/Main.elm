module Main exposing (main)

import Html
import Html.App
import Html.Events exposing (onClick)
import Platform.Cmd exposing ((!))
import Platform.Sub exposing (Sub)
import JsonApi.Http


main =
    Html.App.program
        { init = initialModel ! []
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }


type Message
    = GetInitialModel


view model =
    Html.div []
        [ Html.p [] [ Html.text "A long time ago in a galaxy far, far away..." ]
        , renderProtagonist model
        ]


renderProtagonist model =
    case model.protagonist of
        Nothing ->
            Html.button [ Html.Events.onClick GetInitialModel ] [ Html.text "Get Initial Model" ]

        Just user ->
            Html.p [] [ Html.text (user.firstName ++ " " ++ user.lastName) ]


update message model =
    case message of
        GetInitialModel ->
            model ! [getProtagonist]


initialModel =
    { protagonist = Nothing
    }


getProtagonist : Cmd Message
getProtagonist =
    JsonApi.Http.get "localhost:3000"
