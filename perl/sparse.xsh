sparse::pos(t_position):
    int            : type       {}
    int            : stream     {}
    int            : line       {}
    int            : noexpand   {}

sparse::tok(t_token):
    sparse::tok    : next    {vpost=>'*',cast=>"(struct token *)"}

