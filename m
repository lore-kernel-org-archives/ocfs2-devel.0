From: Mark Fasheh <mfasheh@suse.de>
Date: Tue, 1 Sep 2015 10:55:50 -0700
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: fix a tiny case that inode can
	not removed.
In-Reply-To: <55E403EF.3060702@huawei.com>
References: <55E403EF.3060702@huawei.com>
Message-ID: <20150901175550.GH1145@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Aug 31, 2015 at 03:36:15PM +0800, jiangyiwen wrote:
> When running dirop_fileop_racer we found a case that inode
> can not removed.
> 
> 2 nodes, say Node A and Node B, mount the same ocfs2 volume. Create
> two dirs /race/1/ and /race/2/ in the filesystem.
> 
> Node A                            Node B
> rm -r /race/2/
>                                   mv /race/1/ /race/2/
> call ocfs2_unlink(), get
> the EX mode of /race/2/
>                                   wait for B unlock /race/2/
> decrease i_nlink of /race/2/ to 0,
> and add inode of /race/2/ into
> orphan dir, unlock /race/2/
>                                   got EX mode of /race/2/. because
>                                   /race/1/ is dir, so inc i_nlink
>                                   of /race/2/ and update into disk,
>                                   unlock /race/2/
> because i_nlink of /race/2/
> is not zero, this inode will
> always remain in orphan dir
> 
> This patch fixes this case by test whether i_nlink of new dir is zero.
> 
> Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>

Looks great, thanks

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
