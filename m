From: Joel Becker <jlbec@evilplan.org>
Date: Sun, 20 Feb 2011 02:41:09 -0800
Subject: [Ocfs2-devel] ocfs2: Check heartbeat mode for kernel stacks only
In-Reply-To: <20110131193104.GG23899@wotan.suse.de>
References: <20110131193104.GG23899@wotan.suse.de>
Message-ID: <20110220104108.GE17784@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jan 31, 2011 at 11:31:04AM -0800, Mark Fasheh wrote:
> Commit 2c442719e90a44a6982c033d69df4aae4b167cfa added some checks for proper
> heartbeat mode when the o2cb stack is running.  Unfortunately, it didn't
> take into account that a userpsace stack could be running. Fix this by only
> doing the check if o2cb is in use. This patch allows userspace stacks to
> mount the fs again.
> 
> Cc: stable at kernel.org
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>

	This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"Where are my angels?
 Where's my golden one?
 And where is my hope
 Now that my heroes are gone?"

			http://www.jlbec.org/
			jlbec at evilplan.org
