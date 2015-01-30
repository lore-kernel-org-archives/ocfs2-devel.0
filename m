From: yangwenfang <vicky.yangwenfang@huawei.com>
Date: Fri, 30 Jan 2015 15:46:09 +0800
Subject: [Ocfs2-devel] [RFC] ocfs2/dlm: support range lock
In-Reply-To: <54CB1E7A.4020403@oracle.com>
References: <54C632F4.3070705@huawei.com> <54C9794B.9000708@suse.de>
	<54C9E5A8.8060804@huawei.com> <54C9EA21.8080908@oracle.com>
	<54CB0087.6020102@huawei.com> <54CB1E7A.4020403@oracle.com>
Message-ID: <54CB36C1.1050109@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2015/1/30 14:02, Wengang Wang wrote:
> Hi Wenfang,
> 
> ? 2015?01?30? 11:54, yangwenfang ??:
>> On 2015/1/29 16:06, Wengang Wang wrote:
>>>> On 2015/1/29 8:05, Goldwyn Rodrigues wrote:
>>>>> Hi Yangwenfang,
>>>>>
>>>>> I appreciate the effort in this regard.
>>>>>
>>>>> On 01/26/2015 06:28 AM, yangwenfang wrote:
>>>>>> What:
>>>>>> Byte range lock is applied to lock a region of a file to accelerate
>>>>>> reading/writing concurrently.
>>>>>> Each lock resource deploys an interval tree to manage the range, which
>>>>>> supports basic operations like add, delete, insert, find, split and merge.
>>>>>> The most important issue is to determine the existance of conflicts
>>>>>> among the ranges. Conflict-free ranges of the same file can be accessed
>>>>>> concurrently. In the contrary, nodes must wait for the release of a
>>>>>> conflicted lock before accessing the range of file.
>>>>>>
>>>>>> Byte range lock supports split and merge rules: for same level, larger
>>>>>> scope; different level, write > read(If a node keeps EX lock with
>>>>>> range(start,end), then it has PR range lock(start,end)).
>>>>>> For example:
>>>>>> (1) merge: N1 keeps range lock (0,9)PR and (5,19)PR, the lock is merged into
>>>>>> (0,19) PR;
>>>>>> (2) merge: N1 keeps range lock (0,9)PR and (5,19)EX, the merged lock should
>>>>>> become(0,19) PR, (5,19)EX;
>>>>>> (3) split: N1 keeps range lock (0,9)PR, N2 tries to lock(0,5) PR, N1 should
>>>>>> split the lock and keep (6,9)PR.
>>>>> What is the purpose of doing this kind of merge/split? I assume this will be required in case of multiple processes from the same node read/write to the file. Would it not be simpler to not merge or split and keep separate instances in lock resources? This way you would have to do relatively lesser book keeping with respect to comparisons.
>>>>>
>>>> Hi,
>>>> Realization of this kind of merge/split is for cache of range lock to support unlock-delay.
>>>> For example(the granularity is block size)
>>>> 1.Node 1 writes to 0-9, it will keep the range lock(0,9,EX) if no other node write the same range of file.
>>>> 2.Node 1 writes to 10-19, then the range lock will be merged into (0,19,EX). if not, the number of locks will be more and more.
>>>> 3.Node 1 writes to 5-10, then no need to dlmlock from master.
>>>> 3.Node 2 writes to 5-10, conflict with Node 1, so Node 1 will drop (5,10), the range lock is splitted into (0,4) and (11,19).
>>> What's the merge would be like in dlm module? Will it cause deadlock when
>>> node1 extend 0-9 to 0-19  and node 2 extend 10-19 to 0-19?
>>>
>>> thanks,
>>> wengang
>>>
>> Hi,
>> Do you mean that:
>> N1 keeps range lock(0,9), and wants to lock(10,19).
>> N2 keeps range lock(10,19), and wants to lock(0,9).
>>
>> Firstly N1 sends locking message (10,19) to master, then master determines the existance of conflicts among the ranges.
>> N1(10,19) is conflict with N2(10,19). So master sends bast message to N2.
>> Sencond N2 sends locking message (0,9) to master, N1(0,9) is conflict with N2 (0,9), so master sends bast message to N1.
>> N2 drops range lock(10,19), then N1 merges range lock into (0,19).
>> N1 drops range lock (0,9), then N1 splits range lock into (10,19).
>> Finally, N1 keeps range lock (10,19), N2 keeps range lock (0,9).
>>
>> So, there is no deadlock. Merging is only to the granted lock.
>>
>> But if N2 keeps range lock(10,19), and wants to lock(0,15), there is deadlock.
>> When N2 drops range lock(10,19), (10,19) is conflict with another request (0,15), range lock (0,15) must be canceled
> 
> How you detect the deadlock and avoid it?
> thanks,
> wengang

No additional deadlock detection mechanism.
We keep the original cancel process which use OCFS2_LOCK_BUSY and OCFS2_LOCK_PENDING in ocfs2_unblock_lock.

Maybe we can have a talk by telephone, ok?

key data structures:
struct ocfs2_lock_res {
	struct ocfs2_cluster_connection *conn;
	void                    *l_priv;
	struct ocfs2_lock_res_ops *l_ops;

	spinlock_t               l_lock;
	struct mutex      l_wait_blocked_mutex;

	char                     l_name[OCFS2_LOCK_ID_MAX_LEN];
	/* Data packed - type enum ocfs2_lock_type */
	unsigned char            l_type;
	unsigned long		 l_flags;
	wait_queue_head_t        l_event;

	char lvb[DLM_LVB_LEN];
	
	struct list_head         l_mask_waiters;
	struct list_head  l_grant_list;   //l_list
	struct list_head  l_request_list; //l_list
	struct list_head  l_region_list;  //l_list

	struct list_head  l_blocked_list;   //l_list, remote blocking list

	struct interval_node  *list_root;
	struct list_head         l_debug_list;

#ifdef CONFIG_OCFS2_FS_STATS
	struct ocfs2_lock_stats  l_lock_prmode;		/* PR mode stats */
	u32                      l_lock_refresh;	/* Disk refreshes */
	struct ocfs2_lock_stats  l_lock_exmode;		/* EX mode stats */
#endif
};
struct ocfs2_res_range_lock {
	struct ocfs2_lock_res *l_lockres;

	struct list_head  l_list;
	struct list_head  l_tmp_list;  //for args
	struct list_head  l_remote_list; //for osb
	struct list_head  l_wait_blocked_list;
	struct list_head         l_mask_waiters;
	wait_queue_head_t        l_event;

	struct kref l_refs;
	unsigned long		 l_flags;
	unsigned long l_state;
	signed char		 l_level;

	struct interval_node_extent	out_extent;

	struct lock_interval *l_tree_node;
	struct list_head l_same_range_list;

	/* used from AST/BAST funcs. */
	/* Data packed - enum type ocfs2_ast_action */
	unsigned char            l_action;
	/* Data packed - enum type ocfs2_unlock_action */
	unsigned char            l_unlock_action;
	unsigned int             l_pending_gen;

	struct ocfs2_dlm_lksb    l_lksb;

#ifdef CONFIG_DEBUG_LOCK_ALLOC
	struct lockdep_map	 l_lockdep_map;
#endif
};

thanks,
yangwenfang
