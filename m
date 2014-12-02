From: Xue jiufei <xuejiufei@huawei.com>
Date: Tue, 2 Dec 2014 14:50:23 +0800
Subject: [Ocfs2-devel] [patch 02/10] ocfs2: free inode when i_count
	becomes zero
In-Reply-To: <54017755.7080008@huawei.com>
References: <53e290c2.UrOYpRJudvt5Qabp%akpm@linux-foundation.org>
	<20140813180339.GU2203@wotan.suse.de> <54017755.7080008@huawei.com>
Message-ID: <547D612F.60901@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi
On 2014/8/30 15:03, Xue jiufei wrote:
> On 2014/8/14 2:03, Mark Fasheh wrote:
>> On Wed, Aug 06, 2014 at 01:32:02PM -0700, Andrew Morton wrote:
>>> From: Xue jiufei <xuejiufei@huawei.com>
>>> Subject: ocfs2: free inode when i_count becomes zero
>>>
>>> Disk inode deletion may be heavily delayed when one node unlink a file
>>> after the same dentry is freed on another node(say N1) because of memory
>>> shrink but inode is left in memory.  This inode can only be freed while N1
>>> doing the orphan scan work.
>>>
>>> However, N1 may skip orphan scan for several times because other nodes may
>>> do the work earlier.  In our tests, it may take 1 hour on 4 nodes cluster
>>> and this will cause bad user experience.  So we think the inode should be
>>> freed when i_count becomes zero to avoid such circumstances.
>>
>> Firstly, thanks for the patch Xue.
>>
>> I understand your problem and I definitely agree that it hurts the user
>> experience. If the inode is free to be deleted we shouldn't be taking so
>> long to get rid of it.
>>
>> What I'm worried about is that we're always going to tell the kernel to
>> evict the inode now, which will always cause some sort of cluster locking.
>>
>> I need to look at this more and think about it a bit. Maybe there's a better
>> way?
>> 	--Mark
>>
I am sorry that I made a mistake. This patch may lead to data loss when i_count
becomes zero but there still exists dirty pages in i_mapping, the dirty pages
would be freed without flushing the data.

To avoid this problem, we should flush dirty page before dropping
the inode, but I don't think it it a good idea to flush page in
function ocfs2_drop_inode().

Is there any better way to solve this problem?

Thanks,
Xuejiufei
>> --
> In most cases, the refcount of inode would not be zero because there
> is one or more dentrys associated with it. So only in this situation
> that a dentry is force to be freed because of memory pressure but the
> inode is left, we increase the probability of inode eviction. I think it
> is acceptable.
> 
> Thanks,
> Xuejiufei
> 
>> Mark Fasheh
>> .
>>
> 
