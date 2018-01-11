From: Changwei Ge <ge.changwei@h3c.com>
Date: Thu, 11 Jan 2018 03:00:31 +0000
Subject: [Ocfs2-devel] [PATCH v2 2/2] ocfs2: add trimfs lock to avoid
 duplicated trims in cluster
References: <1513228484-2084-1-git-send-email-ghe@suse.com>
	<1513228484-2084-2-git-send-email-ghe@suse.com>
	<63ADC13FD55D6546B7DECE290D39E373F290E6C5@H3CMLB12-EX.srv.huawei-3com.com>
	<5A5647C2020000F9000A2929@prv-mh.provo.novell.com>
	<63ADC13FD55D6546B7DECE290D39E373F290E878@H3CMLB12-EX.srv.huawei-3com.com>
	<5A5657D8020000F9000A2987@prv-mh.provo.novell.com>
	<63ADC13FD55D6546B7DECE290D39E373F290E930@H3CMLB12-EX.srv.huawei-3com.com>
	<5A57372A020000F9000A2E01@prv-mh.provo.novell.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F290EED7@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>, "jlbec@evilplan.org" <jlbec@evilplan.org>, "mfasheh@versity.com" <mfasheh@versity.com>
Cc: "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 2018/1/11 10:07, Gang He wrote:
> Hi Changwei,
> 
> 
>>>>
>> On 2018/1/10 18:14, Gang He wrote:
>>> Hi Changwei,
>>>
>>>
>>>>>>
>>>> On 2018/1/10 17:05, Gang He wrote:
>>>>> Hi Changwei,
>>>>>
>>>>>
>>>>>>>>
>>>>>> Hi Gang,
>>>>>>
>>>>>> On 2017/12/14 13:16, Gang He wrote:
>>>>>>> As you know, ocfs2 has support trim the underlying disk via
>>>>>>> fstrim command. But there is a problem, ocfs2 is a shared disk
>>>>>>> cluster file system, if the user configures a scheduled fstrim
>>>>>>> job on each file system node, this will trigger multiple nodes
>>>>>>> trim a shared disk simultaneously, it is very wasteful for CPU
>>>>>>> and IO consumption, also might negatively affect the lifetime
>>>>>>> of poor-quality SSD devices.
>>>>>>> Then, we introduce a trimfs dlm lock to communicate with each
>>>>>>> other in this case, which will make only one fstrim command to
>>>>>>> do the trimming on a shared disk among the cluster, the fstrim
>>>>>>> commands from the other nodes should wait for the first fstrim
>>>>>>> to finish and returned success directly, to avoid running a the
>>>>>>> same trim on the shared disk again.
>>>>>>>
>>>>>>> Compare with first version, I change the fstrim commands' returned
>>>>>>> value and behavior in case which meets a fstrim command is running
>>>>>>> on a shared disk.
>>>>>>>
>>>>>>> Signed-off-by: Gang He <ghe@suse.com>
>>>>>>> ---
>>>>>>>      fs/ocfs2/alloc.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
>>>>>>>      1 file changed, 44 insertions(+)
>>>>>>>
>>>>>>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>>>>>>> index ab5105f..5c9c3e2 100644
>>>>>>> --- a/fs/ocfs2/alloc.c
>>>>>>> +++ b/fs/ocfs2/alloc.c
>>>>>>> @@ -7382,6 +7382,7 @@ int ocfs2_trim_fs(struct super_block *sb, struct
>>>>>> fstrim_range *range)
>>>>>>>      	struct buffer_head *gd_bh = NULL;
>>>>>>>      	struct ocfs2_dinode *main_bm;
>>>>>>>      	struct ocfs2_group_desc *gd = NULL;
>>>>>>> +	struct ocfs2_trim_fs_info info, *pinfo = NULL;
>>>>>>
>>>>>> I think *pinfo* is not necessary.
>>>>> This pointer is necessary, since it can be NULL or non-NULL depend on the
>>>> code logic.
>>>>
>>>> This point is OK for me.
>>>>
>>>>>
>>>>>>>      
>>>>>>>      	start = range->start >> osb->s_clustersize_bits;
>>>>>>>      	len = range->len >> osb->s_clustersize_bits;
>>>>>>> @@ -7419,6 +7420,42 @@ int ocfs2_trim_fs(struct super_block *sb, struct
>>>>>> fstrim_range *range)
>>>>>>>      
>>>>>>>      	trace_ocfs2_trim_fs(start, len, minlen);
>>>>>>>      
>>>>>>> +	ocfs2_trim_fs_lock_res_init(osb);
>>>>>>> +	ret = ocfs2_trim_fs_lock(osb, NULL, 1);
>>>>>>
>>>>>> I don't get why try to lock here and if fails, acquire the same lock again
>>>>>> later but wait until granted.
>>>>> Please think about the user case, the patch is only used to handle this
>>>> case.
>>>>> When the administer configures a fstrim schedule task on each node, then
>>>> each node will trigger a fstrim on shared disks concurrently.
>>>>> In this case, we should avoid duplicated fstrim on a shared disk since this
>>>> will waste CPU/IO resources and affect SSD lifetime sometimes.
>>>>
>>>> I'm not worrying about that trimfs will affect SSD's lifetime quite a lot,
>>>> since physical-logical address converting table resides in RAM while SSD is
>>>> working.
>>>> And that table won't be at a big scale. My point here is not affecting this
>>>> patch. Just a tip here.
>>> This depend on SSD firmware implementation, but for secure-trim, it really
>> possibly affect SSD lifetime.
>>>
>>>>> Firstly, we use try_lock to get fstrim dlm lock to identify if there is any
>>>> other node which is doing fstrim on the disk.
>>>>> If not, this node is the first one, this node should do fstrim operation on
>>>> the disk.
>>>>> If yes, this node is not the first one, this node should wait until the
>>>> first node is done for fstrim operation, then return the result from DLM
>>>> lock's value.
>>>>>
>>>>>> Can it just acquire the _trimfs_ lock as a blocking one directly here?
>>>>> We can not do a blocking lock directly, since we need to identify if there
>>>> is any other node has being do fstrim operation when this node start to do
>>>> fstrim.
>>>>
>>>> Thanks for your elaboration.
>>>>
>>>> Well how about the third node trying to trimming fs too?
>>>> It needs LVB from the second node.
>>>> But it seems that the second node can't provide a valid LVB.
>>>> So the third node will perform trimfs once more.
>>> No, the second node does not change DLM lock's value, but the DLM lock's
>> value is still valid.
>>> The third node also refer to this DLM lock's value, then do the same logic
>> like the second node.
>>
>> Hi Gang,
>> I don't see any places where ocfs2_lock_res::ocfs2_lock_res_ops::set_lvb is
>> set while flag LOCK_TYPE_USES_LVB is added.
>>
>> Are you sure below code path can work well?
> Yes, have done a full testing on two and three nodes.
> 
>> ocfs2_process_blocked_lock
>>     ocfs2_unblock_lock
>>         Reference to ::set_lvb since LOCK_TYPE_USES_LVB is set.
>>
> the set_lvb callback function is not necessary, if we update DLM lock value by ourselves before unlock.

