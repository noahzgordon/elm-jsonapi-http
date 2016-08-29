module JsonApi.Http
    exposing
        ( getDocument
        , getPrimaryResource
        , getPrimaryResourceCollection
        )

{-| A library for requesting resources from JSON API-compliant servers.
    Intended to be used in conjunction with `elm-jsonapi`, which provides
    serializers and helper functions.

@docs getDocument, getPrimaryResource, getPrimaryResourceCollection
-}

import JsonApi
import JsonApi.Decode exposing (document)
import JsonApi.Documents
import Http
import Task exposing (Task)
import Result exposing (Result)


{-| Retreives a JSON API document from the given endpoint.
-}
getDocument : String -> Task Http.Error JsonApi.Document
getDocument url =
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


{-| Retreives the JSON API resource from the given endpoint.
    If there the payload is malformed or there is no singleton primary resource,
    the error type will be UnexpectedPayload.
-}
getPrimaryResource : String -> Task Http.Error JsonApi.Resource
getPrimaryResource url =
    getDocument url
        `Task.andThen` (JsonApi.Documents.primaryResource >> Task.fromResult >> Task.mapError Http.UnexpectedPayload)


{-| Retreives the JSON API resource collection from the given endpoint.
    If there the payload is malformed or there is no primary resource collection,
    the error type will be UnexpectedPayload.
-}
getPrimaryResourceCollection : String -> Task Http.Error (List JsonApi.Resource)
getPrimaryResourceCollection url =
    getDocument url
        `Task.andThen` (JsonApi.Documents.primaryResourceCollection >> Task.fromResult >> Task.mapError Http.UnexpectedPayload)
