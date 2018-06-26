From: Changwei Ge <gechangwei@live.cn>
Date: Tue, 26 Jun 2018 00:49:59 +0000
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: Fix locking for res->tracking
 and dlm->tracking_list
In-Reply-To: <1529951192-4686-1-git-send-email-ashish.samant@oracle.com>
References: <1529951192-4686-1-git-send-email-ashish.samant@oracle.com>
Message-ID: <HK0PR06MB2532F265F44472AABB3B8E7DD5490@HK0PR06MB2532.apcprd06.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Looks good to me.


On 2018/6/26 2:26, Ashish Samant wrote:
> In dlm_init_lockres() we access and modify res->tracking and
> dlm->tracking_list without holding dlm->track_lock. This can cause list
> corruptions and can end up in kernel panic.
>
> Fix this by locking res->tracking and dlm->tracking_list with
> dlm->track_lock instead of dlm->spinlock.
Reviewed-by: Changwei Ge <ge.changwei@h3c.com>
> Signed-off-by: Ashish Samant <ashish.samant@oracle.com>
> CC: stable at vger.kernel.org
> ---
>   fs/ocfs2/dlm/dlmmaster.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index aaca094..826f056 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -584,9 +584,9 @@ static void dlm_init_lockres(struct dlm_ctxt *dlm,
>   
>   	res->last_used = 0;
>   
> -	spin_lock(&dlm->spinlock);
> +	spin_lock(&dlm->track_lock);
>   	list_add_tail(&res->tracking, &dlm->tracking_list);
> -	spin_unlock(&dlm->spinlock);
> +	spin_unlock(&dlm->track_lock);
>   
>   	memset(res->lvb, 0, DLM_LVB_LEN);
>   	memset(res->refmap, 0, sizeof(res->refmap));
