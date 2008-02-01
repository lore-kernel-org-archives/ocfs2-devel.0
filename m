From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Fri Feb  1 15:38:23 2008
Subject: [Ocfs2-devel] Re: [patch 2/5] ocfs2: add compatibility for
	mandatory_lock()
In-Reply-To: <20080131204715.360817000@suse.com>
References: <20080131204634.478915000@suse.com>
	<20080131204715.360817000@suse.com>
Message-ID: <47A3AD13.7080500@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Jeff Mahoney wrote:
>  SLES10 doesn't have a mandatory_lock() function, but does support
>  IS_MANDATORY() and the associated functions.
>
>  This patch adds mandatory_lock() support.
>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>   

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

> ---
>
>  Config.make.in                       |    1 +
>  configure.in                         |    6 ++++++
>  fs/ocfs2/Makefile                    |    4 ++++
>  kapi-compat/include/mandatory_lock.h |   27 +++++++++++++++++++++++++++
>  4 files changed, 38 insertions(+)
>
> --- a/Config.make.in	2008-01-31 13:48:44.000000000 -0500
> +++ b/Config.make.in	2008-01-31 13:49:00.000000000 -0500
> @@ -88,6 +88,7 @@ INVALIDATEPAGE_RETURNS_INT = @INVALIDATE
>  DIO_OLD_GET_BLOCKS = @DIO_OLD_GET_BLOCKS@
>  HAS_SYSTEM_UTSNAME = @HAS_SYSTEM_UTSNAME@
>  NO_LOCKDEP = @NO_LOCKDEP@
> +NO_MANDATORY_LOCK = @NO_MANDATORY_LOCK@
>  
>  OCFS_DEBUG = @OCFS_DEBUG@
>  
> --- a/configure.in	2008-01-31 13:48:44.000000000 -0500
> +++ b/configure.in	2008-01-31 13:49:00.000000000 -0500
> @@ -384,6 +384,12 @@ OCFS2_CHECK_KERNEL([linux/lockdep.h], lo
>    NO_LOCKDEP=yes, [^struct lock_class {])
>  AC_SUBST(NO_LOCKDEP)
>  
> +NO_MANDATORY_LOCK=
> +OCFS2_CHECK_KERNEL([mandatory_lock() in fs.h], fs.h, ,
> +  NO_MANDATORY_LOCK=yes, [^static inline int mandatory_lock(])
> +AC_SUBST(NO_MANDATORY_LOCK)
> +KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS mandatory_lock.h"
> +
>  # using -include has two advantages:
>  #  the source doesn't need to know to include compat headers
>  #  the compat header file names don't go through the search path
> --- a/fs/ocfs2/Makefile	2008-01-31 13:48:44.000000000 -0500
> +++ b/fs/ocfs2/Makefile	2008-01-31 13:49:00.000000000 -0500
> @@ -140,6 +140,10 @@ ifdef NO_LOCKDEP
>  EXTRA_CFLAGS += -DNO_LOCKDEP
>  endif
>  
> +ifdef NO_MANDATORY_LOCK
> +EXTRA_CFLAGS += -DNO_MANDATORY_LOCK
> +endif
> +
>  #
>  # Since SUBDIRS means something to kbuild, define them safely.  Do not
>  # include trailing slashes.
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ b/kapi-compat/include/mandatory_lock.h	2008-01-31 13:49:00.000000000 -0500
> @@ -0,0 +1,27 @@
> +#ifndef KAPI_MANDATORY_LOCK_H
> +#define KAPI_MANDATORY_LOCK_H
> +
> +#ifdef NO_MANDATORY_LOCK
> +#include <linux/fs.h>
> +/*
> + * Candidates for mandatory locking have the setgid bit set
> + * but no group execute bit -  an otherwise meaningless combination.
> + */
> +
> +static inline int __mandatory_lock(struct inode *ino)
> +{
> +        return (ino->i_mode & (S_ISGID | S_IXGRP)) == S_ISGID;
> +}
> +
> +/*
> + * ... and these candidates should be on MS_MANDLOCK mounted fs,
> + * otherwise these will be advisory locks
> + */
> +
> +static inline int mandatory_lock(struct inode *ino)
> +{
> +        return IS_MANDLOCK(ino) && __mandatory_lock(ino);
> +}
> +#endif
> +
> +#endif /* KAPI_MANDATORY_LOCK_H */
>
>
>   
