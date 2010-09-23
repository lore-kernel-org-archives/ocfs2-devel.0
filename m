From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 23 Sep 2010 14:23:35 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: Sync inode flags with ext2.
In-Reply-To: <1284874949-3352-2-git-send-email-tao.ma@oracle.com>
References: <1284874949-3352-1-git-send-email-tao.ma@oracle.com>
	<1284874949-3352-2-git-send-email-tao.ma@oracle.com>
Message-ID: <20100923212335.GD6609@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, Sep 19, 2010 at 01:42:29PM +0800, Tao Ma wrote:
> We sync our inode flags with ext2 and define them by hex
> values. But actually in commit 3669567(4 years ago), all
> these values are moved to include/linux/fs.h. So we'd
> better also use them as what ext2 did. So sync our inode
> flags with ext2 by using FS_*.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

        This patch is now in the 'fixes' branch of ocfs2.git.

Joel

-- 

"The cynics are right nine times out of ten."  
        - H. L. Mencken

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
