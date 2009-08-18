From: Coly Li <coly.li@suse.de>
Date: Wed, 19 Aug 2009 03:26:59 +0800
Subject: [Ocfs2-devel] dlm stress test hangs OCFS2
Message-ID: <4A8B0083.8030400@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

This email is also sent to cluster-devel at redhat.com. Since this issue is about
both dlm and ocfs2, I send the email here to look for help from upstream.

This is an already known issue.

on ocfs2 with user space cluster stack, run the test script from
http://people.redhat.com/~teigland/make_panic on the mounted ocfs2 volume from 2
nodes simultaneously, the access to ocfs2 volume on both nodes will get hung.

This issue also described in Novell bugzilla #492055
(https://bugzilla.novell.com/show_bug.cgi?id=492055). Now on upstream kernel,
the dead-hang is not reproduced. But the accessing will still get blocked time
to time.

Blocked time to time, means make_panic can run for several minutes, then get
blocked on both nodes. The blocking time is variable, from dozens of seconds to
dozens of minutes. The longest time I observed is 25 minutes. Then make_panic on
both nodes continue to run.

Also I observed, when run make_panic under same directory of the ocfs2 volume
from both nodes, the chance to reproduce the blocking issue will increase a lot.

In further debugging, I added some printk information in fs/ocfs2/dlmglue.c, and
did some statistic. Here is the statistic info for 4 seconds when both nodes
gets blocked:
Here is a statistic info on the frequency of each functions got called during
the 4 seconds,
   1352 lockres_set_flags
    728 lockres_or_flags
    624 lockres_clear_flags
    312 __lockres_clear_pending
    213 ocfs2_process_blocked_lock
    213 ocfs2_locking_ast
    213 ocfs2_downconvert_thread_do_work
    213 lockres_set_pending
    213 lockres_clear_pending
    213 lockres_add_mask_waiter
    156 ocfs2_prepare_downconvert
    156 ocfs2_blocking_ast
    104 ocfs2_unblock_lock
    104 ocfs2_schedule_blocked_lock
    104 ocfs2_generic_handle_downconvert_action
    104 ocfs2_generic_handle_convert_action
    104 ocfs2_generic_handle_bast
    104 ocfs2_downconvert_thread
    104 ocfs2_downconvert_lock
    104 ocfs2_data_convert_worker
    104 ocfs2_cluster_lock

From above data, I can see lockres_set_flags gets called for 1352 times in the 4
seconds, then it's lockres_or_flags for 728 times and lockres_clear_flags for
624 times.

When I add more printk inside the code, the blocking will very hard to
reproduce. Therefore, I suspect there is kind of race inside.

I work on this issue for quite many days, still no idea how this issue comes and
how to fix it. Many people here might know this issue already, wish upstream
developers can watch on it and provide hints on the fix.

Thanks in advance.
-- 
Coly Li
SuSE Labs
