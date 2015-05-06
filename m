From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 6 May 2015 15:25:11 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix BUG in
	ocfs2_downconvert_thread_do_work
In-Reply-To: <5549F736.7000405@huawei.com>
References: <5549F736.7000405@huawei.com>
Message-ID: <20150506152511.01471fa95840182dbaa9c546@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, 6 May 2015 19:12:54 +0800 Joseph Qi <joseph.qi@huawei.com> wrote:

> BUG_ON(list_empty(&osb->blocked_lock_list)) in
> ocfs2_downconvert_thread_do_work can be triggered in the following case:
> ocfs2dc has firstly saved osb->blocked_lock_count to local varibale
> processed, and then processes the dentry lockres.
> During the dentry put, it calls iput and then deletes rw, inode and
> open lockres from blocked list in ocfs2_mark_lockres_freeing.
> And this casues the variable processed is not the number of blocked
> lockres to be processed and then triggers the BUG.
> 
> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
> Cc: <stable@vger.kernel.org>

cc:stable means I'd like to merge this into 4.1-rcx.  Can we get some
acks, please?
