module CoreExample exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Http
import Types exposing (..)


type Msg
    = GetStuff
    | ReceiveStuff (Result Http.Error Info)


type alias Model =
    { info : Maybe Info }


model : Model
model =
    { info = Nothing }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetStuff ->
            ( model, getStuff )

        ReceiveStuff (Ok info) ->
            ( { model | info = Just info }, Cmd.none )

        ReceiveStuff (Err _) ->
            ( model, Cmd.none )


getStuff : Cmd Msg
getStuff =
    Http.get "/elm-package.json" decoder
        |> Http.send ReceiveStuff


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick GetStuff ] [ text "Get info!" ]
        , p [] [ text "elm-version:" ]
        , case model.info of
            Just info ->
                text info.elmVersion

            Nothing ->
                text "dunno"
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = ( model, Cmd.none )
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
