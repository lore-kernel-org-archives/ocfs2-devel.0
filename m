From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 23 Jul 2009 11:10:23 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Use ocfs2_rec_clusters in
 ocfs2_adjust_adjacent_records. v2
In-Reply-To: <1248307978-23411-1-git-send-email-tao.ma@oracle.com>
References: <20090722011332.GK19170@mail.oracle.com>
	<1248307978-23411-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20090723181023.GC25533@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 23, 2009 at 08:12:58AM +0800, Tao Ma wrote:
> Hi Joel,
> 	how about this? I add a bug_on  and change the commit log some how.
> 
> Regards,
> Tao
> 
> In ocfs2_adjust_adjacent_records, we will adjust adjacent records
> according to the extent_list in the lower level. But actually
> the lower level tree will either be a leaf or a branch. If we only
> use ocfs2_is_empty_extent we will meet with some problem if the lower
> tree is a branch(tree_depth > 1). So use !ocfs2_rec_clusters instead.
> And actually only the leaf record can have holes. So add a BUG_ON
> for non-leaf branch.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

This is now in the fixes branch of ocfs2.git.

Joel

-- 

"The cynics are right nine times out of ten."  
        - H. L. Mencken

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
