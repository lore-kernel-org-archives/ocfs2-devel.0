From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu Nov 30 17:50:28 2006
Subject: [Ocfs2-devel] [patch 0/1] OCFS Configurable timeouts - Revision 2
In-Reply-To: <20061129085130.004252000@suse.de>
References: <20061129085130.004252000@suse.de>
Message-ID: <20061201015023.GG26014@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Nov 29, 2006 at 09:51:30AM +0100, abeekhof@suse.de wrote:
> Added a global spinlock around modifications to o2net_connected_peer (as discussed with Mark).
> 
> I have a separate patch that uses to_o2nm_cluster_from_node() but since I cant reproduce the problem mentioned in Jeff's comment (it apparently needs the userspace heartbeating modifications), I'd prefer to leave it out.

	Which problem do you mean?  I'm trying to know if the callback
changes (->disconnect_notify()) make you happy and are good enough to
push towards mainline.  Have you tested with them, etc?

Joel

-- 

Bram's Law:
	The easier a piece of software is to write, the worse it's
	implemented in practice.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
