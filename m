From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 29 Mar 2018 14:45:23 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: don't evaluate buffer head to NULL
 managed by caller
In-Reply-To: <1522289162-31693-1-git-send-email-ge.changwei@h3c.com>
References: <1522289162-31693-1-git-send-email-ge.changwei@h3c.com>
Message-ID: <20180329144523.91722a7b35c8ad17d3f1375e@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 29 Mar 2018 10:06:02 +0800 Changwei Ge <ge.changwei@h3c.com> wrote:

> ocfs2_read_blocks() is used to read several blocks from disk.
> Currently, the input argument *bhs* can be NULL or NOT. It depends on
> the caller's behavior. If the function fails in reading blocks from
> disk, the corresponding bh will be assigned to NULL and put.
> 
> Obviously, above process for non-NULL input bh is not appropriate.
> Because the caller doesn't even know its bhs are put and re-assigned.
> 
> If buffer head is managed by caller, ocfs2_read_blocks should not
> evaluate it to NULL. It will cause caller accessing illegal memory,
> thus crash.

(What about ocfs2_read_blocks_sync()?)

Passing non-NULL entries in bhs[] looks like a weird thing to do.  Do
any callers actually do this?  And of they do, do they actually care
about the alteration of bhs[] if the call failed?