I think this may relates to *LOCK_TYPE_REQUIRES_REFRESH* flag.
Actually, I don't see why this flag is necessary to _orphan scan_.
Why can't _orphan scan_ also set LVB during ocfs2_process_blocked_lock->ocfs2_unblock_lock?

And it seems that _orphan scan_ also doesn't need to persist any stuff in LVB into disk.

Thanks,
Changwei

> By the way, the code is transparent to the underlying DLM stack (o2cb or pcmk).

True.
> 
> Thanks
> Gang
> 
>> Thanks,
>> Changwei
>>
>>>
>>>>
>>>> IOW, three nodes are trying to trimming fs concurrently. Is your patch able
>>>> to handle such a scenario?
>>> Yes, the patch can handle this case.
>>>
>>>>
>>>> Even the second lock request with QUEUE set just follows
>>>> ocfs2_trim_fs_lock_res_uninit() will not get rid of concurrent trimfs.
>>>>
>>>>>
>>>>>>
>>>>>>> +	if (ret < 0) {
>>>>>>> +		if (ret != -EAGAIN) {
>>>>>>> +			mlog_errno(ret);
>>>>>>> +			ocfs2_trim_fs_lock_res_uninit(osb);
>>>>>>> +			goto out_unlock;
>>>>>>> +		}
>>>>>>> +
>>>>>>> +		mlog(ML_NOTICE, "Wait for trim on device (%s) to "
>>>>>>> +		     "finish, which is running from another node.\n",
>>>>>>> +		     osb->dev_str);
>>>>>>> +		ret = ocfs2_trim_fs_lock(osb, &info, 0);
>>>>>>> +		if (ret < 0) {
>>>>>>> +			mlog_errno(ret);
>>>>>>> +			ocfs2_trim_fs_lock_res_uninit(osb);
>>>>>>
>>>>>> In ocfs2_trim_fs_lock_res_uninit(), you drop lock. But it is never granted.
>>>>>> Still need to drop lock resource?
>>>>> Yes, we need to init/uninit fstrim dlm lock resource for each time.
>>>>> Otherwise, trylock does not work, this is a little different from other dlm
>>>> lock usage in ocfs2.
>>>>
>>>> This point is OK for now, too.
>>>>>
>>>>>>
>>>>>>> +			goto out_unlock;
>>>>>>> +		}
>>>>>>> +
>>>>>>> +		if (info.tf_valid && info.tf_success &&
>>>>>>> +		    info.tf_start == start && info.tf_len == len &&
>>>>>>> +		    info.tf_minlen == minlen) {
>>>>>>> +			/* Avoid sending duplicated trim to a shared device */
>>>>>>> +			mlog(ML_NOTICE, "The same trim on device (%s) was "
>>>>>>> +			     "just done from node (%u), return.\n",
>>>>>>> +			     osb->dev_str, info.tf_nodenum);
>>>>>>> +			range->len = info.tf_trimlen;
>>>>>>> +			goto out_trimunlock;
>>>>>>> +		}
>>>>>>> +	}
>>>>>>> +
>>>>>>> +	info.tf_nodenum = osb->node_num;
>>>>>>> +	info.tf_start = start;
>>>>>>> +	info.tf_len = len;
>>>>>>> +	info.tf_minlen = minlen;
>>>>>>
>>>>>> If we faild during dong trimfs, I think we should not cache above info in
>>>>>> LVB.
>>>>> It is necessary, if the second node is waiting the first node, the first
>>>> node fails to do fstrim,
>>>>> the first node should update dlm lock's value, then the second node can get
>>>> the latest dlm lock value (rather than the last time DLM lock value),
>>>>> the second node will do the fstrim again, since the first node has failed.
>>>>
>>>> Yes, it makes scene.
>>>>>
>>>>>> BTW, it seems that this patch is on top of  'try lock' patches which you
>>>>>> previously sent out.
>>>>>> Are they related?
>>>>> try lock patch is related to non-block aio support for ocfs2.
>>>>>
>>>>> Thanks
>>>>> Gang
>>>>>>
>>>>>> Thanks,
>>>>>> Changwei
>>>>>>
>>>>>>> +
>>>>>>>      	/* Determine first and last group to examine based on start and len */
>>>>>>>      	first_group = ocfs2_which_cluster_group(main_bm_inode, start);
>>>>>>>      	if (first_group == osb->first_cluster_group_blkno)
>>>>>>> @@ -7463,6 +7500,13 @@ int ocfs2_trim_fs(struct super_block *sb, struct
>>>>>> fstrim_range *range)
>>>>>>>      			group += ocfs2_clusters_to_blocks(sb, osb->bitmap_cpg);
>>>>>>>      	}
>>>>>>>      	range->len = trimmed * sb->s_blocksize;
>>>>>>> +
>>>>>>> +	info.tf_trimlen = range->len;
>>>>>>> +	info.tf_success = (ret ? 0 : 1);
>>>>>>> +	pinfo = &info;
>>>>>>> +out_trimunlock:
>>>>>>> +	ocfs2_trim_fs_unlock(osb, pinfo);
>>>>>>> +	ocfs2_trim_fs_lock_res_uninit(osb);
>>>>>>>      out_unlock:
>>>>>>>      	ocfs2_inode_unlock(main_bm_inode, 0);
>>>>>>>      	brelse(main_bm_bh);
>>>>>>>
>>>>>
>>>
> 
