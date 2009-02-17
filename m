From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 16 Feb 2009 21:44:49 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Use the right access_* method in
	ctime update	of xattr.
In-Reply-To: <1234816768-8571-1-git-send-email-tao.ma@oracle.com>
References: <1234816768-8571-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090217054449.GC5489@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Feb 17, 2009 at 04:39:28AM +0800, Tao Ma wrote:
> In ctime updating of xattr, it use the wrong type of access for
> inode, so use ocfs2_journal_access_di instead.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

	Eek!  How did tristan's and my testing miss this?  Mark, this is
a bugfix for .29.

Signed-off-by: Joel Becker <joel.becker@oracle.com>

-- 

"In the beginning, the universe was created. This has made a lot 
 of people very angry, and is generally considered to have been a 
 bad move."
        - Douglas Adams

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
