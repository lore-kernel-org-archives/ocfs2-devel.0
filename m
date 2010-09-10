From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 10 Sep 2010 16:40:17 -0700
Subject: [Ocfs2-devel] [PATCH 4/5] ocfs2/dlm: copy lvb from lksb only
 when it's meaningful
In-Reply-To: <201008261310.o7PHoc65015692@acsinet15.oracle.com>
References: <201008261310.o7PHoc65015692@acsinet15.oracle.com>
Message-ID: <4C8AC1E1.2010807@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 08/26/2010 06:07 AM, Wengang Wang wrote:
> Copies lvb from lksb only when it's meaningful(not NULL).
>
> Signed-off-by: Wengang Wang<wen.gang.wang@oracle.com>
> ---
>   fs/ocfs2/dlm/dlmrecovery.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index fa6e5ae..6d2e3ca 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -1184,7 +1184,8 @@ static void dlm_prepare_lvb_for_migration(struct dlm_lock *lock,
>   		return;
>
>   	if (dlm_lvb_is_empty(mres->lvb)) {
> -		memcpy(mres->lvb, lock->lksb->lvb, DLM_LVB_LEN);
> +		if (lock->lksb->lvb)
> +			memcpy(mres->lvb, lock->lksb->lvb, DLM_LVB_LEN);
>   		return;
>   	}
>
>    

Patches 3 and 4 can be merged.

Also, in prepare_lvb_for_migration, we should use the name to determine
whether the locks should have lvb or not. If not, then just exit. If 
they do,
then BUG.
