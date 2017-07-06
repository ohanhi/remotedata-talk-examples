module RemoteDataExample exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Http
import RemoteData exposing (..)
import Types exposing (..)


type Msg
    = GetStuff
    | ReceiveStuff (WebData Info)


type alias Model =
    { info : WebData Info }


model : Model
model =
    { info = NotAsked }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetStuff ->
            ( { model | info = Loading }, getStuff )

        ReceiveStuff webData ->
            ( { model | info = webData }, Cmd.none )


getStuff : Cmd Msg
getStuff =
    Http.get "/elm-package.json" decoder
        |> RemoteData.sendRequest
        |> Cmd.map ReceiveStuff


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick GetStuff ] [ text "Get info!" ]
        , p [] [ text "elm-version:" ]
        , case model.info of
            Success info ->
                text info.elmVersion

            Failure _ ->
                text "Oh noes, we can't find the info right now!"

            NotAsked ->
                text "dunno"

            Loading ->
                text "Let's see!"
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = ( model, Cmd.none )
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
