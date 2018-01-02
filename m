From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 2 Jan 2018 16:17:26 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: try to reuse extent block in
 dealloc without meta_alloc
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373F290988E@H3CMLB12-EX.srv.huawei-3com.com>
References: <63ADC13FD55D6546B7DECE290D39E373F2908FC7@H3CMLB12-EX.srv.huawei-3com.com>
	<be127091-f971-57b9-f488-681149f1d58a@oracle.com>
	<63ADC13FD55D6546B7DECE290D39E373F290988E@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <72982904-5152-bbcd-c751-3e2ac8fca16d@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 12/27/2017 08:21 PM, Changwei Ge wrote:
> Hi Junxiao,
> 
> On 2017/12/27 18:02, Junxiao Bi wrote:
>> Hi Changwei,
>>
>>
>> On 12/26/2017 03:55 PM, Changwei Ge wrote:
>>> A crash issue was reported by John.
>>> The call trace follows:
>>> ocfs2_split_extent+0x1ad3/0x1b40 [ocfs2]
>>> ocfs2_change_extent_flag+0x33a/0x470 [ocfs2]
>>> ocfs2_mark_extent_written+0x172/0x220 [ocfs2]
>>> ocfs2_dio_end_io+0x62d/0x910 [ocfs2]
>>> dio_complete+0x19a/0x1a0
>>> do_blockdev_direct_IO+0x19dd/0x1eb0
>>> __blockdev_direct_IO+0x43/0x50
>>> ocfs2_direct_IO+0x8f/0xa0 [ocfs2]
>>> generic_file_direct_write+0xb2/0x170
>>> __generic_file_write_iter+0xc3/0x1b0
>>> ocfs2_file_write_iter+0x4bb/0xca0 [ocfs2]
>>> __vfs_write+0xae/0xf0
>>> vfs_write+0xb8/0x1b0
>>> SyS_write+0x4f/0xb0
>>> system_call_fastpath+0x16/0x75
>>>
>>> The BUG code told that extent tree wants to grow but no metadata
>>> was reserved ahead of time.
>>>    From my investigation into this issue, the root cause it that although
>>> enough metadata is not reserved, there should be enough for following use.
>>> Rightmost extent is merged into its left one due to a certain times of
>>> marking extent written. Because during marking extent written, we got many
>>> physically continuous extents. At last, an empty extent showed up and the
>>> rightmost path is removed from extent tree.
>> I am trying to understand the issue. Quick questions.
>> Is this issue caused by BUG_ON(meta_ac == NULL)? Can you explain why it
>> is NULL?
> My pleasure to.
> Before marking extents written, we have to estimate how many metadata will be used.
> If there are enough metadata for following operation-marking extent written, no metadata
> will be reserved ahead of time.
> 
> For this BUG scenario, it happens that extent tree already has enough free metadata.
> This can be referred by code path:
> ocfs2_dio_end_io_write
>    ocfs2_lock_allocators - No need to reserve metadata,since extent tree already has more metadata than needed. So *mata_ac* is NULL.
>    ocfs2_mark_extent_written
>      ocfs2_change_extent_flag - cluster by cluster
>        ocfs2_split_extent
>          ocfs2_try_to_merge_extent - During filling file hole, we mark cluster as written one by one. Somehow, we merge those physically continuous cluster(WRITTEN) into a single one.
>            ocfs2_rotate_tree_left - rotate extent
>              __ocfs2_rotate_tree_left
>                ocfs2_rotate_subtree_left - Aha, we find a totally empty extent here, so unlink it from extent tree.
>                  ocfs2_unlink_subtree
>                  ocfs2_remove_empty_extent
>                  
> 
> Then, since we delete one extent block, our previously estimated metadata number is
> pointless(NOTE, actually the estimation is accurate.). Since it is reduced resulted by extent
> rotation and merging.
> So for now, we don't have enough metadata.
See, thanks for your detailed explanation.

> 
> Then we are still marking extent tree written for left clusters and we need to split extent.
Once one ocfs2_mark_extent_written() caused an extent block removed,
then next invoke to it may not have enought metadata, right?

> But we don't have enough metadata to accommodate the split extent records.
If above is right, can we invoke ocfs2_lock_allocators() to calculate
enough metadata before every invoke to ocfs2_mark_extent_written()?
That will be more simple than fixing by reuse dealloc.

Thanks,
Junxiao.

> So extent tree need to grow.
> BUG. no metadata is reserved ahead of time.
> 
> Thanks,
> Changwei
>            
> 
