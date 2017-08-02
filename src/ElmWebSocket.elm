
{-
  This Elm web example shows how subscriptions may be used 
  to continously respond to messages from a server 
  Posts messages to the web socket as an echo service to display on screen
  The architecture follows an MVU pattern with model, view, update functions.
-}


-- LIBRARIES 
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket


-- ENTRY POINT  
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- Parameter points at echo service 
echoServer : String
echoServer =
  "wss://echo.websocket.org"



-- MODEL


type alias Model =
  { input : String -- Message sent to echo service 
  , messages : List String -- Builds from all socket messages 
  }


-- Initialize web app and model 
init : (Model, Cmd Msg)
init =
  (Model "" [], Cmd.none)



-- UPDATE


type Msg
  = Input String -- Message in text box 
  | Send -- Triggered upon clicking "Send"
  | NewMessage String -- 

-- Returns new model and any commands to be executed 
update : Msg -> Model -> (Model, Cmd Msg)
update msg {input, messages} =
  case msg of
    Input newInput ->
      (Model newInput messages, Cmd.none)

    Send -> -- Generate command to web socket with textbox input 
      (Model "" messages, WebSocket.send echoServer input)

    NewMessage str -> -- Add new message to list of messages 
      (Model input (str :: messages), Cmd.none)



-- SUBSCRIPTIONS


-- Web socket works differently from HTTP requests that alwais gives a response back
-- Web socket is unidirectional and does not guarantee a response
-- The web socket continuously listens on the echo server for messages 
subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen echoServer NewMessage



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ input [onInput Input, value model.input] []
    , button [onClick Send] [text "Send"]
    , div [] (List.map viewMessage (List.reverse model.messages))
    ]


viewMessage : String -> Html msg
viewMessage msg =
  div [] [ text msg ]
