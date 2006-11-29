From: abeekhof@suse.de <abeekhof@suse.de>
Date: Wed Nov 29 01:04:22 2006
Subject: [Ocfs2-devel] [patch 0/1] OCFS Configurable timeouts - Revision 2
Message-ID: <20061129085130.004252000@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hopefully this is the final version :-)

--

Added a global spinlock around modifications to o2net_connected_peer (as discussed with Mark).

I have a separate patch that uses to_o2nm_cluster_from_node() but since I cant reproduce the problem mentioned in Jeff's comment (it apparently needs the userspace heartbeating modifications), I'd prefer to leave it out.


Andrew
