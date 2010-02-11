From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 11 Feb 2010 13:12:04 -0800
Subject: [Ocfs2-devel] [PATCH 03/11] ocfs2_dlmfs: Move to its own
	directory
In-Reply-To: <1265794074-19539-4-git-send-email-joel.becker@oracle.com>
References: <1265794074-19539-1-git-send-email-joel.becker@oracle.com>
	<1265794074-19539-4-git-send-email-joel.becker@oracle.com>
Message-ID: <4B7472A4.8000807@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <joel.becker@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, mfasheh@suse.com, linux-kernel@vger.kernel.org

Acked-by: Sunil Mushran <sunil.mushran@oracle.com>

Joel Becker wrote:
> We're going to remove the tie between ocfs2_dlmfs and o2dlm.
> ocfs2_dlmfs doesn't belong in the fs/ocfs2/dlm directory anymore.  Here
> we move it to fs/ocfs2/dlmfs.
>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
> ---
>  fs/ocfs2/Makefile                  |    1 +
>  fs/ocfs2/dlm/Makefile              |    3 +--
>  fs/ocfs2/dlmfs/Makefile            |    5 +++++
>  fs/ocfs2/{dlm => dlmfs}/dlmfs.c    |    2 +-
>  fs/ocfs2/{dlm => dlmfs}/dlmfsver.c |    0
>  fs/ocfs2/{dlm => dlmfs}/dlmfsver.h |    0
>  fs/ocfs2/{dlm => dlmfs}/userdlm.c  |    2 +-
>  fs/ocfs2/{dlm => dlmfs}/userdlm.h  |    0
>  8 files changed, 9 insertions(+), 4 deletions(-)
>  create mode 100644 fs/ocfs2/dlmfs/Makefile
>  rename fs/ocfs2/{dlm => dlmfs}/dlmfs.c (99%)
>  rename fs/ocfs2/{dlm => dlmfs}/dlmfsver.c (100%)
>  rename fs/ocfs2/{dlm => dlmfs}/dlmfsver.h (100%)
>  rename fs/ocfs2/{dlm => dlmfs}/userdlm.c (99%)
>  rename fs/ocfs2/{dlm => dlmfs}/userdlm.h (100%)
>
> diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
> index 600d2d2..791c088 100644
> --- a/fs/ocfs2/Makefile
> +++ b/fs/ocfs2/Makefile
> @@ -46,6 +46,7 @@ ocfs2_stackglue-objs := stackglue.o
>  ocfs2_stack_o2cb-objs := stack_o2cb.o
>  ocfs2_stack_user-objs := stack_user.o
>  
> +obj-$(CONFIG_OCFS2_FS) += dlmfs/
>  # cluster/ is always needed when OCFS2_FS for masklog support
>  obj-$(CONFIG_OCFS2_FS) += cluster/
>  obj-$(CONFIG_OCFS2_FS_O2CB) += dlm/
> diff --git a/fs/ocfs2/dlm/Makefile b/fs/ocfs2/dlm/Makefile
> index 1903613..dcebf0d 100644
> --- a/fs/ocfs2/dlm/Makefile
> +++ b/fs/ocfs2/dlm/Makefile
> @@ -1,8 +1,7 @@
>  EXTRA_CFLAGS += -Ifs/ocfs2
>  
> -obj-$(CONFIG_OCFS2_FS_O2CB) += ocfs2_dlm.o ocfs2_dlmfs.o
> +obj-$(CONFIG_OCFS2_FS_O2CB) += ocfs2_dlm.o
>  
>  ocfs2_dlm-objs := dlmdomain.o dlmdebug.o dlmthread.o dlmrecovery.o \
>  	dlmmaster.o dlmast.o dlmconvert.o dlmlock.o dlmunlock.o dlmver.o
>  
> -ocfs2_dlmfs-objs := userdlm.o dlmfs.o dlmfsver.o
> diff --git a/fs/ocfs2/dlmfs/Makefile b/fs/ocfs2/dlmfs/Makefile
> new file mode 100644
> index 0000000..df69b48
> --- /dev/null
> +++ b/fs/ocfs2/dlmfs/Makefile
> @@ -0,0 +1,5 @@
> +EXTRA_CFLAGS += -Ifs/ocfs2
> +
> +obj-$(CONFIG_OCFS2_FS) += ocfs2_dlmfs.o
> +
> +ocfs2_dlmfs-objs := userdlm.o dlmfs.o dlmfsver.o
> diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
> similarity index 99%
> rename from fs/ocfs2/dlm/dlmfs.c
> rename to fs/ocfs2/dlmfs/dlmfs.c
> index ddf55da..e21ce0e 100644
> --- a/fs/ocfs2/dlm/dlmfs.c
> +++ b/fs/ocfs2/dlmfs/dlmfs.c
> @@ -52,7 +52,7 @@
>  #include "cluster/heartbeat.h"
>  #include "cluster/tcp.h"
>  
> -#include "dlmapi.h"
> +#include "dlm/dlmapi.h"
>  
>  #include "userdlm.h"
>  
> diff --git a/fs/ocfs2/dlm/dlmfsver.c b/fs/ocfs2/dlmfs/dlmfsver.c
> similarity index 100%
> rename from fs/ocfs2/dlm/dlmfsver.c
> rename to fs/ocfs2/dlmfs/dlmfsver.c
> diff --git a/fs/ocfs2/dlm/dlmfsver.h b/fs/ocfs2/dlmfs/dlmfsver.h
> similarity index 100%
> rename from fs/ocfs2/dlm/dlmfsver.h
> rename to fs/ocfs2/dlmfs/dlmfsver.h
> diff --git a/fs/ocfs2/dlm/userdlm.c b/fs/ocfs2/dlmfs/userdlm.c
> similarity index 99%
> rename from fs/ocfs2/dlm/userdlm.c
> rename to fs/ocfs2/dlmfs/userdlm.c
> index 4cb1d3d..6adae70 100644
> --- a/fs/ocfs2/dlm/userdlm.c
> +++ b/fs/ocfs2/dlmfs/userdlm.c
> @@ -39,7 +39,7 @@
>  #include "cluster/heartbeat.h"
>  #include "cluster/tcp.h"
>  
> -#include "dlmapi.h"
> +#include "dlm/dlmapi.h"
>  
>  #include "userdlm.h"
>  
> diff --git a/fs/ocfs2/dlm/userdlm.h b/fs/ocfs2/dlmfs/userdlm.h
> similarity index 100%
> rename from fs/ocfs2/dlm/userdlm.h
> rename to fs/ocfs2/dlmfs/userdlm.h
>   
