From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 22 Dec 2010 12:39:36 -0800
Subject: [Ocfs2-devel] o2net timing stats
Message-ID: <1293050382-3636-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Patches replace struct timeval with ktime_t (hrtimer) to track o2net
timings in struct o2net_send_tracking and struct o2net_sock_container.

Also maintains a cumulative total of all the times that is user accessible
via a debugfs file, o2net/stats.

The stats are enabled with CONFIG_OCFS2_FS_STATS which itself has been
made dependent on CONFIG_DEBUG_FS.

Sunil 
