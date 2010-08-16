From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 16 Aug 2010 15:39:15 +0800
Subject: [Ocfs2-devel] [PATCH] CMWQ: Set workqueue name before we process
	one work.
Message-ID: <1281944355-4379-1-git-send-email-tao.ma@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>, Tejun Heo <tj@kernel.org>

Now in CMWQ, workqueue threads are named as 'kworker/*'. So it is
a little boring to see in the 'top'(below) and actually it isn't
meaningful for the users.
12606 root      20   0     0    0    0 S    2  0.0   0:03.22 kworker/u:0
12607 root      20   0     0    0    0 S    1  0.0   0:03.69 kworker/u:4

So this patch just try to set the proper workqueue name if it does
exist. Yes, workqueue now is a thread pool and the data may be not
accurate but I think it is better(below) than the 'kworker*' stuff.
And if there is something block the workqueue, we can find the caller
easily.
12606 root      20   0     0    0    0 D    2  0.0   0:02.90 dlm_wq
12607 root      20   0     0    0    0 D    0  0.0   0:03.21 ocfs2_wq

What's more, in ocfs2, we sometimes want to print some debug info in
the system log and we use 'current->comm' to print the thread and this
change also does help.

The only thing I am not clear is that do we need [gs]et_task_comm?
I guess not and this patch just try to use strlcpy without task_lock.

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 kernel/workqueue.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2994a0e..69402f8 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1730,6 +1730,7 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
 	work_func_t f = work->func;
 	int work_color;
 	struct worker *collision;
+	char comm_saved[TASK_COMM_LEN];
 #ifdef CONFIG_LOCKDEP
 	/*
 	 * It is permissible to free the struct work_struct from
@@ -1790,7 +1791,16 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
 	work_clear_pending(work);
 	lock_map_acquire(&cwq->wq->lockdep_map);
 	lock_map_acquire(&lockdep_map);
+	if (cwq->wq->name) {
+		strlcpy(comm_saved, worker->task->comm,
+			sizeof(comm_saved));
+		strlcpy(worker->task->comm, cwq->wq->name,
+			sizeof(worker->task->comm));
+	}
 	f(work);
+	if (cwq->wq->name)
+		strlcpy(worker->task->comm, comm_saved,
+			sizeof(worker->task->comm));
 	lock_map_release(&lockdep_map);
 	lock_map_release(&cwq->wq->lockdep_map);
 
-- 
1.7.1.GIT
