From: TaoMa <tao.ma@oracle.com>
Date: Thu, 21 Aug 2008 16:03:18 +0800
Subject: [Ocfs2-devel] [PATCH 08/10] ocfs2: Create specific
	get_extent_tree functions.
In-Reply-To: <1219286905-28104-9-git-send-email-joel.becker@oracle.com>
References: <1219286905-28104-1-git-send-email-joel.becker@oracle.com>
	<1219286905-28104-9-git-send-email-joel.becker@oracle.com>
Message-ID: <48AD2146.8090107@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> A caller knows what kind of extent tree they have.  There's no reason
> they have to call ocfs2_get_extent_tree() with a NULL when they could
> just as easily call a specific function to their type of extent tree.
>
> Introduce ocfs2_dinode_get_extent_tree(),
> ocfs2_xattr_tree_get_extent_tree(), and
> ocfs2_xattr_value_get_extent_tree().  They only take the necessary
> arguments, calling into the underlying __ocfs2_get_extent_tree() to do
> the real work.
>
> __ocfs2_get_extent_tree() is the old ocfs2_get_extent_tree(), but
> without needing any switch-by-type logic.
>
> ocfs2_get_extent_tree() is now a wrapper around the specific calls.  It
> exists because a couple alloc.c functions can take et_type.  This will
> go later.
>
> Another benefit is that ocfs2_xattr_value_get_extent_tree() can take a
> struct ocfs2_xattr_value_root* instead of void*.  This gives us
> typechecking where we didn't have it before.
>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
>   
Signed-off-by: Tao Ma <tao.ma@oracle.com>
