From: Coly Li <coyli@suse.de>
Date: Tue, 02 Dec 2008 20:06:24 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix DLM_BADARGS error in concurrent
	file locking
Message-ID: <493524C0.4090506@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

When calling flock(2) by multiple processes concurrently, it is reported to be very easy resulting
DLM_BADARGS error. In dmesg the similar lines can be found:
Sep  2 11:17:32 acct20 kernel: (6935,1):ocfs2_lock_create:901 ERROR: Dlm error "DLM_BADARGS" while
calling dlmlock on resource
F00000000000000005d1cfe83ab8dad: bad api args
Sep  2 11:17:32 acct20 kernel: (6935,1):ocfs2_file_lock:1486 ERROR: status = -22

Here is the analysis how this error comes, in condition that 2 process concurrently call flock(2) on
same file:

1) call sequence of process 1 is (first listed first called):
   [ocfs2_do_flock] [ocfs2_file_lock] [ocfs2_lock_create] [dlmlock] [dlm_get_lock_resource]
[dlm_do_master_request] [o2net_send_message_vec]
   In o2net_send_message_vec(), at line 1049:
        wait_event(nsw.ns_wq, o2net_nsw_completed(nn, &nsw));
   Here process 1 is scheduled out, and process 2 is scheduled in to ran.
   At this moment, res->owner (ownership of the locking file resource) is set to
DLM_LOCK_RES_OWNER_UNKNOWN.

2) call sequence of process 2 is (first listed first called):
   [ocfs2_do_flock] [ocfs2_file_lock] [ocfs2_lock_create] [dlmlock] [dlmlock_remote]
[o2net_send_message_vec]
   in dlmlock(), at line 725:
                if (res->owner == dlm->node_num)
                        status = dlmlock_master(dlm, res, lock, flags);
                else
                        status = dlmlock_remote(dlm, res, lock, flags);
    Since res->owner is still set to DLM_LOCK_RES_OWNER_UNKNOWN and not decided in process 1 yet,
process 2 calls dlmlock_remote() here. But inside dlmlock_remote(), at line 247:
        __dlm_wait_on_lockres(res);
    After this function returned, res->owner is set correctly to 0 (node 0). Then at line 257:
        status = dlm_send_remote_lock_request(dlm, res, lock, flags);
    dlm_send_remote_lock_request() calls o2net_send_message() at line 330, as bellowed:
        tmpret = o2net_send_message(DLM_CREATE_LOCK_MSG, dlm->key, &create,
                                    sizeof(create), res->owner, &status);
    o2net_send_message() calls o2net_send_message_vec() and at line 987, the code is:
        if (target_node == o2nm_this_node()) {
                ret = -ELOOP;
                goto out;
        }
   Here target_node is res->owner which is already set to 0. But before calling dlmlock_remote(),
res->owner is not set properly (still is DLM_LOCK_RES_OWNER_UNKNOWN). After entering
dlmlock_remote(), and returning from __dlm_wait_on_lockres(), though res->owner is correct, the
execution flow is in mistaken location.

3) The result is, process 1 can make the flock, and process 2 generates BADARGS error. 20 processes
condition also got tested, only first process can success the flock, and other processes all got
BADARGS.

With Sunil and Mark's suggestion, the solution is,
1) If a tmpres returned from hashed resources, check its owner.
2) if tmpres->owner is DLM_LOCK_RES_OWNER_UNKNOWN, it means another process owns the resource but
dose not finish its initiation. We should wait on DLM_LOCK_RES_IN_PROGRESS until the initiation
accomplished.
3) Once the initiation done, re-lookup the resource.

After basic testing on 2 nodes (each node forks 200,000 processes calling flock(2)) and 8 nodes
(each node forks 1000 processes calling flock(2)), it works fine so far.

Signed-off-by: Coly Li <coyli@suse.de>
Cc: Sunil Mushran <sunil.mushran@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Jeff Mahoney <jeffm@suse.com>
---
 fs/ocfs2/dlm/dlmmaster.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 44f87ca..c777844 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -742,6 +742,19 @@ lookup:
 			goto lookup;
 		}

+		/* tmpres might be initiating by another process, in this case
+		 * we should wait until the initiation done  */
+		spin_lock(&tmpres->spinlock);
+		if (tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN ||
+		    (tmpres->state & DLM_LOCK_RES_IN_PROGRESS)) {
+			__dlm_wait_on_lockres_flags(tmpres, DLM_LOCK_RES_IN_PROGRESS);
+			spin_unlock(&tmpres->spinlock);
+			dlm_lockres_put(tmpres);
+			tmpres = NULL;
+			goto lookup;
+		}
+		spin_unlock(&tmpres->spinlock);
+
 		mlog(0, "found in hash!\n");
 		if (res)
 			dlm_lockres_put(res);

-- 
Coly Li
SuSE PRC Labs
