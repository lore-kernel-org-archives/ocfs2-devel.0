From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Jan 25 10:53:18 2008
Subject: [Ocfs2-devel] /etc/mkfs.ocfs2.conf support
In-Reply-To: <20080123094730.GA18317@baloo.nue.novell.com>
References: <20080123094730.GA18317@baloo.nue.novell.com>
Message-ID: <20080125185146.GU23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jan 23, 2008 at 03:17:30PM +0530, Goldwyn Rodrigues wrote:
> 
> Changes to support mkfs.ocfs2.conf
> Mostly picked from e2fsprogs
> 
> --- 
> diff --git a/mkfs.ocfs2/Makefile b/mkfs.ocfs2/Makefile
> index 00d9d22..7c3c0f5 100644
> --- a/mkfs.ocfs2/Makefile
> +++ b/mkfs.ocfs2/Makefile
> @@ -28,7 +28,7 @@ LIBO2DLM_DEPS = $(TOPDIR)/libo2dlm/libo2dlm.a
>  INCLUDES = -I$(TOPDIR)/include -I.
>  DEFINES = -DVERSION=\"$(VERSION)\"
>  
> -CFILES = mkfs.c check.c
> +CFILES = prof_err.c profile.c mkfs.c check.c
>  HFILES = mkfs.h
>  
>  OBJS = $(subst .c,.o,$(CFILES))
> @@ -40,4 +40,12 @@ DIST_FILES = $(CFILES) $(HFILES) mkfs.ocfs2.8.in
>  mkfs.ocfs2: $(OBJS) $(LIBOCFS2_DEPS) $(LIBO2DLM_DEPS) $(LIBO2CB_DEPS)
>  	$(LINK) $(LIBOCFS2_LIBS) $(LIBO2DLM_LIBS) $(LIBO2CB_LIBS) $(COM_ERR_LIBS) $(UUID_LIBS)
>  
> +prof_err.c prof_err.h: prof_err.et
> +	compile_et prof_err.et
> +
> +CLEAN_RULES = clean-err
> +
> +clean-err:
> +	rm -f prof_err.c prof_err.h
> +
>  include $(TOPDIR)/Postamble.make
> diff --git a/mkfs.ocfs2/mkfs.c b/mkfs.ocfs2/mkfs.c
> index 0ade0ab..610b994 100644
> --- a/mkfs.ocfs2/mkfs.c
> +++ b/mkfs.ocfs2/mkfs.c
> @@ -24,6 +24,9 @@
>   */
>  
>  #include "mkfs.h"
> +#include "profile.h"
> +
> +profile_t profile;
>  
>  static State *get_state(int argc, char **argv);
>  static int get_number(char *arg, uint64_t *res);
> @@ -507,11 +510,104 @@ parse_fs_type_opts(char *progname, const char *typestr,
>  	}
>  }
>  
> +static void syntax_err_report(const char *filename, long err, int line_num)
> +{
> +	fprintf(stderr, "Syntax error in mke2fs config file (%s, line #%d)\n\t%s\n", filename, line_num, error_message(err));
> +	exit(1);
> +}
> +
> +
> +static const char *config_fn[] = { "/etc/mkfs.ocfs2.conf", 0 };
> +static const char *default_files[] = { "<default>", 0 };
> +const char *mkfs_default_profile = 
> +  "[defaults]\n"
> +  "	block-size = 4096\n"
> +  "\n"
> +  "[fs_types]\n"
> +  "	datafiles = {\n"
> +  "		journal = {\n"
> +  "			size = 8192\n"
> +  "		}\n"
> +  "	}\n"

Is this making '-T datafiles' the default? It should not be...
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
