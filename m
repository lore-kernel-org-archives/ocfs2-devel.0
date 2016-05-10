From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 9 May 2016 22:58:04 -0700
Subject: [Ocfs2-devel] ocfs2: fix recursive locking deadlock
In-Reply-To: <1462856023-13801-1-git-send-email-junxiao.bi@oracle.com>
References: <1462856023-13801-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <20160509225804.e4ba0fb054acb1d92fe3db44@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, 10 May 2016 12:53:41 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:

> These two patches is to fix recursive locking deadlock issues. As we
> talked with Mark before, recursive locking is not allowed in ocfs2,
> so these two patches fixes the deadlock issue with reverting back
> patches to avoid recursive locking. Please review.

2-3 years old so I guess it isn't a huge issue.  Did you consider
backporting into -stable kernels?
