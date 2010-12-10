From: tm at tao.ma <tm@tao.ma>
Date: Thu, 9 Dec 2010 20:53:59 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Adjust masklog flag values
In-Reply-To: <1291947638-12365-1-git-send-email-sunil.mushran@oracle.com>
References: <1291947638-12365-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <c3451d2836eb588144df06e0a5d6a956.squirrel@mail.tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Sunil,
   Just FYI. I am working on replace mlog with trace events(yes, I am
still working on this after my leave from Oracle) and will send out the
patches soon, maybe next week(I hope so), so most of the flags I used
frequently will be removed so that this won't be a problem any more.

Regards,
Tao
> Two masklogs had the same flag value.
>
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
> ---
>  fs/ocfs2/cluster/masklog.c |    3 ++-
>  fs/ocfs2/cluster/masklog.h |   15 ++++++++-------
>  2 files changed, 10 insertions(+), 8 deletions(-)
>
> diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
> index c7fba39..6c61771 100644
> --- a/fs/ocfs2/cluster/masklog.c
> +++ b/fs/ocfs2/cluster/masklog.c
> @@ -113,10 +113,11 @@ static struct mlog_attribute
> mlog_attrs[MLOG_MAX_BITS] = {
>  	define_mask(QUOTA),
>  	define_mask(REFCOUNT),
>  	define_mask(BASTS),
> +	define_mask(RESERVATIONS),
> +	define_mask(CLUSTER),
>  	define_mask(ERROR),
>  	define_mask(NOTICE),
>  	define_mask(KTHREAD),
> -	define_mask(RESERVATIONS),
>  };
>
>  static struct attribute *mlog_attr_ptrs[MLOG_MAX_BITS] = {NULL, };
> diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
> index ea2ed9f..34d6544 100644
> --- a/fs/ocfs2/cluster/masklog.h
> +++ b/fs/ocfs2/cluster/masklog.h
> @@ -81,7 +81,7 @@
>  #include <linux/sched.h>
>
>  /* bits that are frequently given and infrequently matched in the low
> word */
> -/* NOTE: If you add a flag, you need to also update mlog.c! */
> +/* NOTE: If you add a flag, you need to also update masklog.c! */
>  #define ML_ENTRY	0x0000000000000001ULL /* func call entry */
>  #define ML_EXIT		0x0000000000000002ULL /* func call exit */
>  #define ML_TCP		0x0000000000000004ULL /* net cluster/tcp.c */
> @@ -114,13 +114,14 @@
>  #define ML_XATTR	0x0000000020000000ULL /* ocfs2 extended attributes */
>  #define ML_QUOTA	0x0000000040000000ULL /* ocfs2 quota operations */
>  #define ML_REFCOUNT	0x0000000080000000ULL /* refcount tree operations */
> -#define ML_BASTS	0x0000001000000000ULL /* dlmglue asts and basts */
> +#define ML_BASTS	0x0000000100000000ULL /* dlmglue asts and basts */
> +#define ML_RESERVATIONS	0x0000000200000000ULL /* ocfs2 alloc reservations
> */
> +#define ML_CLUSTER	0x0000000400000000ULL /* cluster stack */
> +
>  /* bits that are infrequently given and frequently matched in the high
> word */
> -#define ML_ERROR	0x0000000100000000ULL /* sent to KERN_ERR */
> -#define ML_NOTICE	0x0000000200000000ULL /* setn to KERN_NOTICE */
> -#define ML_KTHREAD	0x0000000400000000ULL /* kernel thread activity */
> -#define ML_RESERVATIONS	0x0000000800000000ULL /* ocfs2 alloc reservations
> */
> -#define ML_CLUSTER	0x0000001000000000ULL /* cluster stack */
> +#define ML_ERROR	0x1000000000000000ULL /* sent to KERN_ERR */
> +#define ML_NOTICE	0x2000000000000000ULL /* setn to KERN_NOTICE */
> +#define ML_KTHREAD	0x4000000000000000ULL /* kernel thread activity */
>
>  #define MLOG_INITIAL_AND_MASK (ML_ERROR|ML_NOTICE)
>  #define MLOG_INITIAL_NOT_MASK (ML_ENTRY|ML_EXIT)
> --
> 1.7.1
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
