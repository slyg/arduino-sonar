module Main exposing (..)

import Html exposing (Html, div, program)
import Html.Attributes exposing (style)
import Types exposing (..)
import Dict exposing (Dict)
import List
import Svg exposing (svg, line, circle)
import Svg.Attributes exposing (x1, x2, y1, y2, cx, cy, r, stroke, strokeWidth, width, height, fill, viewBox)
import WebSocket exposing (listen)
import Json.Decode as Decode exposing (Decoder, field, float, decodeString)


init =
    (Model Dict.empty 0) ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Frame msg ->
            let
                polarCoord =
                    msg
                        |> decodeString polarCoordRecordDecoder
                        |> Result.withDefault { angle = 0, distance = 0 }
                        |> \{ angle, distance } -> ( angle, distance )

                ( angle, _ ) =
                    polarCoord

                point =
                    polarToCartesianCoord polarCoord
            in
                { model
                    | coords = Dict.insert angle point model.coords
                    , currentAngle = angle
                }
                    ! []


polarCoordRecordDecoder : Decoder PolarCoordRecord
polarCoordRecordDecoder =
    Decode.map2 PolarCoordRecord
        (field "angle" float)
        (field "distance" float)


polarToCartesianCoord : PolarCoord -> CartesianCoord
polarToCartesianCoord ( angle, distance ) =
    let
        zoom =
            (*) 5

        x =
            distance
                |> (*) (cos <| degrees angle)
                |> zoom

        y =
            distance
                |> (*) (sin << (+) pi <| degrees angle)
                |> zoom
    in
        ( x, y )


subscriptions : Model -> Sub Msg
subscriptions model =
    listen "ws://localhost:9999" Frame


viewCoord : CartesianCoord -> Html Msg
viewCoord ( x, y ) =
    circle
        [ cx (toString (250 + x))
        , cy (toString (250 + y))
        , r "2"
        , fill "#99bb55"
        ]
        []


view : Model -> Html Msg
view model =
    let
        layout =
            circle
                [ cx "250"
                , cy "250"
                , r "250"
                , fill "#efefef"
                ]
                []

        origin =
            circle
                [ cx "250"
                , cy "250"
                , r "10"
                , fill "#dd9922"
                ]
                []

        circles =
            model.coords
                |> Dict.values
                |> List.map viewCoord

        angleView =
            line
                [ x2 "250"
                , y2 "250"
                , x1 (toString (250 + 250 * (cos (degrees model.currentAngle))))
                , y1 (toString (250 - 250 * (sin (degrees model.currentAngle))))
                , stroke "#dd9922"
                , strokeWidth "3"
                ]
                []
    in
        div
            [ style
                [ ( "width", "500px" )
                , ( "display", "block" )
                , ( "margin", "50px auto" )
                ]
            ]
            [ svg [ width "500", height "250", viewBox "0 0 500 250" ]
                ([ layout, angleView, origin ] ++ circles)
            ]


main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
