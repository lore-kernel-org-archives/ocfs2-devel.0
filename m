From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri Jan 25 16:10:56 2008
Subject: [Ocfs2-devel] /etc/mkfs.ocfs2.conf support
In-Reply-To: <20080123094730.GA18317@baloo.nue.novell.com>
References: <20080123094730.GA18317@baloo.nue.novell.com>
Message-ID: <20080126001015.GB32433@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jan 23, 2008 at 03:17:30PM +0530, Goldwyn Rodrigues wrote:
> Changes to support mkfs.ocfs2.conf
> Mostly picked from e2fsprogs

	Interesting.  I didn't even know this existed :-)  First thought
- what version of e2fsprogs is this from?  I grabbed 1.40.4, the latest
on my Debian installation, and its profile.c is very different.

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

	You can't put prof_err.c in CFILES - that will include it in
DIST_FILES, which we don't want.  Conversely, you need to add
prof_err.et to DIST_FILES.  I suggest

 - Add prof_err.et to DIST_FILES
 - Add prof_err.o to OBJS

This will force prof_err.o to be included in the mkfs.ocfs2
dependencies.  .c.o rules will cause prof_err.c to be required, and this
will trigger the compile_et of prof_err.et.  Meanwhile, having
prof_err.et in DIST_FILES makes sure it's part of the tarball.
	See libocfs2/Makefile for how we do this.  You might also want
to add HEADERS_GEN like you see in there so that you can declare:

HFILES = mkfs.h
HFILES_GEN = prof_err.h 

$(OBJS): $(HFILES) $(HFILES_GEN)

This triggers a build dependency on prof_err.h for all objects.

> +	/* Read from the configuration file and set the values */
> +	blocksize = get_bytesize_from_profile(ft_str,"block-size" , blocksize);
> +	cluster_size =  get_bytesize_from_profile(ft_str, "cluster-size", cluster_size);
> +	journal_size_in_bytes = get_journalsize_from_profile(ft_str, journal_size_in_bytes);
> +	blockscount = get_bytesize_from_profile(ft_str, "blocks-count", blockscount);
> +	initial_slots = get_uint_from_profile(ft_str, "number-of-nodes", initial_slots);

	Here, you are relying on multiple things:

1) If the value is nonzero, nothing will happen.  Why hide this above in
   get_*_from_profile()?  Why not say

	if (!blocksize)
		blocksize = get_bytesize_from_profile(ft_str, "block-size");

2) if ft_str is NULL, only the [defaults] section is honored.  This is
   not obvious without reading profile.c, so one could think that it
   might select the first fs_type in the [fs_type] section.  Put a
   comment in the get_*_from_profile() functions, right before you set
   names[1] = category, stating that NULL means ignored.
3) Setting these here will cause fill_defaults() to skip them.  If
   get_*_from_profile() returns 0 (unset), fill_defaults() will fill
   them.  This is the correct behavior, but it strikes me as non-obvious
   and could use a comment somewhere.

Joel

-- 

Life's Little Instruction Book #347

	"Never waste the oppourtunity to tell someone you love them."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
