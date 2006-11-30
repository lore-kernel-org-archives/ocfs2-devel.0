From: abeekhof@suse.de <abeekhof@suse.de>
Date: Thu Nov 30 10:22:21 2006
Subject: [Ocfs2-devel] [patch 0/3] OCFS Configurable timeouts - Revision 3
Message-ID: <20061130181128.860671000@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

One more go... :-)

Incorporate Mark and Zach's feedback
- Formating and logging
- Ignore o2net_msg's until a successful handshake has occured
- Undid changes allowing an error condition to be ignored in o2net_advance_rx()
- Repair the logic in the configfs update methods
- Use atomic_t instead of spinlocks for updating the counter of connected peers

--

Andrew
