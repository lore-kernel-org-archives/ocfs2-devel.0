From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Tue, 13 Aug 2019 08:52:10 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: The function
 ocfs2_orphan_scan_exit is declared, but not implemented and called,
 so as to be removed.
In-Reply-To: <71604351584F6A4EBAE558C676F37CA4014FC208AC@H3CMLB12-EX.srv.huawei-3com.com>
References: <71604351584F6A4EBAE558C676F37CA4014FC208AC@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <7c9d5054-7dcd-b6ea-8c63-8f140e8cc4b4@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

On 19/8/12 19:06, Guozhonghua wrote:
> ocfs2: The function ocfs2_orphan_scan_exit is declared, but not implemented and called, so as to be removed.
Please split subject and description clearly when submitting a patch.

> Add two space before and after the character *. 
I don't think this is related with the patch title. 
Or we can named the patch as "ocfs2: code cleanup for ocfs2/journal.h",
and then in the description:
remove unused ocfs2_orphan_scan_exit() declaration;
adjust code format in ocfs2_link_credits().

Thanks,
Joseph

> 
> Signed-off-by: guozhonghua <guozhonghua@h3c.com>
> 
> ---
>  fs/ocfs2/journal.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
> index c0fe6ed08ab1..f1479d22e998 100644
> --- a/fs/ocfs2/journal.h
> +++ b/fs/ocfs2/journal.h
> @@ -144,7 +144,6 @@ static inline void ocfs2_ci_set_new(struct ocfs2_super *osb,
>  void ocfs2_orphan_scan_init(struct ocfs2_super *osb);
>  void ocfs2_orphan_scan_start(struct ocfs2_super *osb);
>  void ocfs2_orphan_scan_stop(struct ocfs2_super *osb);
> -void ocfs2_orphan_scan_exit(struct ocfs2_super *osb);
>  
>  void ocfs2_complete_recovery(struct work_struct *work);
>  void ocfs2_wait_for_recovery(struct ocfs2_super *osb);
> @@ -441,7 +440,7 @@ static inline int ocfs2_mknod_credits(struct super_block *sb, int is_dir,
>   * previous dirblock update in the free list */
>  static inline int ocfs2_link_credits(struct super_block *sb)
>  {
> -	return 2*OCFS2_INODE_UPDATE_CREDITS + 4 +
> +	return 2 * OCFS2_INODE_UPDATE_CREDITS + 4 +
>  	       ocfs2_quota_trans_credits(sb);
>  }
>  
> 
