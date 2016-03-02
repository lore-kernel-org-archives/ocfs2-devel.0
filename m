From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed,  2 Mar 2016 15:56:06 +0800
Subject: [Ocfs2-devel] ocfs2: o2hb: not fence self if storage down
Message-ID: <1456905372-22313-1-git-send-email-junxiao.bi@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Hi Mark,

This serial of patches is to fix the issue that when storage down,
all nodes will fence self due to write timeout.
With this patch set, all nodes will keep going until storage back
online, except if the following issue happens, then all nodes will
do as before to fence self.
1. io error got
2. network between nodes down
3. nodes panic

---
Changes from V1:
- code style fix.

Junxiao Bi (6):
      ocfs2: o2hb: add negotiate timer
      ocfs2: o2hb: add NEGO_TIMEOUT message
      ocfs2: o2hb: add NEGOTIATE_APPROVE message
      ocfs2: o2hb: add some user/debug log
      ocfs2: o2hb: don't negotiate if last hb fail
      ocfs2: o2hb: fix hb hung time

fs/ocfs2/cluster/heartbeat.c |  180 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 174 insertions(+), 6 deletions(-)


Thanks,
Junxiao.
