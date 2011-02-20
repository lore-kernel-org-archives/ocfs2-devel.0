From: Joel Becker <jlbec@evilplan.org>
Date: Sun, 20 Feb 2011 04:07:58 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Use hrtimer to track ocfs2 fs lock
 stats
In-Reply-To: <1293607563-29283-1-git-send-email-sunil.mushran@oracle.com>
References: <1293607563-29283-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20110220120758.GH17784@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Dec 28, 2010 at 11:26:03PM -0800, Sunil Mushran wrote:
> Patch makes use of the hrtimer to track times in ocfs2 lock stats.
> 
> The patch is a bit involved to ensure no additional impact on the memory
> footprint. The size of ocfs2_inode_cache remains 1280 bytes on 32-bit systems.
> 
> A related change was to modify the unit of the max wait time from nanosec to
> microsec allowing us to track max time larger than 4 secs. This change
> necessitated the bumping of the output version in the debugfs file,
> locking_state, from 2 to 3.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

	This patch is now in the merge-window branch of ocfs2.git.

Joel

-- 

Life's Little Instruction Book #198

	"Feed a stranger's expired parking meter."

			http://www.jlbec.org/
			jlbec at evilplan.org
