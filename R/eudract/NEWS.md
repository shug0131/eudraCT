# eudract v0.9.3

Error is caused if any of the group names are less than 4 characters in length, as EudraCT will reject this.


# eudract v 0.9.2

Minor bug fix in the test scripts


# eudract v0.9.1

A bug was detected with the version number associated with SOC "Product issues", where the default value of 19 is not accepted by the EudraCT portal. A fix is implemented in the simpleToEudraCT.xslt file that conditionally sets the version to be 3 for this SOC, and 22 for all other SOC values. 

# eudract v0.9.0

This is the first release on CRAN
