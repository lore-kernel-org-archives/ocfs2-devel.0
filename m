From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri Dec 21 12:00:00 2007
Subject: [Ocfs2-devel] [PATCH 16/30] ocfs2: Handle su_mutex in struct
	configfs_subsystem
In-Reply-To: <1198193387-16606-15-git-send-email-sunil.mushran@oracle.com>
References: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
	<1198193387-16606-15-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20071221195959.GK13171@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 20, 2007 at 03:29:33PM -0800, Sunil Mushran wrote:
> Commit e6bd07aee739566803425acdbf5cdb29919164e1 in mainline changed a
> semaphore into a mutex in struct configfs_subsystem. This patch allows
> building ocfs2 with kernels having/not having this change.

	The define is reversed.  Also, since this is specific to this
particular place, maybe we call it "init_su_mutex()" instead of
"kapi_init_mutex()"?

Joel

> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  Config.make.in                 |    1 +
>  Makefile                       |    3 ++-
>  configure.in                   |    6 ++++++
>  fs/ocfs2/cluster/Makefile      |    4 ++++
>  fs/ocfs2/cluster/nodemanager.c |    2 +-
>  kapi-compat/include/su_mutex.h |   13 +++++++++++++
>  6 files changed, 27 insertions(+), 2 deletions(-)
>  create mode 100644 kapi-compat/include/su_mutex.h
> 
> diff --git a/Config.make.in b/Config.make.in
> index eb8671d..b7bd06b 100644
> --- a/Config.make.in
> +++ b/Config.make.in
> @@ -63,6 +63,7 @@ HAS_SYNC_MAPPING_RANGE  = @HAS_SYNC_MAPPING_RANGE@
>  HAS_F_PATH_DEFINED = @HAS_F_PATH_DEFINED@
>  KMEM_CACHE_CREATE_DTOR = @KMEM_CACHE_CREATE_DTOR@
>  REGISTER_SYSCTL_TWO_ARGS = @REGISTER_SYSCTL_TWO_ARGS@
> +SU_MUTEX_DEFINED = @SU_MUTEX_DEFINED@
>  
>  OCFS_DEBUG = @OCFS_DEBUG@
>  
> diff --git a/Makefile b/Makefile
> index a9bfccb..9848c47 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -20,7 +20,8 @@ KAPI_COMPAT_FILES = \
>  	kapi-compat/include/fstype.h \
>  	kapi-compat/include/sysctl.h \
>  	kapi-compat/include/configfs.h \
> -	kapi-compat/include/register_sysctl.h
> +	kapi-compat/include/register_sysctl.h \
> +	kapi-compat/include/su_mutex.h
>  
>  PATCH_FILES =
>  
> diff --git a/configure.in b/configure.in
> index 04db94f..3d3c5da 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -225,6 +225,12 @@ OCFS2_CHECK_KERNEL([register_sysctl() with two args in sysctl.h], sysctl.h,
>  AC_SUBST(REGISTER_SYSCTL_TWO_ARGS)
>  KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS register_sysctl.h"
>  
> +SU_MUTEX_DEFINED=
> +OCFS2_CHECK_KERNEL([su_mutex in struct configfs_subsystem in configfs.h], configfs.h,
> +  SU_MUTEX_DEFINED=yes, , [su_mutex])
> +AC_SUBST(SU_MUTEX_DEFINED)
> +KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS su_mutex.h"
> +
>  # using -include has two advantages:
>  #  the source doesn't need to know to include compat headers
>  #  the compat header file names don't go through the search path
> diff --git a/fs/ocfs2/cluster/Makefile b/fs/ocfs2/cluster/Makefile
> index 6c2f11b..1e69fef 100644
> --- a/fs/ocfs2/cluster/Makefile
> +++ b/fs/ocfs2/cluster/Makefile
> @@ -21,6 +21,10 @@ ifdef REGISTER_SYSCTL_TWO_ARGS
>  EXTRA_CFLAGS += -DREGISTER_SYSCTL_TWO_ARGS
>  endif
>  
> +ifdef SU_MUTEX_DEFINED
> +EXTRA_CFLAGS += -DSU_MUTEX_DEFINED
> +endif
> +
>  SOURCES =			\
>  	heartbeat.c		\
>  	masklog.c		\
> diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
> index 9fff881..ca142d0 100644
> --- a/fs/ocfs2/cluster/nodemanager.c
> +++ b/fs/ocfs2/cluster/nodemanager.c
> @@ -974,7 +974,7 @@ static int __init init_o2nm(void)
>  		goto out_sysctl;
>  
>  	config_group_init(&o2nm_cluster_group.cs_subsys.su_group);
> -	mutex_init(&o2nm_cluster_group.cs_subsys.su_mutex);
> +	kapi_mutex_init(&o2nm_cluster_group.cs_subsys.su_mutex);
>  	ret = configfs_register_subsystem(&o2nm_cluster_group.cs_subsys);
>  	if (ret) {
>  		printk(KERN_ERR "nodemanager: Registration returned %d\n", ret);
> diff --git a/kapi-compat/include/su_mutex.h b/kapi-compat/include/su_mutex.h
> new file mode 100644
> index 0000000..1e633ed
> --- /dev/null
> +++ b/kapi-compat/include/su_mutex.h
> @@ -0,0 +1,13 @@
> +#ifndef KAPI_SUMUTEX_H
> +#define KAPI_SUMUTEX_H
> +
> +#ifdef SU_MUTEX_DEFINED
> +# define kapi_mutex_init	mutex_init
> +# define su_mutex		su_mutex
> +#else
> +# include "asm/semaphore.h"
> +# define kapi_mutex_init	init_MUTEX
> +# define su_mutex		su_sem
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

"Well-timed silence hath more eloquence than speech."  
         - Martin Fraquhar Tupper

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
