From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 10 Sep 2010 09:21:41 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2/lockdep: Move ip_xattr_sem out
 of ocfs2_xattr_get_nolock.
In-Reply-To: <1283837406-15685-1-git-send-email-tao.ma@oracle.com>
References: <4C85CD9F.2080501@oracle.com>
	<1283837406-15685-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100910162141.GB17223@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 07, 2010 at 01:30:05PM +0800, Tao Ma wrote:
> As the name shows, we shouldn't have any lock in
> ocfs2_xattr_get_nolock. so lift ip_xattr_sem to the caller.
> This should be safe for us since the only 2 callers are:
> 1. ocfs2_xattr_get which will lock the resources.
> 2. ocfs2_mknod which don't need this locking.

	This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"You cannot bring about prosperity by discouraging thrift. You cannot
 strengthen the weak by weakening the strong. You cannot help the wage
 earner by pulling down the wage payer. You cannot further the
 brotherhood of man by encouraging class hatred. You cannot help the
 poor by destroying the rich. You cannot build character and courage by
 taking away a man's initiative and independence. You cannot help men
 permanently by doing for them what they could and should do for
 themselves."
	- Abraham Lincoln 

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
