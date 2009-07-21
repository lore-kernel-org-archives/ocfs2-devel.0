From: Joel Becker <Joel.Becker@Oracle.com>
Date: Tue, 21 Jul 2009 14:40:51 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Use ocfs2_rec_clusters in
 ocfs2_adjust_adjacent_records.
In-Reply-To: <1248162126-21507-2-git-send-email-tao.ma@oracle.com>
References: <4A656FC9.4010404@oracle.com>
	<1248162126-21507-2-git-send-email-tao.ma@oracle.com>
Message-ID: <20090721214051.GC19170@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jul 21, 2009 at 03:42:06PM +0800, Tao Ma wrote:
> In ocfs2_adjust_adjacent_records, we will adjust adjacent records
> according to the extent_list in the lower level. But actually
> the lower level tree will either be a leaf or a branch. So we
> shouldn't use ocfs2_is_empty_extent which is only valid for a
> tree leaf. Use ocfs2_rec_clusters instead. We will meet with some
> problem when the tree depth > 2.

	I think you mean "if we leave it as checking e_leaf_clusters,
we'll have a problem rotating trees with depth > 2".  Is that right?
Can interior nodes have these empty l_rec[0]s?  If they can't, perhaps
we should be bugging?

Joel

-- 

Life's Little Instruction Book #24

	"Drink champagne for no reason at all."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
