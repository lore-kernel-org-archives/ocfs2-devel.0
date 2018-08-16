From: Changwei Ge <gechangwei@live.cn>
Date: Thu, 16 Aug 2018 11:43:46 +0000
Subject: [Ocfs2-devel] [PATCH] fix crash on
 ocfs2_duplicate_clusters_by_page
In-Reply-To: <20180816112426.12218-1-lchen@suse.com>
References: <20180816112426.12218-1-lchen@suse.com>
Message-ID: <HK0PR06MB25611B846516928348EF7AD5D53E0@HK0PR06MB2561.apcprd06.prod.outlook.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Larry,

Do you have a method to reproduce this issue?

I would be nice that such a method is provided :-)


On 2018/8/16 19:24, Larry Chen wrote:
> ocfs2_duplicate_clusters_by_page may crash if an extent's page is dirty.
> When a page has not been written back, it is still in dirty state. If at
> that moment, ocfs2_duplicate_clusters_by_page is called against this
> page, the crash happens.
>
> To fix this bug, we can just unlock the page and wait the page until
> it's not dirty.
>
> I don't know whether the patch is appropriate, so I need comments,
> thanks.
>
> The following is the core dump:
>
> kernel BUG at /root/code/ocfs2/refcounttree.c:2961!
> __ocfs2_move_extent+0x80/0x450 [ocfs2]

Because we may work on different base of git tree.
Can you paste in what function the crash occurs?
I guess you might miss something with your backtrace. Function 
__ocfs2_move_extent shouldn't be in
file refcounttree.c

Thanks,
Changwei

> ? __ocfs2_claim_clusters+0x130/0x250 [ocfs2]
> ocfs2_defrag_extent+0x5b8/0x5e0 [ocfs2]
> __ocfs2_move_extents_range+0x2a4/0x470 [ocfs2]
> ocfs2_move_extents+0x180/0x3b0 [ocfs2]
> ? ocfs2_wait_for_recovery+0x13/0x70 [ocfs2]
> ocfs2_ioctl_move_extents+0x133/0x2d0 [ocfs2]
> ocfs2_ioctl+0x253/0x640 [ocfs2]
> do_vfs_ioctl+0x90/0x5f0
> SyS_ioctl+0x74/0x80
> do_syscall_64+0x74/0x140
> entry_SYSCALL_64_after_hwframe+0x3d/0xa2
>
> To: mfasheh at versity.com,
>      jlbec at evilplan.org
> Cc: linux-kernel at vger.kernel.org,
>      ocfs2-devel at oss.oracle.com,
>      akpm at linux-foundation.org
>
> Signed-off-by: Larry Chen <lchen@suse.com>
> ---
>   fs/ocfs2/refcounttree.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
> index 7869622af22a..ee3b9dbbc310 100644
> --- a/fs/ocfs2/refcounttree.c
> +++ b/fs/ocfs2/refcounttree.c
> @@ -2946,6 +2946,7 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>   		if (map_end & (PAGE_SIZE - 1))
>   			to = map_end & (PAGE_SIZE - 1);
>   
> +retry:
>   		page = find_or_create_page(mapping, page_index, GFP_NOFS);
>   		if (!page) {
>   			ret = -ENOMEM;
> @@ -2957,8 +2958,13 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>   		 * In case PAGE_SIZE <= CLUSTER_SIZE, This page
>   		 * can't be dirtied before we CoW it out.
>   		 */
> -		if (PAGE_SIZE <= OCFS2_SB(sb)->s_clustersize)
> -			BUG_ON(PageDirty(page));
> +		if (PAGE_SIZE <= OCFS2_SB(sb)->s_clustersize) {
> +			if (PageDirty(page)) {
> +				unlock_page(page);
> +				cond_resched();
> +				goto retry;
> +			}
> +		}
>   
>   		if (!PageUptodate(page)) {
>   			ret = block_read_full_page(page, ocfs2_get_block);
