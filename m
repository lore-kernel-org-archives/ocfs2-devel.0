From: wengang wang <wen.gang.wang@oracle.com>
Date: Mon,  8 Jun 2009 13:36:40 +0800
Subject: [Ocfs2-devel] [SUGGESSTION 1/1] OCFS2: runtime tunable network idle
	timeout
Message-ID: <200906080538.n585cmss000404@acsinet15.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

backgroud:
	there is a network idle timeout regarding which a node is considered dead or network partition occures. 

problem:
	for some product environment, there is a special time during a day. in this special time, a backup work is happening over private network. at the time that the backup is going on, there is very very high load on network. this can lead to ocfs2 network idle timeout and when it can't connect back in time, some nodes have to be fensed out the cluster domain which is not really what we want.
	there is a configuration O2CB_IDLE_TIMEOUT_MS by which we can set the timeout value. but looks it takes effect on when o2cb service is restarted, so it's not possible to change it in the already running system.

suggestion:
	if we can modify the timeout value at runtime, it's better. we can add a proc file under /proc/fs/ocfs2_nodemanager, for example, idle_timeout, so that a userspace application(such as debugfs.ocfs2) can read/write the timeout value. before the customer run the backup, set the value to a big value(or to no limit) and set it back when backup finished.
	contents in /proc/fs/ocfs2_nodemanager/idle_timeout is the timeout value in MS. 0 means no limit.

if it's good, I'm glad to do it.

thanks,
wengang.
