From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri Apr 30 11:57:27 2004
Subject: [Ocfs2-devel] What's your opinion on the patch to fix bug 58 for
	kernel 2.6 porting?
In-Reply-To: <37FBBA5F3A361C41AB7CE44558C3448E03B65E95@PDSMSX403.ccr.corp.intel.com>
References: <37FBBA5F3A361C41AB7CE44558C3448E03B65E95@PDSMSX403.ccr.corp.intel.com>
Message-ID: <20040430165258.GD26744@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Apr 30, 2004 at 09:19:19AM +0800, Zhang, Sonic wrote:
> 	In kernel 2.6 VFS routine sys_umount()->...->generic_shutdown_super(), if the inode usage count i_count is not 0, error information is reported. Then, the system will halt in routine kill_bdev()->truncate_inode_pages().
> 	If we don't fix it in OCFS2 driver, we have to change the kernel 2.6 VFS sys_umount code. Is it a good solution?

	The issue is not whether to fix it in the OCFS2 driver.  The
issue is solving the problem without resorting to ugly stuff like
signals.
	Can you provide a complete description of what happens to cause
the problem, so we can look at it?

Joel

-- 

"Depend on the rabbit's foot if you will, but remember, it didn't
 help the rabbit."
	- R. E. Shay

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
