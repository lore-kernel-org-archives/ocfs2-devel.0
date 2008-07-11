From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 11 Jul 2008 15:07:40 -0700
Subject: [Ocfs2-devel] [BUGFIX][PATCH v2 0/2] configfs: Fix cleanup
	after mkdir()	failure
In-Reply-To: <1215183366-17479-1-git-send-email-louis.rilling@kerlabs.com>
References: <1215183366-17479-1-git-send-email-louis.rilling@kerlabs.com>
Message-ID: <20080711220740.GC22577@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <louis.rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Fri, Jul 04, 2008 at 04:56:04PM +0200, Louis Rilling wrote:
> This patchset fixes two kinds of bugs happening when
> configfs_attach_group()/configfs_attach_item() fail and userspace races with
> mkdir() or symlink().

	Ok, I've merged all this work.  Please check out my configfs-ALL
branch and make sure I have everything we've worked on.

http://oss.oracle.com/git/?p=jlbec/linux-2.6.git;a=shortlog;h=configfs-ALL
git://oss.oracle.com/git/jlbec/linux-2.6.git configfs-ALL

Joel

-- 

Life's Little Instruction Book #335

	"Every so often, push your luck."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
