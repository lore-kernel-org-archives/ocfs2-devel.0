From: Joel Becker <jlbec@evilplan.org>
Date: Sun, 20 Feb 2011 02:40:44 -0800
Subject: [Ocfs2-devel] [PATCH 01/14] Ocfs2/refcounttree: Fix a bug for
 refcounttree to writeback clusters in a right number.
In-Reply-To: <1295605231-15991-2-git-send-email-tristan.ye@oracle.com>
References: <1295605231-15991-1-git-send-email-tristan.ye@oracle.com>
	<1295605231-15991-2-git-send-email-tristan.ye@oracle.com>
Message-ID: <20110220104043.GD17784@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 21, 2011 at 06:20:18PM +0800, Tristan Ye wrote:
> Current refcounttree codes actually didn't writeback the new pages out in
> write-back mode, due to a bug of always passing a ZERO number of clusters
> to 'ocfs2_cow_sync_writeback', the patch tries to pass a proper one in.
> 
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>

	This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

Life's Little Instruction Book #232

	"Keep your promises."

			http://www.jlbec.org/
			jlbec at evilplan.org
