From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Thu, 8 Dec 2016 23:32:13 -0800
Subject: [Ocfs2-devel] [PATCH v3 0/8] ocfs2: wire up {clone, copy,
	dedupe}_range
In-Reply-To: <148064006267.14039.3248903225701175868.stgit@birch.djwong.org>
References: <148064006267.14039.3248903225701175868.stgit@birch.djwong.org>
Message-ID: <20161209073213.GK16807@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mfasheh@versity.com, akpm@linux-foundation.org, jlbec@evilplan.org
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, ocfs2-devel@oss.oracle.com

On Thu, Dec 01, 2016 at 04:54:22PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> This is the third submission of a series of patches that wire up the
> existing ocfs2 reflinking capabilities to the new(ish) VFS
> {copy,clone,dedupe}_range interface.  The first few patches clean up
> some minor bugs that I found; the last kernel patch contains the new
> code.  The last patch is a new; it fixes a quota accounting bug.
> 
> A few minor fixes to xfstests are needed to make more of the tests run;
> those have been sent separately to the fstests lists.  Some of the
> xfstests will fail because ocfs2's design does not allow sharing of
> blocks between disjoint sets of files with shared blocks.  That is to
> say, if A shares with B and C shares with D, B and C cannot be made to
> share blocks.
> 
> Andrew, could you please queue these up for testing?  I'd like to get
> them into 4.10 if possible.

It's been a week and nobody's written in any objections.  Andrew, could
this go into linux-next for some soak time?

--D

> 
> --D
> 
> [1] https://github.com/djwong/linux/tree/ocfs2-vfs-reflink-4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
