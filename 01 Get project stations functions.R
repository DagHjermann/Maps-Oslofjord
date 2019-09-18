
get_stations_from_project <- function (string, ignore.case = TRUE, exact = FALSE, 
                                       dataframe_projects = df_projects,
                                       keep_all = FALSE) 
{
  if (exact) {
    sel <- dataframe_projects$PROJECT_NAME %in% string
  }
  else {
    sel <- grepl(string, dataframe_projects$PROJECT_NAME, 
                 ignore.case = ignore.case)
  }
  if (sum(sel) == 0) {
    cat("No projects found\n")
    result <- NULL
  }
  else if (sum(sel) > 1 & !keep_all) {
    cat("More than one project found (you may have to specify ignore.case = FALSE or exact = TRUE):\n")
    print(dataframe_projects[sel, ])
    result <- NULL
  }
  else if (sum(sel) == 1 & !keep_all) {
    cat("One project found, stations downloaded from the following project:\n")
    print(dataframe_projects[sel, ])
    id <- dataframe_projects$PROJECT_ID[sel]
    result <- get_stations_from_project_id(id = id)
  } else {
    cat(sum(sel), "projects found, stations downloaded from the following projects:\n")
    print(dataframe_projects[sel, ])
    id <- dataframe_projects$PROJECT_ID[sel]
    result <- purrr::map(id, ~get_stations_from_project_id(id = .))
    names(result) <- dataframe_projects$PROJECT_NAME[sel]
  }
  result
}