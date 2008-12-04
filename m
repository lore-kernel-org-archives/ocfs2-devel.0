From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 03 Dec 2008 19:58:42 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix DLM_BADARGS error in
 concurrent file locking
In-Reply-To: <4935EDB4.7020405@suse.de>
References: <493524C0.4090506@suse.de> <4935B20B.9040309@oracle.com>
	<4935EDB4.7020405@suse.de>
Message-ID: <49375572.8000801@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

So I have a new patch. It has debug code too. I am still testing this.
Don't upload it to bz.

--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -672,6 +672,12 @@ void __dlm_lockres_drop_inflight_ref(struct 
dlm_ctxt *dlm,
 {
        assert_spin_locked(&res->spinlock);
 
+       if (res->inflight_locks == 0) {
+               mlog(ML_ERROR, "%s:%.*s: inflight=0\n",
+                    dlm->name, res->lockname.len, res->lockname.name);
+               __dlm_print_one_lock_resource(res);
+               dump_stack();
+       }
        BUG_ON(res->inflight_locks == 0);
        res->inflight_locks--;
        mlog(0, "%s:%.*s: inflight--: now %u\n",
@@ -726,14 +732,22 @@ lookup:
        if (tmpres) {
                int dropping_ref = 0;
 
+               spin_unlock(&dlm->spinlock);
+
                spin_lock(&tmpres->spinlock);
+               if (tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN) {
+                       mlog(ML_NOTICE, "%s:%.*s Another thread is 
mastering "
+                            "this resource\n", dlm->name, namelen, lockid);
+                       __dlm_wait_on_lockres(tmpres);
+                       BUG_ON(tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN);
+               }
+
                if (tmpres->owner == dlm->node_num) {
                        BUG_ON(tmpres->state & DLM_LOCK_RES_DROPPING_REF);
                        dlm_lockres_grab_inflight_ref(dlm, tmpres);
                } else if (tmpres->state & DLM_LOCK_RES_DROPPING_REF)
                        dropping_ref = 1;
                spin_unlock(&tmpres->spinlock);
-               spin_unlock(&dlm->spinlock);
 
                /* wait until done messaging the master, drop our ref to 
allow
                 * the lockres to be purged, start over. */



Coly Li wrote:
> This is the way I tried firstly, didn't not work well. When I tested with more than 20 forks on 1
> node, user space process got segmentation fault and kernel got oops. The kernel oops was triggered
> on BUG_ON(res->inflight_locks == 0) in __dlm_lockres_drop_inflight_ref() IIRC.
>
> Also, BUG_ON(tmpres->owner == DLM_LOCK_RES_OWNER_UNKNOWN) might not always be correct IMHO. Even we
> return from __dlm_wait_on_lockres_flags(), there still is chance to set tmpres->owner to
> DLM_LOCK_RES_OWNER_UNKNOWN before BUG_ON is tested (in theory), especially when dlm->spinlock is not
> held.
>   
Well, if you get an oops, get the stack. If you had, it would have 
looked like this.

(19990,0):__dlm_lockres_drop_inflight_ref:677
   ERROR: 
1B57953A48324D258163FE31C04C4B11:F00000000000000000801f61f38b60c: inflight=0
Call Trace:
.show_stack+0x68/0x1b0 (unreliable)
 .__dlm_lockres_drop_inflight_ref+0x98/0x184 [ocfs2_dlm]
 .dlmlock_master+0x41c/0x4f8 [ocfs2_dlm]
 .dlmlock+0x8b0/0x11a0 [ocfs2_dlm]
 .ocfs2_lock_create+0x174/0x3a8 [ocfs2]
 .ocfs2_file_lock+0x158/0x6d8 [ocfs2]
 .ocfs2_flock+0x18c/0x278 [ocfs2]
 .sys_flock+0x170/0x1d4
 syscall_exit+0x0/0x40
kernel BUG in __dlm_lockres_drop_inflight_ref at 
/rpmbuild/smushran/BUILD/ocfs2-1.4.1/fs/ocfs2/dlm/dlmmaster.c:680!

This tells you what the issue is. We are forgetting to take an inflight ref.
The new patch moves the code up so that we take the reference.

Secondly, dlm->spinlock does not protect res->owner. Furthermore, that
BUG_ON is important because that is the case. If mastery is underway,
the state will remain IN_PROGRESS. I am curious as to why you feel 
otherwise.

Lastly, the perl script can be improved by enclosing the 20 fork loop
into another loop that changes the filename. To startwith, touch 5000 files
(test.flock%d). umount and mount again. This will drop the caches. Now
before running any ls, run flock.pl. It will spawn 20 processes to flock()
each file and wait till the 20 forks have exited before letting loose 
another
20 for the next file. (Makesure you have another node or two or more 
that have
just mounted that volume.)

I ran this with 5000 files successfully. I did encounter a problem in 
the last
run, not where I expected it. Still a work in progress. I can't email 
you the
perl script as my box will remain in the debugger for the night. ;)

My problem with your patch is not that it is wrong, but it is punting the
issue. Say we do have a case in which the res->owner remains unknown 
eventhough
the state in not in_prog. In that case, the process will keep looping. By
oopsing, we catch the problem upfront.

Sunil
