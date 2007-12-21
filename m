From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri Dec 21 11:59:58 2007
Subject: [Ocfs2-devel] [PATCH 15/30] ocfs2: Handle different prototypes
	of register_sysctl_table()
In-Reply-To: <1198193387-16606-14-git-send-email-sunil.mushran@oracle.com>
References: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
	<1198193387-16606-14-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20071221195822.GJ13171@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 20, 2007 at 03:29:32PM -0800, Sunil Mushran wrote:
> Commit 0b4d414714f0d2f922d39424b0c5c82ad900a381 in mainline removes the
> insert_at_head argument from register_sysctl_table(). This patch allows
> building ocfs2 with kernels having/not having this change.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

Signed-off-by: Joel Becker <joel.becker@oracle.com>

> ---
>  Config.make.in                        |    1 +
>  Makefile                              |    3 ++-
>  configure.in                          |    6 ++++++
>  fs/ocfs2/cluster/Makefile             |    4 ++++
>  fs/ocfs2/cluster/nodemanager.c        |    2 +-
>  kapi-compat/include/register_sysctl.h |   10 ++++++++++
>  6 files changed, 24 insertions(+), 2 deletions(-)
>  create mode 100644 kapi-compat/include/register_sysctl.h
> 
> diff --git a/Config.make.in b/Config.make.in
> index 07c5a86..eb8671d 100644
> --- a/Config.make.in
> +++ b/Config.make.in
> @@ -62,6 +62,7 @@ DELAYED_WORK_DEFINED = @DELAYED_WORK_DEFINED@
>  HAS_SYNC_MAPPING_RANGE  = @HAS_SYNC_MAPPING_RANGE@
>  HAS_F_PATH_DEFINED = @HAS_F_PATH_DEFINED@
>  KMEM_CACHE_CREATE_DTOR = @KMEM_CACHE_CREATE_DTOR@
> +REGISTER_SYSCTL_TWO_ARGS = @REGISTER_SYSCTL_TWO_ARGS@
>  
>  OCFS_DEBUG = @OCFS_DEBUG@
>  
> diff --git a/Makefile b/Makefile
> index 71cd3c7..a9bfccb 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -19,7 +19,8 @@ KAPI_COMPAT_FILES = \
>  	kapi-compat/include/slab.h \
>  	kapi-compat/include/fstype.h \
>  	kapi-compat/include/sysctl.h \
> -	kapi-compat/include/configfs.h
> +	kapi-compat/include/configfs.h \
> +	kapi-compat/include/register_sysctl.h
>  
>  PATCH_FILES =
>  
> diff --git a/configure.in b/configure.in
> index 513585f..04db94f 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -219,6 +219,12 @@ OCFS2_CHECK_KERNEL([configfs_depend_item() in configfs.h], configfs.h,
>    , configfs_compat_header="configfs.h", [configfs_depend_item()])
>  KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $configfs_compat_header"
>  
> +REGISTER_SYSCTL_TWO_ARGS=
> +OCFS2_CHECK_KERNEL([register_sysctl() with two args in sysctl.h], sysctl.h,
> +  REGISTER_SYSCTL_TWO_ARGS=yes, , [^.*int insert_at_head);])
> +AC_SUBST(REGISTER_SYSCTL_TWO_ARGS)
> +KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS register_sysctl.h"
> +
>  # using -include has two advantages:
>  #  the source doesn't need to know to include compat headers
>  #  the compat header file names don't go through the search path
> diff --git a/fs/ocfs2/cluster/Makefile b/fs/ocfs2/cluster/Makefile
> index a4251f5..6c2f11b 100644
> --- a/fs/ocfs2/cluster/Makefile
> +++ b/fs/ocfs2/cluster/Makefile
> @@ -17,6 +17,10 @@ ifdef DELAYED_WORK_DEFINED
>  EXTRA_CFLAGS += -DDELAYED_WORK_DEFINED
>  endif
>  
> +ifdef REGISTER_SYSCTL_TWO_ARGS
> +EXTRA_CFLAGS += -DREGISTER_SYSCTL_TWO_ARGS
> +endif
> +
>  SOURCES =			\
>  	heartbeat.c		\
>  	masklog.c		\
> diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
> index af2070d..9fff881 100644
> --- a/fs/ocfs2/cluster/nodemanager.c
> +++ b/fs/ocfs2/cluster/nodemanager.c
> @@ -962,7 +962,7 @@ static int __init init_o2nm(void)
>  	o2hb_init();
>  	o2net_init();
>  
> -	ocfs2_table_header = register_sysctl_table(ocfs2_root_table);
> +	ocfs2_table_header = kapi_register_sysctl_table(ocfs2_root_table);
>  	if (!ocfs2_table_header) {
>  		printk(KERN_ERR "nodemanager: unable to register sysctl\n");
>  		ret = -ENOMEM; /* or something. */
> diff --git a/kapi-compat/include/register_sysctl.h b/kapi-compat/include/register_sysctl.h
> new file mode 100644
> index 0000000..94e8071
> --- /dev/null
> +++ b/kapi-compat/include/register_sysctl.h
> @@ -0,0 +1,10 @@
> +#ifndef KAPI_REGISTER_SYSCTL_H
> +#define KAPI_REGISTER_SYSCTL_H
> +
> +#ifdef REGISTER_SYSCTL_TWO_ARGS
> +#define kapi_register_sysctl_table(a)	register_sysctl_table(a, 0)
> +#else
> +#define kapi_register_sysctl_table(a)	register_sysctl_table(a)
> +#endif
> +
> +#endif
> -- 
> 1.5.2.5
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 

"I'm drifting and drifting
 Just like a ship out on the sea.
 Cause I ain't got nobody, baby,
 In this world to care for me."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
