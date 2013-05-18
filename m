From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Sat, 18 May 2013 06:26:05 -0700
Subject: [Ocfs2-devel] ocfs2: Question for ocfs2_recovery_thread
In-Reply-To: <51971F6C.1000002@huawei.com>
References: <51971F6C.1000002@huawei.com>
Message-ID: <CD83871B-2C0E-48ED-B037-1B49AF0B98C9@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The first node that gets the lock will do the actual recovery. The others will get the lock and see a clean journal and skip the recovery. A thread should never error out if it fails to get the lock. It should try and try again.

On May 17, 2013, at 11:27 PM, Joseph Qi <joseph.qi@huawei.com> wrote:

> Hi,
> Once there is node down in the cluster, ocfs2_recovery_thread will be
> triggered on each node. These threads then do the down node recovery by
> get super lock.
> I have several questions on this:
> 1) Why each node has to run such a thread? We know at last one node can
> get the super lock and do the actual recovery.
> 2) If this thread is running but something error occurred, take
> ocfs2_super_lock failed for example, the thread will exit without
> clearing recovery map, will it cause other threads still waiting for
> recovery in ocfs2_wait_for_recovery?
> 
