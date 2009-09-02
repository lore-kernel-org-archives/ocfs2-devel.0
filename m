From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 02 Sep 2009 10:50:42 +0800
Subject: [Ocfs2-devel] [PATCH 13/14] ocfs2: Set xattr block entries with
	ocfs2_xa_set()
In-Reply-To: <1251448563-12508-14-git-send-email-joel.becker@oracle.com>
References: <1251448563-12508-1-git-send-email-joel.becker@oracle.com>
	<1251448563-12508-14-git-send-email-joel.becker@oracle.com>
Message-ID: <4A9DDD82.3040100@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> ocfs2_xattr_block_set() calls into ocfs2_xattr_set_entry() with just the
> HAS_XATTR flag.  Most of the machinery of ocfs2_xattr_set_entry() is
> skipped.  All that really happens other than the call to ocfs2_xa_set()
> is making sure the HAS_XATTR flag is set on the inode.
> 
> But HAS_XATTR should be set when we also set di->i_xattr_loc.  And
> that's done in ocfs2_xattr_block_set().  So let's move it there, and
it is done in ocfs2_create_xattr_block actually. ;)
Otherwise it looks good.

Regards,
Tao
