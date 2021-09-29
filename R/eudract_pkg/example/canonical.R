safety_statistics <- safety_summary(safety,
                                    exposed=c("Experimental"=60,"Control"=67))
simple <- tempfile(fileext = ".xml")
eudract <- tempfile(fileext = ".xml")
ct <- tempfile(fileext = ".xml")
simple_safety_xml(safety_statistics, simple)
eudract_convert(input=simple,
                output=eudract)
clintrials_gov_convert(input=simple,
                       original=system.file("extdata", "1234.xml", package ="eudract"),
                output=ct)
\dontrun{
  # This needs a real user account to work
  clintrials_gov_upload(
    input=simple,
    orgname="CTU",
    username="Student",
    password="Guinness",
    studyid="1234"
    )

}
