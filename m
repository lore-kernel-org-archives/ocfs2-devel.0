From: Larry Chen <lchen@suse.com>
Date: Thu, 30 Aug 2018 10:40:51 +0800
Subject: [Ocfs2-devel] [PATCH] fix crash on
 ocfs2_duplicate_clusters_by_page
In-Reply-To: <HK0PR06MB256142B68441A3513747DCFAD5080@HK0PR06MB2561.apcprd06.prod.outlook.com>
References: <20180829074740.9438-1-lchen@suse.com>
	<20180829152533.431fd4972ae046943cabc2e3@linux-foundation.org>
	<HK0PR06MB256142B68441A3513747DCFAD5080@HK0PR06MB2561.apcprd06.prod.outlook.com>
Message-ID: <28aec268-2b1d-9763-1909-4f9db2e46f4e@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Changwei Ge <gechangwei@live.cn>, Andrew Morton <akpm@linux-foundation.org>
Cc: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi Andrew and Changwei,

Thanks for your review, I'll propose a new version with comments corrected.

Thanks,
Larry
On 08/30/2018 10:29 AM, Changwei Ge wrote:
> Hi Larry,
> 
> Besides Andrew's comments, other parts of this patch look good to me.
> 
> Thanks,
> 
> Changwei
> 
> 
> On 2018/8/30 6:25, Andrew Morton wrote:
>> On Wed, 29 Aug 2018 15:47:40 +0800 Larry Chen <lchen@suse.com> wrote:
>>
>>> ocfs2_duplicate_clusters_by_page may crash if one of extent's pages is dirty.
>>> When a page has not been written back, it is still in dirty state. If
>>> ocfs2_duplicate_clusters_by_page is called against the
>>> dirty page, the crash happens.
>>>
>>> To fix this bug, we can just unlock the page and wait the page until
>>> it's not dirty.
>>>
>>> The following is the buck trace dump:
>>>
>>> kernel BUG at /root/code/ocfs2/refcounttree.c:2961!
>>> [exception RIP: ocfs2_duplicate_clusters_by_page+822]
>>> __ocfs2_move_extent+0x80/0x450 [ocfs2]
>>> ? __ocfs2_claim_clusters+0x130/0x250 [ocfs2]
>>> ocfs2_defrag_extent+0x5b8/0x5e0 [ocfs2]
>>> __ocfs2_move_extents_range+0x2a4/0x470 [ocfs2]
>>> ocfs2_move_extents+0x180/0x3b0 [ocfs2]
>>> ? ocfs2_wait_for_recovery+0x13/0x70 [ocfs2]
>>> ocfs2_ioctl_move_extents+0x133/0x2d0 [ocfs2]
>>> ocfs2_ioctl+0x253/0x640 [ocfs2]
>>> do_vfs_ioctl+0x90/0x5f0
>>> SyS_ioctl+0x74/0x80
>>> do_syscall_64+0x74/0x140
>>> entry_SYSCALL_64_after_hwframe+0x3d/0xa2
>>>
>>> --- a/fs/ocfs2/refcounttree.c
>>> +++ b/fs/ocfs2/refcounttree.c
>>> @@ -2946,6 +2946,7 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>>>    		if (map_end & (PAGE_SIZE - 1))
>>>    			to = map_end & (PAGE_SIZE - 1);
>>>    
>>> +retry:
>>>    		page = find_or_create_page(mapping, page_index, GFP_NOFS);
>>>    		if (!page) {
>>>    			ret = -ENOMEM;
>>> @@ -2957,8 +2958,15 @@ int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>>>    		 * In case PAGE_SIZE <= CLUSTER_SIZE, This page
>>>    		 * can't be dirtied before we CoW it out.
>>>    		 */
>> Looks sane, but the below change shows that the above comment is
>> untrue.  Can we please update the comment as well?
>>
>>
>>> -		if (PAGE_SIZE <= OCFS2_SB(sb)->s_clustersize)
>>> -			BUG_ON(PageDirty(page));
>>> +		if (PAGE_SIZE <= OCFS2_SB(sb)->s_clustersize) {
>>> +			if (PageDirty(page)) {
>>> +				/*
>>> +				 * write_on_page will unlock the page on return
>>> +				 */
>>> +				ret = write_one_page(page);
>>> +				goto retry;
>>> +			}
>>> +		}
>>>    
>>>    		if (!PageUptodate(page)) {
>>>    			ret = block_read_full_page(page, ocfs2_get_block);
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
