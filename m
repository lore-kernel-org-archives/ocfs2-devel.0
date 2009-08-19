From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 18 Aug 2009 20:06:17 -0700
Subject: [Ocfs2-devel] dlm stress test hangs OCFS2
In-Reply-To: <4A8B0083.8030400@suse.de>
References: <4A8B0083.8030400@suse.de>
Message-ID: <4A8B6C29.30802@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Read this thread for some background. There are others like this.
http://oss.oracle.com/pipermail/ocfs2-devel/2009-April/004313.html

David had run into a similar issue with two nodes. The symptoms were the
same. In that case, we were failing to kick the downconvert thread under
one situation.

Bottomline, the reason for the hang is that a node is not downconverting
its lock. It could be a race in dlmglue or something else.

The node has a PR and an another nodes wants an EX. Unless the node 
downconverts
to a NL, the master cannot upconvert the other node to EX. Hang. Also, 
cancel
converts are in the mix.

For example:

Lockres: M0000000000000000046e2a00000000  Mode: Protected Read
Flags: Initialized Attached Blocked Needs Refresh Queued
RO Holders: 0  EX Holders: 0
Pending Action: None  Pending Unlock Action: None
Requested Mode: Protected Read  Blocking Mode: Exclusive
PR > Gets: 463  Fails: 0    Waits (usec) Total: 1052625  Max: 41985
EX > Gets: 37  Fails: 0    Waits (usec) Total: 990652  Max: 79971
Disk Refreshes: 0

You can see the lockres has a PR and is blocking an EX. The downconvert thread
should downconvert it to a NL. One reason it won't is if there are any holders.
But we can see 0 RO and EX holders.

DownCnvt => Pid: 2759  Count: 1  WakeSeq: 14838  WorkSeq: 14838

The downcnvt shows 1 lockres is queued. We have to assume it is this one.
If not, then we have a bigger problem. Maybe add a quick/dirty hack to dump
the lockres in this queue.

Maybe we are forgetting to kick it like last time. I did scan the code
for that but came up empty handed.

To solve this mystery, you have to find out as to why the dc thread is
not acting on the lockres. Forget stats. Just add printks in that thread.
Starting from say ocfs2_downconvert_thread_do_work().

Sunil


Coly Li wrote:
> This email is also sent to cluster-devel at redhat.com. Since this issue is about
> both dlm and ocfs2, I send the email here to look for help from upstream.
>
> This is an already known issue.
>
> on ocfs2 with user space cluster stack, run the test script from
> http://people.redhat.com/~teigland/make_panic on the mounted ocfs2 volume from 2
> nodes simultaneously, the access to ocfs2 volume on both nodes will get hung.
>
> This issue also described in Novell bugzilla #492055
> (https://bugzilla.novell.com/show_bug.cgi?id=492055). Now on upstream kernel,
> the dead-hang is not reproduced. But the accessing will still get blocked time
> to time.
>
> Blocked time to time, means make_panic can run for several minutes, then get
> blocked on both nodes. The blocking time is variable, from dozens of seconds to
> dozens of minutes. The longest time I observed is 25 minutes. Then make_panic on
> both nodes continue to run.
>
> Also I observed, when run make_panic under same directory of the ocfs2 volume
> from both nodes, the chance to reproduce the blocking issue will increase a lot.
>
> In further debugging, I added some printk information in fs/ocfs2/dlmglue.c, and
> did some statistic. Here is the statistic info for 4 seconds when both nodes
> gets blocked:
> Here is a statistic info on the frequency of each functions got called during
> the 4 seconds,
>    1352 lockres_set_flags
>     728 lockres_or_flags
>     624 lockres_clear_flags
>     312 __lockres_clear_pending
>     213 ocfs2_process_blocked_lock
>     213 ocfs2_locking_ast
>     213 ocfs2_downconvert_thread_do_work
>     213 lockres_set_pending
>     213 lockres_clear_pending
>     213 lockres_add_mask_waiter
>     156 ocfs2_prepare_downconvert
>     156 ocfs2_blocking_ast
>     104 ocfs2_unblock_lock
>     104 ocfs2_schedule_blocked_lock
>     104 ocfs2_generic_handle_downconvert_action
>     104 ocfs2_generic_handle_convert_action
>     104 ocfs2_generic_handle_bast
>     104 ocfs2_downconvert_thread
>     104 ocfs2_downconvert_lock
>     104 ocfs2_data_convert_worker
>     104 ocfs2_cluster_lock
>
> >From above data, I can see lockres_set_flags gets called for 1352 times in the 4
> seconds, then it's lockres_or_flags for 728 times and lockres_clear_flags for
> 624 times.
>
> When I add more printk inside the code, the blocking will very hard to
> reproduce. Therefore, I suspect there is kind of race inside.
>
> I work on this issue for quite many days, still no idea how this issue comes and
> how to fix it. Many people here might know this issue already, wish upstream
> developers can watch on it and provide hints on the fix.
>
> Thanks in advance.
>   
