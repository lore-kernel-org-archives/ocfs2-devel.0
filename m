From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 14 Dec 2010 14:14:26 -0800
Subject: [Ocfs2-devel] Pin the configfs items while cluster is active
Message-ID: <1292364871-18461-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


All,

This patch series is long over-due. configfs added the ability to pin items
in commit 631d1febab8e546e3bb800bdfe2c212b8adf87de (Jun 2007). The following
patches make use of it in the O2CB cluster stack to pin both the node and
heartbeat items.

This has been tested for both local and global heartbeat modes.

Sunil
