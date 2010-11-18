From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 18 Nov 2010 15:43:08 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Stop tracking a negative
 dentry after dentry_iput().
In-Reply-To: <1289828349-24098-1-git-send-email-tristan.ye@oracle.com>
References: <1289828349-24098-1-git-send-email-tristan.ye@oracle.com>
Message-ID: <20101118234308.GJ19821@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Nov 15, 2010 at 09:39:09PM +0800, Tristan Ye wrote:
> I suddenly hit the problem during 2.6.37-rc1 regression test, which was
> introduced by commit '5e98d492406818e6a94c0ba54c61f59d40cefa4a'(Track
> negative entries v3), following scenario reproduces the issue easily:
> 
> Node A			Node B
> ================	============
> $touch 	testfile	
> 			$ls testfile
> $rm -rf testfile
> $touch 	testfile	
> 			$ls testfile
> 			ls: cannot access testfile: No such file or directory
> 
> This patch stops tracking the dentry which was negativated by a inode deletion,
> so as to force the revaliation in next lookup, in case we'll touch the inode
> again in the same node.
> 
> It didn't hurt the performance of multiple lookup for none-existed files anyway,
> while regresses a bit in the first try after a file deletion.
> 
> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>

	This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"Only a life lived for others is a life worth while."
							-Albert Einstein  

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
