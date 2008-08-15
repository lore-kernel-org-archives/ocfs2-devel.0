From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 14 Aug 2008 23:26:34 -0700
Subject: [Ocfs2-devel] [PATCH 04/15] Make extend allocation generic.
In-Reply-To: <48A541D5.2080102@oracle.com>
References: <489A94F4.90903@oracle.com>
	<1218061894-7693-4-git-send-email-tao.ma@oracle.com>
	<20080814200144.GB28875@mail.oracle.com>
	<48A52CDE.4020706@oracle.com>
	<20080814234722.GF17664@mail.oracle.com>
	<48A541D5.2080102@oracle.com>
Message-ID: <20080815062634.GA28988@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Aug 15, 2008 at 04:44:05PM +0800, Tao Ma wrote:
> 
> 
> Joel Becker wrote:
> > On Fri, Aug 15, 2008 at 03:14:38PM +0800, Tao Ma wrote:
> >> Joel Becker wrote:
> >>> On Thu, Aug 07, 2008 at 06:31:26AM +0800, Tao Ma wrote:
> >>>> The old ocfs2_do_extend_allocation is restrictly to be used in file
> >>>> extension. Now a new function named ocfs2_do_cluster_allocation will
> >>>> handle the issue of generic extend allocation and it is created in
> >>>> suballoc.c.
> >>> <snip> 
> >>>
> >>>> +int ocfs2_add_clusters_in_btree(struct ocfs2_super *osb,
> >>>> +				struct inode *inode,
> >>>> +				u32 *logical_offset,
> >>>> +				u32 clusters_to_add,
> >>>> +				int mark_unwritten,
> >>>> +				struct buffer_head *root_bh,
> >>>> +				struct ocfs2_extent_list *root_el,
> >>>> +				handle_t *handle,
> >>>> +				struct ocfs2_alloc_context *data_ac,
> >>>> +				struct ocfs2_alloc_context *meta_ac,
> >>>> +				enum ocfs2_alloc_restarted *reason_ret,
> >>>> +				enum ocfs2_extent_tree_type type)
> >>> 	It seems to me that if you have root_bh and type, you can create
> >>> an ocfs2_extent_tree and calculate root_el from that.  So you don't need
> >>> root_el in this function's arguments, and callers don't need to know how
> >>> to compute it.
> >> No we can't. For a ocfs2_xattr_value_root. It can be stored in any place 
> >> of a buffer_head, so we have to give it to this function.
> > 
> > 	But don't you later turn a private pointer into that thing?
> I think I know your meaning now.
> I have gone through the function and it doesn't create 
> ocfs2_extent_tree. So I don't think it is worth for us to just erase a 
> "parameter" in kernel stack while doing kmalloc+kfree, right?

	Why are you kmalloc()ing at all?  Every place you use
ocfs2_extent_tree() does this:

	struct ocfs2_extent_tree *et = NULL;

	et = ocfs2_new_extent_tree(bh, type);
	do_some_alloc(et);
	if (et)
		ocfs2_free_extent_tree(et);

You never actually pass the extent tree up to the caller or store it on
a pointer somewhere.  You could just as easily do this:

	struct ocfs2_extent_tree et;

	ocfs2_fill_extent_tree(&et, bh, type);
	do_some_alloc(&et);
	ocfs2_drop_extent_tree(&et);

and never kmalloc at all.  The et just lives on the current function's
stack, safely passed to all sub functions.
	If you ever do need to allocate an extent tree, you can always
kzalloc it and then call fill_extent_tree.  But since allocating is the
very rare case, why do it by default?

Joel

-- 

"There is shadow under this red rock.
 (Come in under the shadow of this red rock)
 And I will show you something different from either
 Your shadow at morning striding behind you
 Or your shadow at evening rising to meet you.
 I will show you fear in a handful of dust."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
