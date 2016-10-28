From: Christoph Hellwig <hch@lst.de>
Date: Fri, 28 Oct 2016 08:20:56 +0200
Subject: [Ocfs2-devel] [RFC] Should we revert commit "ocfs2: take
	inode	lock in ocfs2_iop_set/get_acl()"? or other ideas?
In-Reply-To: <1476854382-28101-1-git-send-email-zren@suse.com>
References: <1476854382-28101-1-git-send-email-zren@suse.com>
Message-ID: <20161028062056.GA9994@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Ren <zren@suse.com>
Cc: ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org

Hi Eric,

I've added linux-fsdevel to the cc list as this should get a bit
broader attention.

On Wed, Oct 19, 2016 at 01:19:40PM +0800, Eric Ren wrote:
> Mostly, we can avoid recursive locking by writing code carefully. However, as
> the deadlock issues have proved out, it's very hard to handle the routines
> that are called directly by vfs. For instance:
> 
>     const struct inode_operations ocfs2_file_iops = {
>             .permission     = ocfs2_permission,
>             .get_acl        = ocfs2_iop_get_acl,
>             .set_acl        = ocfs2_iop_set_acl,
>     };
> 
> 
> ocfs2_permission() and ocfs2_iop_get/set_acl() both call ocfs2_inode_lock().
> The problem is that the call chain of ocfs2_permission() includes *_acl().

What do you actually protect in ocfs2_permission?  It's a trivial
wrapper around generic_permission which just looks at the VFS inode.

I think the right fix is to remove ocfs2_permission entirely and use
the default VFS implementation.  That both solves your locking problem,
and it will also get you RCU lookup instead of dropping out of
RCU mode all the time.
