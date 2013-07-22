use 5.012003;
use ExtUtils::MakeMaker;

my $gcc = system("gcc --print-file-name=");

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'sparse',
    VERSION_FROM      => 'lib/sparse.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/sparse.pm', # retrieve abstract from module
       AUTHOR         => 'eiselekd <eiselekd@gmail.com>') : ()),
#   LIBS              => [], # e.g., '-lm'
    LIBS              => ['-L./.. '], # e.g., '-lm'
    DEFINE            => '-DGCC_BASE="\"'.$gcc.'\""', # e.g., '-DHAVE_SOMETHING'
    INC               => '-I. -I..', # e.g., '-I. -I/usr/include/other'
	# Un-comment this if you add C files to link with later:
    # OBJECT            => '$(O_FILES)', # link all the C files too
);
