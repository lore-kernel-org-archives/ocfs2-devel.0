From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 5 May 2009 16:11:50 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Don't print error when listing too
	many xattrs.
In-Reply-To: <1241385489-24389-1-git-send-email-tao.ma@oracle.com>
References: <1241385489-24389-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090505231150.GT7835@mail.oracle.com>
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
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

	This is in 'fixes' now.

Joel

-- 

"Egotist: a person more interested in himself than in me."
         - Ambrose Bierce 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
