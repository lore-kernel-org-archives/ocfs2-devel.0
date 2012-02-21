From: xiaowei.hu at oracle.com <xiaowei.hu@oracle.com>
Date: Tue, 21 Feb 2012 14:12:07 +0800
Subject: [Ocfs2-devel] Race condition between OCFS2 downconvert thread and
	ocfs2 cluster lock.
In-Reply-To: <xiaowei.hu@oracle.com>
References: <xiaowei.hu@oracle.com>
Message-ID: <1329804728-6146-1-git-send-email-xiaowei.hu@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I am trying to fix bug13611997,CT's machine run into BUG in ocfs2dc thread, BUG_ON(lockres->l_action != OCFS2_AST_CONVERT && lockres->l_action != OCFS2_AST_DOWNCONVERT); I analysized the vmcore , the lockres->l_action = OCFS2_AST_ATTACH and l_flags=326(which means OCFS2_LOCK_BUSY|OCFS2_LOCK_BLOCKED|OCFS2_LOCK_INITIALIZED|OCFS2_LOCK_QUEUED), after compared with the code , this status could be only possible during ocfs2_cluster_lock,here is the race situation:

NodeA								NodeB
ocfs2_cluster_lock on a new lockres M
spin_lock_irqsave(&lockres->l_lock, flags);
gen = lockres_set_pending(lockres);
lockres->l_action = OCFS2_AST_ATTACH;
lockres_or_flags(lockres, OCFS2_LOCK_BUSY);
spin_unlock_irqrestore(&lockres->l_lock, flags);

ocfs2_dlm_lock() finished and returned.
**and lockres_clear_pending(lockres, gen, osb);
							request a lock on the same lockres M
							It's blocked by nodeA, and a ast proxy was send to A

bast queued and flushed,before the ast was queued
then the ocfs2dc was scheduled
there is a chance to execute this code path:
ocfs2_downconvert_thread()
ocfs2_downconvert_thread_do_work()
ocfs2_blocking_ast()
ocfs2_process_blocked_lock()
ocfs2_unblock_lock()
	spin_lock_irqsave(&lockres->l_lock, flags);
	if (lockres->l_flags & OCFS2_LOCK_BUSY)
	    ret = ocfs2_prepare_cancel_convert(osb, lockres);
		BUG_ON(lockres->l_action != OCFS2_AST_CONVERT &&
               	       lockres->l_action != OCFS2_AST_DOWNCONVERT);
		here trigger the BUG()

Solution:
One possible solution for this is to remove the lockres_clear_pending marked by 2 stars, and left this clear work to the ast function.In this way could make sure the bast function wait for ast , let it clear OCFS2_LOCK_BUSY and set OCFS2_LOCK_ATTACHED first, before enter downconvert process.
 
