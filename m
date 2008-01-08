From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jan  8 16:05:38 2008
Subject: [Ocfs2-devel] [PATCH 23/30] ocfs2: Handles missing export
	should_remove_suid()
In-Reply-To: <1199388006-32658-22-git-send-email-sunil.mushran@oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
	<1199388006-32658-22-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080109000428.GV23506@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 03, 2008 at 11:19:59AM -0800, Sunil Mushran wrote:
> Commits 01de85e057328ecbef36e108673b1e81059d54c1 and
> d23a147bb6e8d467e8df73b6589888717da3b9ce in mainline added and exported
> symbol should_remove_suid(). This patch allows one to build ocfs2 with
> kernels having/not having these changes.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  Config.make.in                           |    1 +
>  Makefile                                 |    3 +-
>  configure.in                             |    6 +++++
>  fs/ocfs2/Makefile                        |    4 +++
>  kapi-compat/include/should_remove_suid.h |   37 ++++++++++++++++++++++++++++++
>  5 files changed, 50 insertions(+), 1 deletions(-)
>  create mode 100644 kapi-compat/include/should_remove_suid.h
> 
> diff --git a/Config.make.in b/Config.make.in
> index a912f40..53792d0 100644
> --- a/Config.make.in
> +++ b/Config.make.in
> @@ -68,6 +68,7 @@ NO_SU_MUTEX_IN_STRUCT_CONFIGFS_SUBSYSTEM = @NO_SU_MUTEX_IN_STRUCT_CONFIGFS_SUBSY
>  STRUCT_SUBSYSTEM_DEFINED = @STRUCT_SUBSYSTEM_DEFINED@
>  NO_FALLOCATE = @NO_FALLOCATE@
>  NO_SPLICE_HEADER = @NO_SPLICE_HEADER@
> +NO_SHOULD_REMOVE_SUID = @NO_SHOULD_REMOVE_SUID@
>  
>  OCFS_DEBUG = @OCFS_DEBUG@
>  
> diff --git a/Makefile b/Makefile
> index ea4b979..0c17fec 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -25,7 +25,8 @@ KAPI_COMPAT_FILES = \
>  	kapi-compat/include/su_mutex.h \
>  	kapi-compat/include/kobject.h \
>  	kapi-compat/include/cap.h \
> -	kapi-compat/include/relatime.h
> +	kapi-compat/include/relatime.h \
> +	kapi-compat/include/should_remove_suid.h
>  
>  PATCH_FILES =
>  
> diff --git a/configure.in b/configure.in
> index a792b2f..cd0c299 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -263,6 +263,12 @@ OCFS2_CHECK_KERNEL([MNT_RELATIME in mount.h], mount.h,
>    , relatime_compat_header="relatime.h", [^#define MNT_RELATIME])
>  KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $relatime_compat_header"
>  
> +NO_SHOULD_REMOVE_SUID=
> +OCFS2_CHECK_KERNEL([should_remove_suid() in fs.h], fs.h,
> +  , NO_SHOULD_REMOVE_SUID=yes, [should_remove_suid()])
> +AC_SUBST(NO_SHOULD_REMOVE_SUID)
> +KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS should_remove_suid.h"
> +
>  # using -include has two advantages:
>  #  the source doesn't need to know to include compat headers
>  #  the compat header file names don't go through the search path
> diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
> index 58be004..cecd610 100644
> --- a/fs/ocfs2/Makefile
> +++ b/fs/ocfs2/Makefile
> @@ -57,6 +57,10 @@ ifdef NO_SPLICE_HEADER
>  EXTRA_CFLAGS += -DNO_SPLICE_HEADER
>  endif
>  
> +ifdef NO_SHOULD_REMOVE_SUID
> +CFLAGS_file.o += -DNO_SHOULD_REMOVE_SUID
> +endif
> +
>  #
>  # Since SUBDIRS means something to kbuild, define them safely.  Do not
>  # include trailing slashes.
> diff --git a/kapi-compat/include/should_remove_suid.h b/kapi-compat/include/should_remove_suid.h
> new file mode 100644
> index 0000000..4c9e598
> --- /dev/null
> +++ b/kapi-compat/include/should_remove_suid.h
> @@ -0,0 +1,37 @@
> +#ifndef KAP_SHOULD_REMOVE_SUID_H
> +#define KAP_SHOULD_REMOVE_SUID_H
> +
> +#ifdef NO_SHOULD_REMOVE_SUID
> +
> +#include <linux/fs.h>
> +
> +/*
> + * The logic we want is
> + *
> + *	if suid or (sgid and xgrp)
> + *		remove privs
> + */
> +int should_remove_suid(struct dentry *dentry)

Why not just make this should be static inline and include it if generally
needed?
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
