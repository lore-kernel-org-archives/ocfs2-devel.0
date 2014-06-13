From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 13 Jun 2014 14:19:58 -0700
Subject: [Ocfs2-devel] [patch V2] ocfs2: fix a tiny race when
	running	dirop_fileop_racer
In-Reply-To: <539ABB95.7020908@huawei.com>
References: <539ABB95.7020908@huawei.com>
Message-ID: <20140613211958.GK5484@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 13, 2014 at 04:51:33PM +0800, jiangyiwen wrote:
> When running dirop_fileop_racer we found a dead lock case.
> 
> 2 nodes, say Node A and Node B, mount the same ocfs2 volume.  Create
> /race/16/1 in the filesystem, and let the inode number of dir 16 is less
> than the inode number of dir race.
> 
> Node A                            Node B
> mv /race/16/1 /race/
>                                   right after Node A has got the
>                                   EX mode of /race/16/, and tries to
>                                   get EX mode of /race
>                                   ls /race/16/
> 
> In this case, Node A has got the EX mode of /race/16/, and wants to get EX
> mode of /race/.  Node B has got the PR mode of /race/, and wants to get
> the PR mode of /race/16/.  Since EX and PR are mutually exclusive, dead
> lock happens.
> 
> This patch fixes this case by locking in ancestor order before trying
> inode number order.
> 
> Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
