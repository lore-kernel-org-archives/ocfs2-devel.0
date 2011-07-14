From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 14 Jul 2011 15:50:11 -0700
Subject: [Ocfs2-devel] ocfs2 cleanups,
	bug fixes for Linux kernel 3.1 - final drop
Message-ID: <1310683827-19157-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel,

Hopefully this is the final drop before the 3.1 merge window. I had posted most
of the patches before. In fact the first 12 are exactly the same. The 13th one
is modified and 14,15,16 are new.

The previous drop can be accessed here:
http://oss.oracle.com/pipermail/ocfs2-devel/2011-June/008243.html

[PATCH 01/16] ocfs2/cluster: Abort heartbeat start on hard-ro devices
[PATCH 02/16] ocfs2/cluster: Clean up messages in o2net
[PATCH 03/16] ocfs2/dlm: Clean up messages in o2dlm
[PATCH 04/16] ocfs2: Clean up messages in stack_o2cb.c
[PATCH 05/16] ocfs2/dlm: Cleanup up dlm_finish_local_lockres_recovery()
[PATCH 06/16] ocfs2/dlm: Clean up refmap helpers
[PATCH 07/16] ocfs2/dlm: Trace insert/remove of resource to/from hash
[PATCH 08/16] ocfs2/dlm: Cleanup dlm_wait_for_node_death() and dlm_wait_for_node_recovery()
[PATCH 09/16] ocfs2/dlm: Take inflight reference count for remotely mastered resources too
[PATCH 10/16] ocfs2/dlm: dlmlock_remote() needs to account for remastery
[PATCH 11/16] ocfs2/cluster: Fix output in file elapsed_time_in_ms
[PATCH 12/16] ocfs2/cluster: Add new function o2net_fill_node_map()

Same as the last drop.

[PATCH 13/16] ocfs2/cluster: Cluster up now includes network connections too
One change. It now waits for a bit for the two bitmaps to align.

[PATCH 14/16] ocfs2: Clean up messages in the fs
[PATCH 15/16] ocfs2: Add comment about orphan scanning
I added the comment so that we remember the reason we added orphan scanning
in the first place.

[PATCH 16/16] ocfs2: Fix ocfs2_page_mkwrite()
This is Wengang's patch + some cleanups suggested by Mark.

Thanks
Sunil
