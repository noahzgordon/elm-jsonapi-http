module Main exposing (main)

import Html
import Http
import Html.Events exposing (onClick)
import Platform.Cmd exposing ((!))
import Platform.Sub exposing (Sub)
import Json.Decode
import JsonApi
import JsonApi.Http
import JsonApi.Resources
import Debug


main =
    Html.program
        { init = (initialModel, Cmd.none)
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }


type Message
    = GetProtagonist
    | ProtagonistLoaded (Result Http.Error JsonApi.Resource)


view model =
    Html.div []
        [ Html.p [] [ Html.text "A long time ago in a galaxy far, far away..." ]
        , renderProtagonist model
        ]


renderProtagonist model =
    case model.protagonist of
        Nothing ->
            Html.button [ Html.Events.onClick GetProtagonist ] [ Html.text "Get Initial Model" ]

        Just character ->
            Html.p [] [ Html.text (character.firstName ++ " " ++ character.lastName) ]


update message model =
    case message of
        GetProtagonist ->
            ( model, getProtagonist )

        ProtagonistLoaded (Ok resource) ->
            ( { model | protagonist = JsonApi.Resources.attributes characterDecoder resource |> Result.toMaybe }, Cmd.none)

        ProtagonistLoaded (Err error) ->
            Debug.log ("Remember to start the server on port 9292! " ++ toString e) (model, Cmd.none)


type alias Model =
    { protagonist : Maybe Character
    }


type alias Character =
    { firstName : String
    , lastName : String
    }


characterDecoder : Json.Decode.Decoder Character
characterDecoder =
    Json.Decode.map2 Character
        (Json.Decode.field "first-name" Json.Decode.string)
        (Json.Decode.field "last-name" Json.Decode.string)


initialModel =
    { protagonist = Nothing
    }


getProtagonist : Cmd Message
getProtagonist =
    JsonApi.Http.getPrimaryResource "http://localhost:9292/luke"
        |> Http.send ProtagonistLoaded
