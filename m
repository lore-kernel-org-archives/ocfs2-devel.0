From: TaoMa <tao.ma@oracle.com>
Date: Thu, 21 Aug 2008 12:00:35 +0800
Subject: [Ocfs2-devel] [PATCH 04/10] ocfs2: Make 'private' into 'object'
	on ocfs2_extent_tree.
In-Reply-To: <1219286905-28104-5-git-send-email-joel.becker@oracle.com>
References: <1219286905-28104-1-git-send-email-joel.becker@oracle.com>
	<1219286905-28104-5-git-send-email-joel.becker@oracle.com>
Message-ID: <48ACE863.1030709@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> The 'private' pointer was a way to store off xattr values, which don't
> live at a set place in the bh.  But the concept of "the object
> containing the extent tree" is much more generic.  For an inode it's the
> struct ocfs2_dinode, for an xattr value its the value.  Let's save off
> the 'object' at all times.  If NULL is passed to
> ocfs2_get_extent_tree(), 'object' is set to bh->b_data;
>
> Signed-off-by: Joel Becker <joel.becker@oracle.com>
>   
Signed-off-by: Tao Ma <tao.ma@oracle.com>
