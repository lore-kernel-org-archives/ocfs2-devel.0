From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 4 May 2009 10:06:24 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Don't print error when listing too
	many xattrs.
In-Reply-To: <1241385489-24389-1-git-send-email-tao.ma@oracle.com>
References: <1241385489-24389-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090504170624.GC31249@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, May 04, 2009 at 05:18:09AM +0800, Tao Ma wrote:
> Currently, when listing xattrs, kernel define XATTR_LIST_MAX as 65536
> in include/linux/limits.h, so it can't handle too many xattrs.
> 
> But with ocfs2 xattr tree, we actually have no limit for the number.
> And it will pollute the message with something like this when listing.
> (27738,0):ocfs2_iterate_xattr_buckets:3158 ERROR: status = -34
> (27738,0):ocfs2_xattr_tree_list_index_block:3264 ERROR: status = -34
> 
> So don't print "ERROR" message as this is not an ocfs2 error.

	Hmm, but this will stop iteration of the xattrs right where we
hit the large one.  I don't think that's correct.  At the very least, we
should go on listing with the following xattrs.
	Now, the xattr with a too-long name - should we skip it, or
should we list a truncated name?  That I'm not sure of.

Joel

-- 

 print STDOUT q
 Just another Perl hacker,
 unless $spring
	- Larry Wall

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
