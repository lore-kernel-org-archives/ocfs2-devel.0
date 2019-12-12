From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Thu, 12 Dec 2019 13:51:45 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: call journal flush to mark journal
 as empty after journal recovery when mount
In-Reply-To: <5bc88eee-21d9-14c2-6544-d4e3baa931cb@linux.alibaba.com>
References: <20191211100338.510-1-li.kai4@h3c.com>
	<76d8166c-afe9-fc63-98b2-5293e3956669@linux.alibaba.com>
	<5bc88eee-21d9-14c2-6544-d4e3baa931cb@linux.alibaba.com>
Message-ID: <5510650e-2e5d-2f7c-e1ef-b118389125d5@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Changwei Ge <chge@linux.alibaba.com>, Kai Li <li.kai4@h3c.com>, mark@fasheh.com, jlbec@evilplan.org
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org



On 19/12/12 11:55, Changwei Ge wrote:
> Hi Joseph,
> 
> On 12/11/19 9:17 PM, Joseph Qi wrote:
>>
>>
>> On 19/12/11 18:03, Kai Li wrote:
>>> If journal is dirty when mount, it will be replayed but jbd2 sb
>>> log tail cannot be updated to mark a new start because
>>> journal->j_flag has already been set with JBD2_ABORT first
>>> in journal_init_common. When a new transaction is committed, it
>>> will be recored in block 1 first(journal->j_tail is set to 1 in
>>> journal_reset).
>>>
>>> If emergency restart happens again before journal super block is
>>> updated unfortunately, the new recorded trans will not be replayed
>>> in the next mount.
>>>
>> I think I've finally understood the problem. But I don't think it has
>> been clearly described for reviewing. I strongly suggest you describe
>> the problem in the way of timeline, such as in which step, do what
>> operation, and what is the status, etc.
>>
>>
>>> This exception happens when this lun is used by only one node. If it
>>> is used by multi-nodes, other node will replay its journal and its
>>> journal sb block will be updated after recovery.
>>>
>>> To fix this problem, use jbd2_journal_flush to mark journal as empty as
>>> ocfs2_replay_journal has done.>
>> Sounds reasonable. But IMO, it is really a corner use scenario, using
>> cluster filesystem in single node...
> 
> True, this use case should be rare.
> But considering that fixing this is not complicated and does no harm at least, I am inclining taking this in. We can only merge it to mainline rather than -stable branches. :-)
> 
Okay, let's move it on.

Thanks,
Joseph
