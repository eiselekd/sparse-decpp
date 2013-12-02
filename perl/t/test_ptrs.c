struct s1 {
    int d1;
};

struct s0 {
    int d0;
    struct s1 *p1;
};
void func1(struct s0 *p);

int g1 = 0;

void
func1(struct s0 *p) {
    int d;
    d = p->p1->d1;
}


/*
  Local Variables:
  c-basic-offset:4
  indent-tabs-mode:nil
  End:
*/
