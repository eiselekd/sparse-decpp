sparse::pos(sparsepos):
    int            : type       {}
    int            : stream     {}
    int            : newline    {}
    int            : whitespace {}
    int            : pos        {}
    int            : line       {}
    int            : noexpand   {}

sparse::stmt::STMT_NONE(sparsestmt):

sparse::tok(sparsetok):
    sparsepos    : pos             { new=>1, deref=>1 }
    sparsetok    : next            { new=>1 }

sparse::stmt::STMT_DECLARATION(sparsestmt):
    sparsesym    : declaration        { new=>1, arr=>1 }

sparse::stmt::STMT_CONTEXT(sparsestmt):
    sparseexpr : expression     { new=>1, arr=>1 }

sparse::stmt::STMT_EXPRESSION(sparsestmt):
    sparseexpr : expression        { new=>1 }
    sparseexpr : context           { new=>1 }

sparse::stmt::STMT_COMPOUND(sparsestmt):
    sparsestmt : stmts              { new=>1, arr=>1 }
    sparsesym  : ret                { new=>1 }
    sparsesym  : inline_fn          { new=>1 }
    sparsestmt : args               { new=>1 }

sparse::stmt::STMT_IF(sparsestmt):
    sparseexpr : if_conditional    { new=>1 }
    sparsestmt : if_true           { new=>1 }
    sparsestmt : if_false          { new=>1 }

sparse::stmt::STMT_RETURN(sparsestmt):
    sparseexpr : ret_value         { new=>1 }
    sparsesym  : ret_target        { new=>1 }

sparse::stmt::STMT_CASE(sparsestmt):
    sparseexpr : case_expression   { new=>1 }
    sparseexpr : case_to           { new=>1 }
    sparsestmt : case_statement    { new=>1 }
    sparsesym  : case_label        { new=>1 }

sparse::stmt::STMT_SWITCH(sparsestmt):
    sparseexpr : switch_expression { new=>1 }
    sparsestmt : switch_statement  { new=>1 }
    sparsesym  : switch_break      { new=>1 }
    sparsesym  : switch_case       { new=>1 }

sparse::stmt::STMT_ITERATOR(sparsestmt):
    sparsesym    : iterator_break          { new=>1 }
    sparsesym    : iterator_continue       { new=>1 }
    sparsesym    : iterator_syms           { new=>1, arr=>1 }
    sparsestmt   : iterator_pre_statement  { new=>1 }
    sparseexpr   : iterator_pre_condition  { new=>1 }
    sparsestmt   : iterator_statement      { new=>1 }
    sparsestmt   : iterator_post_statement { new=>1 }
    sparseexpr   : iterator_post_condition { new=>1 }

sparse::stmt::STMT_LABEL(sparsestmt):
    sparsesym    : label_identifier   { new=>1 }
    sparsestmt   : label_statement    { new=>1 }

sparse::stmt::STMT_GOTO(sparsestmt):
    sparsesym    : goto_label        { new=>1 }
    sparseexpr   : goto_expression   { new=>1 }
    sparsesym    : target_list       { new=>1, arr=>1 }

sparse::stmt::STMT_ASM(sparsestmt):
    sparseexpr   : asm_string   { new=>1 }
    sparseexpr   : asm_outputs  { new=>1, arr=>1 }
    sparseexpr   : asm_inputs   { new=>1, arr=>1 }
    sparseexpr   : asm_clobbers { new=>1, arr=>1 }
    sparsesym    : asm_labels   { new=>1, arr=>1 }

sparse::stmt::STMT_RANGE(sparsestmt):
    sparseexpr : range_expression  { new=>1 }
    sparseexpr : range_low         { new=>1 }
    sparseexpr : range_high        { new=>1 }

