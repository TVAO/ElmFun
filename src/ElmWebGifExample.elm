
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode 

-- Entry point
-- Program function bundles together the Elm web app 
main = 
  Html.program 
    { init = init "cats"
    , view = view 
    , update = update 
    , subscriptions = subscriptions 
    }
    
    
-- MODEL   
type alias Model = 
  {
    topic : String
  , gifUrl : String 
  }
  

-- Initialize application with a model and command 
init : String -> (Model, Cmd Msg) 
init topic = 
  (Model topic "waiting.gif"
  , getRandomGif topic)
  

-- UPDATE 

-- Result object can either succeed or fail with an error and a value 
type Msg 
  = MorePlease
  | NewGif (Result Http.Error String) 
  
update : Msg -> Model -> (Model, Cmd Msg) 
update msg model = 
  case msg of 
    MorePlease -> 
      (model, getRandomGif model.topic)
    NewGif (Ok newUrl) -> 
      -- Model is reconstructed with new URL 
      ( { model | gifUrl = newUrl }, Cmd.none)
    NewGif (Err _) -> 
      (model, Cmd.none)
      

-- VIEW 

view : Model -> Html Msg 
view model = 
  div [] 
    [ h2 [] [text model.topic] 
    , img [src model.gifUrl] []
    , button [ onClick MorePlease ] [ text "More Please!" ] 
    ]
    
    
-- SUBSCRIPTIONS 
-- Allow to continuously respond to messages from a WebSocket 

subscriptions : Model -> Sub Msg 
subscriptions model = 
  Sub.none 
  
  
-- HELPER FUNCTIONS 
-- Use Commands to make messages via web service requests to Giffy API  
getRandomGif: String -> Cmd Msg 
getRandomGif topic = 
  let 
    url = 
      "https://api.giphy.com/v1/gifs/random?api_key=8e7fcdd8952745539fafa90ae5d38ad6"
  in
  -- Send function, message and command 
  Http.send NewGif (Http.get url decodeGifUrl)
  
-- JSON from Giffy API service is decoded as a string 
decodeGifUrl : Decode.Decoder String 
decodeGifUrl = 
  -- JSON object: "data": { "image_url": "http://..." } 
  Decode.at ["data", "image_url"] Decode.string 




  

