sparse::pos(sparsepos):
    int            : type       {}
    int            : stream     {}
    int            : newline    {}
    int            : whitespace {}
    int            : pos        {}
    int            : line       {}
    int            : noexpand   {}

sparse::tok(sparsetok):
    sparsepos    : pos     { new=>1, deref=>1 }
    sparsetok    : next    { new=>1 }

