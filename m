From: Zhangguanghui <zhang.guanghui@h3c.com>
Date: Sat, 16 May 2015 03:39:42 +0000
Subject: [Ocfs2-devel] ocfs2/dlm: Ignore LVBs of locks
Message-ID: <2015051611394221344336@h3c.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

In the process of  dlm_prepare_lvb_for_migration?

if  all valid locks have not the  same LVB? then  BUGs.

the patch ensures that the other valid locks have the

same a LVB from the first valid lock  to solute the problem of BUGs


Finally, any feedback about this process (positive or negative) would be
greatly appreciated.
Thanks,
        --zgh


static void dlm_prepare_lvb_for_migration(struct dlm_lock *lock, struct dlm_migratable_lockres *mres,int queue)

--- dlmrecovery.c 2014-12-17 01:39:45.000000000 +0800
+++ dlmrecovery0.c 2015-05-16 10:59:59.683924862 +0800
@@ -1215,7 +1215,10 @@
lock->lockres->lockname.len, lock->lockres->lockname.name,
lock->ml.node);
dlm_print_one_lock_resource(lock->lockres);
- BUG();
+
+ /* Ensure the lvb copied for migration matches the first valid locks */
+ memcpy(lock->lksb->lvb, mres->lvb, DLM_LVB_LEN);
+ return;
}



On Mon, Jan 25, 2010 at 04:57:39PM -0800, Sunil Mushran wrote:
> During lock resource migration, o2dlm fills the packet with a LVB from the
> first valid lock. For sanity, it ensures that the other valid locks have the
> same LVB. If not, it BUGs.
>
> The valid locks are ones that have granted EX or PR lock levels and are either
> on the Granted or Converting lists. Locks in the Blocked list cannot have a
> valid LVB.




________________________________
zhangguanghui 10102
-------------------------------------------------------------------------------------------------------------------------------------
????????????????????????????????????????
????????????????????????????????????????
????????????????????????????????????????
???
This e-mail and its attachments contain confidential information from H3C, which is
intended only for the person or entity whose address is listed above. Any use of the
information contained herein in any way (including, but not limited to, total or partial
disclosure, reproduction, or dissemination) by persons other than the intended
recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
by phone or email immediately and delete it!
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20150516/20f47b0d/attachment.html 
