From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 14 Aug 2008 16:47:22 -0700
Subject: [Ocfs2-devel] [PATCH 04/15] Make extend allocation generic.
In-Reply-To: <48A52CDE.4020706@oracle.com>
References: <489A94F4.90903@oracle.com>
	<1218061894-7693-4-git-send-email-tao.ma@oracle.com>
	<20080814200144.GB28875@mail.oracle.com>
	<48A52CDE.4020706@oracle.com>
Message-ID: <20080814234722.GF17664@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Aug 15, 2008 at 03:14:38PM +0800, Tao Ma wrote:
> Joel Becker wrote:
> > On Thu, Aug 07, 2008 at 06:31:26AM +0800, Tao Ma wrote:
> >> The old ocfs2_do_extend_allocation is restrictly to be used in file
> >> extension. Now a new function named ocfs2_do_cluster_allocation will
> >> handle the issue of generic extend allocation and it is created in
> >> suballoc.c.
> > 
> > <snip> 
> > 
> >> +int ocfs2_add_clusters_in_btree(struct ocfs2_super *osb,
> >> +				struct inode *inode,
> >> +				u32 *logical_offset,
> >> +				u32 clusters_to_add,
> >> +				int mark_unwritten,
> >> +				struct buffer_head *root_bh,
> >> +				struct ocfs2_extent_list *root_el,
> >> +				handle_t *handle,
> >> +				struct ocfs2_alloc_context *data_ac,
> >> +				struct ocfs2_alloc_context *meta_ac,
> >> +				enum ocfs2_alloc_restarted *reason_ret,
> >> +				enum ocfs2_extent_tree_type type)
> > 
> > 	It seems to me that if you have root_bh and type, you can create
> > an ocfs2_extent_tree and calculate root_el from that.  So you don't need
> > root_el in this function's arguments, and callers don't need to know how
> > to compute it.
> No we can't. For a ocfs2_xattr_value_root. It can be stored in any place 
> of a buffer_head, so we have to give it to this function.

	But don't you later turn a private pointer into that thing?

Joel

-- 

"I have never let my schooling interfere with my education."
        - Mark Twain

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
