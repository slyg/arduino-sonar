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
    { coords : Dict Angle CartesianCoord
    , currentAngle : Angle
    }


type Msg
    = Frame String
