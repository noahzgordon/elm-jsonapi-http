module JsonApi.Http
    exposing
        ( Error(..)
        , get
        )

{-| A library for requesting resources from JSON API-compliant servers.
    Intended to be used in conjunction with `elm-jsonapi`, which provides
    serializers and helper functions.

@docs Error, get
-}

import JsonApi
import JsonApi.Decode exposing (document)
import Http
import Task exposing (Task)


{-| Data type representing an error resulting from a network request
-}
type Error
    = Error
    | NetworkError


{-| Function which retreives an inital resource from a given endpoint
-}
get : String -> Task Http.Error JsonApi.Document
get url =
    Http.send Http.defaultSettings
        { verb = "GET"
        , headers =
            [ ( "Content-Type", "application/vnd.api+json" )
            , ( "Accept", "application/vnd.api+json" )
            ]
        , url = url
        , body = Http.empty
        }
        |> Http.fromJson document

