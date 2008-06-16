From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 16 Jun 2008 16:26:57 -0700
Subject: [Ocfs2-devel] [PATCH 0/5][BUGFIX] configfs: Fix deadlock of
	rename() vs	rmdir()
In-Reply-To: <20080616170057.399713501@kerlabs.com>
References: <20080616170057.399713501@kerlabs.com>
Message-ID: <20080616232657.GE6441@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon, Jun 16, 2008 at 07:00:57PM +0200, Louis Rilling wrote:
> This patchset fixes the deadlock described below. This second version of the
> patchset fixes another long-standing bug in symlinks locking. Please read the
> headers of the third and fourth patches for a detailed explanation of the
> bugfixes. The last patch fixes a new behavior introduced by the deadlock fix,
> and that ones could find undesirable. Whether it is really needed or not is
> debatable.

	Ok, this is in-tree for the next merge.  Thanks.

Joel

-- 

"There is no sincerer love than the love of food."  
         - George Bernard Shaw 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
