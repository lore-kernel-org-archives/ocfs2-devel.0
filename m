From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Nov 20 15:00:54 2007
Subject: [Ocfs2-devel] [PATCH 1/2] Initalize bitmap_cpg of ocfs2_super
	to be the maximum,take 1
In-Reply-To: <20071116084110.GA3893@tma-pc1.cn.oracle.com>
References: <20071116082736.GA3732@tma-pc1.cn.oracle.com>
	<20071116084110.GA3893@tma-pc1.cn.oracle.com>
Message-ID: <20071120225859.GG28607@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Nov 16, 2007 at 04:41:10PM +0800, tao.ma wrote:
> This value is initialized from global_bitmap->id2.i_chain.cl_cpg. If there
> is only 1 group, it will be equal to the total clusters in the volume. So
> as for online resize, it should change for all the nodes in the cluster.
> It isn't easy and there is no corresponding lock for it.

Yeah, there's little point in having it that way. We probably want to update
mkfs.ocfs2 to write out the correct value.


> bitmap_cpg is only used in 2 areas:
> 1. Check whether the suballoc is too large for us to allocate from the global
>    bitmap, so it is little used. And now the suballoc size is 2048, it rarely
>    meet this situation and the check is almost useless.
> 2. Calculate which group a cluster belongs to. We use it during truncate to
>    figure out which cluster group an extent belongs too. But we should be OK
>    if we increase it though as the cluster group calculated shouldn't change
>    and we only ever have a small bitmap_cpg on file systems with a single
>    cluster group.

Did you test a very large extend on a very small (less than 1 cluster group)
file system?
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
