From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 21 Jul 2009 18:13:33 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Use ocfs2_rec_clusters in
 ocfs2_adjust_adjacent_records.
In-Reply-To: <4A665E20.9040104@oracle.com>
References: <4A656FC9.4010404@oracle.com>
	<1248162126-21507-2-git-send-email-tao.ma@oracle.com>
	<20090721214051.GC19170@mail.oracle.com>
	<4A665E20.9040104@oracle.com>
Message-ID: <20090722011332.GK19170@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jul 22, 2009 at 08:32:32AM +0800, Tao Ma wrote:
> Joel Becker wrote:
> >On Tue, Jul 21, 2009 at 03:42:06PM +0800, Tao Ma wrote:
> >>In ocfs2_adjust_adjacent_records, we will adjust adjacent records
> >>according to the extent_list in the lower level. But actually
> >>the lower level tree will either be a leaf or a branch. So we
> >>shouldn't use ocfs2_is_empty_extent which is only valid for a
> >>tree leaf. Use ocfs2_rec_clusters instead. We will meet with some
> >>problem when the tree depth > 2.
> >
> >	I think you mean "if we leave it as checking e_leaf_clusters,
> >we'll have a problem rotating trees with depth > 2".  Is that right?
> >Can interior nodes have these empty l_rec[0]s?  If they can't, perhaps
> >we should be bugging?
> sorry, It should be tree_depth >=2.
> 
> ocfs2_adjust_adjacent_records is used to for rotation. And it only
> use e_cpos in most cases.
> So we don't have a problem if the lower 16 bits of e_int_clusters
> isn't equal to 0 for a branch.
> But if the low 16 bits are 0, this ocfs2_is_empty_extent will treat
> it as an empty record and use the l_recs[1] which will corrupt
> the tree. So let me give you a test case I meet.

	Oh, I understand the problem.  My comment above was that it
sounds like you said "Here's a fix, but the fix will still have problems
if tree depth is greater than two".  I think you mean "without this fix
we have problems when tree depth is greater than (or equal to) two".
	We need the fix.  Now let's figure out if we should bug on
interior children.

Joel

-- 

"Three o'clock is always too late or too early for anything you
 want to do."
        - Jean-Paul Sartre

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
