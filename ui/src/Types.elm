module Types exposing (..)

import Dict exposing (Dict)


type alias Angle =
    Float


type alias Distance =
    Float


type alias CartesianCoord =
    ( Float, Float )


type alias PolarCoordRecord =
    { angle : Angle, distance : Distance }


type alias PolarCoord =
    ( Angle, Distance )


type alias Model =
    { points : Dict Angle CartesianCoord
    }


type Msg
    = Noop
    | Frame String
