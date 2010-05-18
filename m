From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 18 May 2010 12:15:21 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Don't retry xattr set in case
 value extension fails.
In-Reply-To: <1273762145-1868-1-git-send-email-tao.ma@oracle.com>
References: <1273762145-1868-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100518191521.GB3239@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, May 13, 2010 at 10:49:05PM +0800, Tao Ma wrote:
> In normal xattr set, the set sequence is inode, xattr block
> and finally xattr bucket if we meet with a ENOSPC. But there
> is a corner case.
> So consider we will set a xattr whose value will be stored in
> a cluster, and there is no xattr block by now. So we will
> reserve 1 xattr block and 1 cluster for setting it. Now if we
> fail in value extension(in case the volume is almost full and
> we can't allocate the cluster because the check in
> ocfs2_test_bg_bit_allocatable), ENOSPC will be returned. So
> we will try to create a bucket(this time there is a chance that
> the reserved cluster will be used), and when we try value extension
> again, kernel bug happens. We did meet with it. Check the bug below.
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1251
> 
> This patch just try to avoid this by adding a set_abort in
> ocfs2_xattr_set_ctxt, so in case ENOSPC happens in value extension,
> we will check whether it is caused by the real ENOSPC or just the
> full of inode or xattr block. If it is the first case, we set set_abort
> so that we don't try any further. we are safe to exit directly here
> ince it is really ENOSPC.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

This patch is now in the 'fixes' branch of ocfs2.git.

Joel

-- 

Life's Little Instruction Book #314

	"Never underestimate the power of forgiveness."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
