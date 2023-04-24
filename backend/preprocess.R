# imageMap <- function(inputId, imgsrc, opts) {
#   areas <- lapply(names(opts), function(n) 
#     shiny::tags$area(title=n, coords=opts[[n]], 
#                      href="#", shape="poly"))
#   js <- paste0("$(document).on('click', 'map area', function(evt) {
#   evt.preventDefault();
#   var val = evt.target.title;
#   Shiny.onInputChange('", inputId, "', val);})")
#   list(
#     shiny::tags$img(src=imgsrc, usemap=paste0("#", inputId),
#                     shiny::tags$head(tags$script(shiny::HTML(js)))),
#     shiny::tags$map(name=inputId, areas))
# }

imageMap <- function(inputId, imgsrc, opts) {
  areas <- lapply(names(opts), function(n) 
    shiny::tags$area(title=n, coords=opts[[n]], 
                     href="#", shape="poly"))
  js <- paste0("$(document).on('click', 'map area', function(evt) {
  evt.preventDefault();
  var val = evt.target.title;
  print('hello');})")
  list(
    shiny::tags$img(src=imgsrc, usemap=paste0("#", inputId),
                    shiny::tags$head(tags$script(shiny::HTML(js)))),
    shiny::tags$map(name=inputId, areas))
}