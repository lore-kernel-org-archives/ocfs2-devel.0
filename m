From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 19 Feb 2009 09:38:43 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: set xh_free_start when xattr
	header in	inode/block
In-Reply-To: <499BB514.7020709@oracle.com>
References: <49991812.3090005@oracle.com>
	<1234770198-9926-1-git-send-email-tiger.yang@oracle.com>
	<499BB514.7020709@oracle.com>
Message-ID: <20090219173843.GC15753@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 18, 2009 at 03:13:24PM +0800, Tiger Yang wrote:
> Hi, Joel and Mark,
>
> I suddenly found there might be a potential problem in this patch.
>
> If user setting EAs sometimes with .28 kernel and sometimes with .29 
> kernel, xh_free_start will go stale. And fsck will make it worse.
>
> If this really a problem I withdraw this patch but I think the second patch 
> is OK.

Tiger,
	I think you are right.  We're going to have to give up on
updating xh_free_start in inode/block.  fsck will just have to try to
verify that the entrys and values don't overlap.
	Please respin the second patch without the first, code up fsck
appropriately.

Joel

-- 

"Under capitalism, man exploits man.  Under Communism, it's just 
   the opposite."
				 - John Kenneth Galbraith

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
