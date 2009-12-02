From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 2 Dec 2009 14:54:05 -0800
Subject: [Ocfs2-devel] [PATCH] o2net: delay ENOTCONN for sends receives
 till quorum decision
In-Reply-To: <1258703846-23212-2-git-send-email-srinivas.eeda@oracle.com>
References: <1258703846-23212-1-git-send-email-srinivas.eeda@oracle.com>
	<1258703846-23212-2-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <20091202225405.GA31647@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Nov 19, 2009 at 11:57:26PM -0800, Srinivas Eeda wrote:
> The fix queues the quorum decision after network heartbeat timeout but avoids
> socket disconnects. The fix delays socket disconnects till O2HB_NODE_DOWN_CB
> event which is triggered on the surviving node after the node evictions happen.

	Since we never tear down the socket, we expect delayed messages
to arrive if we finally hear from the node, right?  Ok, then.  And we
never reconnect, we merely stay connected, which is why you dropped the
reconnect timeout and bumped the protocol?

Joel

-- 

Life's Little Instruction Book #464

	"Don't miss the magic of the moment by focusing on what's
	 to come."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
