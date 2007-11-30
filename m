From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Nov 30 11:47:44 2007
Subject: [Ocfs2-devel] [PATCH 1/3] Initalize bitmap_cpg of ocfs2_super
	to be the maximum.
In-Reply-To: <20071127082019.GA4461@tma-pc1.cn.oracle.com>
References: <20071127081123.GA4345@tma-pc1.cn.oracle.com>
	<20071127082019.GA4461@tma-pc1.cn.oracle.com>
Message-ID: <20071130194736.GE28607@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Nov 27, 2007 at 04:20:19PM +0800, tao.ma wrote:
> This value is initialized from global_bitmap->id2.i_chain.cl_cpg. If there
> is only 1 group, it will be equal to the total clusters in the volume. So
> as for online resize, it should change for all the nodes in the cluster.
> It isn't easy and there is no corresponding lock for it.
> bitmap_cpg is only used in 2 areas:
> 1. Check whether the suballoc is too large for us to allocate from the global
>    bitmap, so it is little used. And now the suballoc size is 2048, it rarely
>    meet this situation and the check is almost useless.
> 2. Calculate which group a cluster belongs to. We use it during truncate to
>    figure out which cluster group an extent belongs too. But we should be OK
>    if we increase it though as the cluster group calculated shouldn't change
>    and we only ever have a small bitmap_cpg on file systems with a single
>    cluster group.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

Ok, I'm going to start carrying this patch in ocfs2.git as I think it's
pretty straightforward and a win regardless of how the rest of the online
resize stuff goes. You don't have to change how you're sending these patches
though - just keep re-sending this one with my signoff and I'll handle
merging things when the rest of the resize work is done.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
