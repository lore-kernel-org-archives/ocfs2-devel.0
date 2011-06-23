From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 23 Jun 2011 15:30:54 -0700
Subject: [Ocfs2-devel] ocfs2 cleanups, bug fixes for Linux kernel 3.1
Message-ID: <1308868267-5981-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

[PATCH 01/13] ocfs2/cluster: Abort heartbeat start on hard-ro devices
Incorporated Mark's comments.

[PATCH 02/13] ocfs2/cluster: Clean up messages in o2net
[PATCH 03/13] ocfs2/dlm: Clean up messages in o2dlm
[PATCH 04/13] ocfs2: Clean up messages in stack_o2cb.c
So NOTICE messages that we expect to see (o2net connect/disconnect, etc.) have
been converted from ML_NOTICE to KERN_NOTICE. Much easier to read.

[PATCH 05/13] ocfs2/dlm: Cleanup up dlm_finish_local_lockres_recovery()
[PATCH 06/13] ocfs2/dlm: Clean up refmap helpers
[PATCH 07/13] ocfs2/dlm: Trace insert/remove of resource to/from hash
[PATCH 08/13] ocfs2/dlm: Cleanup dlm_wait_for_node_death() and dlm_wait_for_node_recovery()
Cleanup. No change in functionality.

[PATCH 09/13] ocfs2/dlm: Take inflight reference count for remotely mastered resources too
[PATCH 10/13] ocfs2/dlm: dlmlock_remote() needs to account for remastery
Bug fixes. Fixes race between create_lock and recovery.

[PATCH 11/13] ocfs2/cluster: Fix output in file elapsed_time_in_ms
As the o2cb init script now starts the o2hbmonitor before the hb has stabilized,
we need to ensure we don't print erroneous elapsed time.

[PATCH 12/13] ocfs2/cluster: Add new function o2net_fill_node_map()
[PATCH 13/13] ocfs2/cluster: Cluster up now includes network connections too
The o2cb cluster up check now ensures that the node is heartbeating and that it
is connected to all nodes. Something we should have been doing all along. ;)

All these patches are also available here. The previous submits of some patches
are also available at the same place.
http://oss.oracle.com/~smushran/ocfs2-pending-patches/0623-fs/

Thanks
Sunil
