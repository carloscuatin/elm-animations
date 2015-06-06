import Svg exposing (Svg)
import Svg.Attributes as Svg
import Html exposing (Html)
import Html.Attributes as Html
import Html.Events as Html
import Easing
import Color
import Time exposing (Time)
import String
import Debug
import Animation.Last exposing (..)
        
-- --
-- -- DEMO APP
-- --

box time (_,model) =
    let
        ease = animateOnOff time model
        size = ease easeInt 100 200
    in
        [ Html.div
            [ Html.style
                [ width size, height size
                , background <| ease Easing.color Color.red Color.blue
                , transform [rotate <| ease Easing.float 0 180]]
            , Html.onMouseEnter tbox.address (Animate True)
            , Html.onMouseLeave tbox.address (Animate False)
            ] []
        ] |> Html.div [Html.style [width 200, height 200, background Color.lightGrey, ("display", "inline-block")]]

render time model =
    model
    |> List.map (box time)
    |> Html.div []
    |> \html -> Html.div []
        [ html
        , Html.text (toString time), Html.br [] []
        , Html.text (toString model)
        ]

tbox = Signal.mailbox Init

init : Model
init =
    [0..7]
    |> List.map (\i -> (i,onOffAnimationState False))

type Action = Animate Bool | Init
type alias Model = List (Int,AnimationState Float)

step : (Time,Action) -> Model -> Model
step (time,action) model = case action of
    Init -> model
    Animate value -> model |> List.map (\(i,m) -> (i,startOnOffAnimation Easing.easeInOutQuad Time.second (time + (toFloat i)*50) value m))

main = animationSignal init step render tbox.signal
