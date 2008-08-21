From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 20 Aug 2008 18:21:06 -0700
Subject: [Ocfs2-devel] [PATCH 07/16] Add extent tree operation for xattr
	value.
In-Reply-To: <48ACBECD.4010506@oracle.com>
References: <48A929A4.90103@oracle.com>
	<1219052334-10415-7-git-send-email-tao.ma@oracle.com>
	<20080821005737.GB28632@mail.oracle.com>
	<48ACBECD.4010506@oracle.com>
Message-ID: <20080821012106.GC4563@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

[ Joel, good catch ]

On Thu, Aug 21, 2008 at 09:03:09AM +0800, Tao Ma wrote:
> > BUG when growing that xattr extent tree?
> > 	Next, a few lines down:
> >
> >         mlog_bug_on_msg(!ocfs2_sparse_alloc(osb) &&
> >                         (OCFS2_I(inode)->ip_clusters != cpos),
> >                         "Device %s, asking for sparse allocation: inode %llu, "
> >                         "cpos %u, clusters %u\n",
> >                         osb->dev_str,
> >                         (unsigned long long)OCFS2_I(inode)->ip_blkno, cpos,
> >                         OCFS2_I(inode)->ip_clusters);
> >
> > Won't that BUG() when cpos of an xattr extent is not matching the
> > ip_clusters of the data?
> >   
> yeah, you are right, we should move these 2 into 
> ocfs2_dinode_insert_extent. thx.

It might be a good idea for us to run this on a file system without sparse
file support to catch any issues that don't show up during review. Probably,
running with / without inline-data helps too. Conceptually though, we should
be safe - anything that supports EA's has all the sparse-file code,
regardless of whether we allow the inode data btree to be sparse or not.
It's all just a matter of making sure the proper checks are in the right
place.
	--Mark

--
Mark Fasheh
