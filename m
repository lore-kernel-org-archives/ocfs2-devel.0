From: Christoph Hellwig <hch@infradead.org>
Date: Fri, 9 Dec 2016 00:22:53 -0800
Subject: [Ocfs2-devel] [PATCH v3 0/8] ocfs2: wire up {clone, copy,
	dedupe}_range
In-Reply-To: <20161209073213.GK16807@birch.djwong.org>
References: <148064006267.14039.3248903225701175868.stgit@birch.djwong.org>
	<20161209073213.GK16807@birch.djwong.org>
Message-ID: <20161209082253.GA10811@infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: mfasheh@versity.com, akpm@linux-foundation.org, jlbec@evilplan.org, linux-fsdevel@vger.kernel.org, hch@infradead.org, ocfs2-devel@oss.oracle.com

On Thu, Dec 08, 2016 at 11:32:13PM -0800, Darrick J. Wong wrote:
> It's been a week and nobody's written in any objections.  Andrew, could
> this go into linux-next for some soak time?

I'm mostly fine with my series, but I would much prefer if this went
on top of my patch to implement the copy -> clone fallback in the core
to avoid creating annoying merge conflicts.
