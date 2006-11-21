From: abeekhof@suse.de <abeekhof@suse.de>
Date: Tue Nov 21 07:12:38 2006
Subject: [Ocfs2-devel] [patch 0/1] OCFS Configurable timeouts - Revision 2
Message-ID: <20061121150256.370591000@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

The following is an update to the 3rd patch in the configurable timeouts series.
Changes to the original patch include:
- setting and checking of o2hb_heartbeat_timeout_ms in handshakes
- better logic in o2net_advance_rx() removing the need for dummy fields in o2net_msg struct
- tracks how many peers are connected
- prevents o2net_idle_timeout_ms and o2net_keepalive_delay_ms from being modified when we have connected peers

The rationale for including these changes in the final patch is that patch 2 creates the capability and patch 3 ensures it it used sanely across all nodes.

Still to come is a patch which makes use of the to_o2nm_cluster_from_node() function as previously suggested by Mark.

Andrew

--
