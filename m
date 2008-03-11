From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue Mar 11 16:32:15 2008
Subject: [Ocfs2-devel] Backports to OCFS2 1.4
Message-ID: <1205278329-11111-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following patches are in this series. All except the first one
have already been merged into mainline. The headers indicate the mainline
commit# and other details of the original patch.

[PATCH 01/18] ocfs2: Add helper task_pid_nr
[PATCH 02/18] ocfs2: Spelling fixes
[PATCH 03/18] ocfs2: Negotiate locking protocol versions.
[PATCH 04/18] ocfs2: Fix writeout in ocfs2_data_convert_worker()
[PATCH 05/18] ocfs2: possible cleanups
[PATCH 06/18] ocfs2: make ocfs2_downconvert_thread() static
[PATCH 07/18] ocfs2: make dlm_do_assert_master() static
[PATCH 08/18] ocfs2: Correct use of ! and & in aops.c
[PATCH 09/18] ocfs2/dlm: fix printk warning
[PATCH 10/18] ocfs2: Use dlm_print_one_lock_resource for lock resource print
[PATCH 11/18] ocfs2: Fix endian bug in o2dlm protocol negotiation.
[PATCH 12/18] ocfs2: Fix an endian bug in online resize
[PATCH 13/18] ocfs2/dlm: Add missing dlm_lock_put()s
[PATCH 14/18] ocfs2/dlm: Add missing dlm_lockres_put()s in migration path
[PATCH 15/18] ocfs2/dlm: Add missing dlm_lockres_put()s
[PATCH 16/18] ocfs2/dlm: Print message showing the recovery master
[PATCH 17/18] ocfs2/dlm: dlm_thread should not sleep while holding the dlm_spinlock
[PATCH 18/18] ocfs2: Fix NULL pointer dereferences in o2net
