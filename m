From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 10 Sep 2010 09:21:59 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Fix lockdep warning in reflink.
In-Reply-To: <1283837406-15685-2-git-send-email-tao.ma@oracle.com>
References: <4C85CD9F.2080501@oracle.com>
	<1283837406-15685-2-git-send-email-tao.ma@oracle.com>
Message-ID: <20100910162159.GC17223@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 07, 2010 at 01:30:06PM +0800, Tao Ma wrote:
> This patch change mutex_lock to a new subclass and
> add a new inode lock subclass for the target inode
> which caused this lockdep warning.

	This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"There is no sincerer love than the love of food."  
         - George Bernard Shaw 

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
