From: Joseph Qi <joseph.qi@huawei.com>
Date: Sat, 18 May 2013 14:27:56 +0800
Subject: [Ocfs2-devel] ocfs2: Question for ocfs2_recovery_thread
Message-ID: <51971F6C.1000002@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,
Once there is node down in the cluster, ocfs2_recovery_thread will be
triggered on each node. These threads then do the down node recovery by
get super lock.
I have several questions on this:
1) Why each node has to run such a thread? We know at last one node can
get the super lock and do the actual recovery.
2) If this thread is running but something error occurred, take
ocfs2_super_lock failed for example, the thread will exit without
clearing recovery map, will it cause other threads still waiting for
recovery in ocfs2_wait_for_recovery?
