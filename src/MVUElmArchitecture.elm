import Html exposing (..) -- Build HTML elements 
import Html.Events exposing (onClick) -- Allows user interactivity  

{-
  This example illustrates the MVU architecture used in the functional language of Elm 
  to create elegant front end web apps with great performance and less errors due to its functional type system.
  
  The MVU architecture is composed of:
  model: the state of the application
  view: the HTMl based on the model
  update: a way to update your state (i.e. similar to controllers in MVC)
  message: sent from the view to the update function to transform the model
-}


-- Model: represents the application state 
model = 0 


-- View: accepts the model to render dynamic content 
view model = 
  -- Html element with name, attributes and content in lists 
  div []
    [ button [ onClick Decrement ] [ text "-" ] 
    , div [] [ text (toString model) ] 
    , button [ onClick Increment ] [ text "+" ]
    ]

-- Message: use events to create a message (a sort of action)  
-- Message can be either an 'Increment' or 'Decrement (union operator) 
type Message = Increment | Decrement 


-- Update: uses message from view to generate a new model for the view
update msg model = 
  case msg of -- Pattern matching 
    Increment -> 
      model + 1 
    Decrement -> 
      model - 1 
   
   
-- Entry point of the program 
main = 
  beginnerProgram -- Build Elm App from model, view, message and update
    { model = model
    , view = view 
    , update = update 
    }
  
{-
  Awesome things illustrated by this example:
  1) We do not have to worry about how the HTML is generated
  2) Elm provides us with static type safety 
  3) The architecture promotes modularity, reuse and testing 
-}
