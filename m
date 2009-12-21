From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 21 Dec 2009 14:37:15 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/trivial: Add default mask log for
 heartbeat.c
In-Reply-To: <1261375896-11322-1-git-send-email-tao.ma@oracle.com>
References: <1261375896-11322-1-git-send-email-tao.ma@oracle.com>
Message-ID: <4B2FF89B.3040101@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Maybe better if we changed the two mlog(0,... to mlog(ML_HEARTBEAT,...

Now I don't know why we don't have a default mask in that file but instead
have distinct mlogs for HEARTBEAT and HB_BIO. One reason could have been to
limit the logging of hb_bio. If that is correct, then adding a default mask
will defeat the purpose.

Tao Ma wrote:
> I just noticed today that we have no default mask
> prefix for fs/ocfs2/cluster/heartbeat.c, but we have
> 2 places that use "mlog(0,...)". So add the default
> prefix so that these "mlog(0, ...)" can work.
>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/cluster/heartbeat.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
> index c452d11..edec9bf 100644
> --- a/fs/ocfs2/cluster/heartbeat.c
> +++ b/fs/ocfs2/cluster/heartbeat.c
> @@ -40,6 +40,7 @@
>  #include "nodemanager.h"
>  #include "quorum.h"
>  
> +#define MLOG_MASK_PREFIX ML_HEARTBEAT
>  #include "masklog.h"
>  
>  
>   
