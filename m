From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 23 Jun 2008 15:34:50 -0700
Subject: [Ocfs2-devel] [PATCH 0/5][BUGFIX] configfs: Fix deadlock of
	rename() vs	rmdir()
In-Reply-To: <20080616232657.GE6441@mail.oracle.com>
References: <20080616170057.399713501@kerlabs.com>
	<20080616232657.GE6441@mail.oracle.com>
Message-ID: <20080623223450.GH592@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon, Jun 16, 2008 at 04:26:57PM -0700, Joel Becker wrote:
> 	Ok, this is in-tree for the next merge.  Thanks.

	Btw, we still need to solve the lockdep issue.  I'm leaning
towards turning it off for attach/detach_groups(), because any CHILD+N
level won't mesh with the VFS anyway.
	We also need a comment on detach_group() pointing out its
recursive locking.  It's there in the code, but it's not obvious.

Joel

-- 

"Not everything that can be counted counts, and not everything
 that counts can be counted."
        - Albert Einstein 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
