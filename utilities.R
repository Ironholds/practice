check_null <- function(df, fieldname){
  if(is.null(df[df$field == fieldname,])){
    return(TRUE)
  } else {
    return(FALSE)
  }
}