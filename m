From: Joseph Qi <jiangqi903@gmail.com>
Date: Mon, 23 Oct 2017 11:51:28 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix cluster hang after a node dies
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373CED6E0F9@H3CMLB14-EX.srv.huawei-3com.com>
References: <63ADC13FD55D6546B7DECE290D39E373CED6E0F9@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <68f067fd-ec2b-869a-67bb-562f15e0ad32@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Changwei Ge <ge.changwei@h3c.com>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, Mark Fasheh <mfasheh@versity.com>, Junxiao Bi <junxiao.bi@oracle.com>, Joel Becker <jlbec@evilplan.org>
Cc: Vitaly Mayatskih <v.mayatskih@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>



On 17/10/17 14:48, Changwei Ge wrote:
> When a node dies, other live nodes have to choose a new master
> for an existed lock resource mastered by the dead node.
> 
> As for ocfs2/dlm implementation, this is done by function -
> dlm_move_lockres_to_recovery_list which marks those lock rsources
> as DLM_LOCK_RES_RECOVERING and manages them via a list from which
> DLM changes lock resource's master later.
> 
> So without invoking dlm_move_lockres_to_recovery_list, no master will
> be choosed after dlm recovery accomplishment since no lock resource can
> be found through ::resource list.
> 
> What's worse is that if DLM_LOCK_RES_RECOVERING is not marked for
> lock resources mastered a dead node, it will break up synchronization
> among nodes.
> 
> So invoke dlm_move_lockres_to_recovery_list again.
> 
> Fixs: 'commit ee8f7fcbe638 ("ocfs2/dlm: continue to purge recovery
> lockres when recovery master goes down")'
> 
A typo here, it should be:
Fixes: ee8f7fcbe638 ("ocfs2/dlm: continue to purge recovery lockres when recovery master goes down")
Also we'd better Cc stable as well.

Others look good to me.
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>

> Reported-by: Vitaly Mayatskih <v.mayatskih@gmail.com>
> Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
> ---
>   fs/ocfs2/dlm/dlmrecovery.c |    1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index 74407c6..ec8f758 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -2419,6 +2419,7 @@ static void dlm_do_local_recovery_cleanup(struct 
> dlm_ctxt *dlm, u8 dead_node)
>   					dlm_lockres_put(res);
>   					continue;
>   				}
> +				dlm_move_lockres_to_recovery_list(dlm, res);
>   			} else if (res->owner == dlm->node_num) {
>   				dlm_free_dead_locks(dlm, res, dead_node);
>   				__dlm_lockres_calc_usage(dlm, res);
> 
