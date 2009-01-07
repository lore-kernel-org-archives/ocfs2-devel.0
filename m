From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 6 Jan 2009 17:03:05 -0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2: Optimize inode group
	allocation by recording last used group.
In-Reply-To: <4963FC14.5080506@oracle.com>
References: <492F946F.1060409@oracle.com>
	<1227826725-13107-3-git-send-email-tao.ma@oracle.com>
	<20090106212332.GS17410@wotan.suse.de>
	<4963FC14.5080506@oracle.com>
Message-ID: <20090107010305.GU17410@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jan 07, 2009 at 08:49:24AM +0800, Tao Ma wrote:
> >> 	struct ocfs2_node_map		osb_recovering_orphan_dirs;
> >> 	unsigned int			*osb_orphan_wipes;
> >> 	wait_queue_head_t		osb_wipe_event;
> >>+
> >>+	/* the group we used to allocate inodes. */
> >>+	u64				osb_last_alloc_group;
> >
> >Can you give this a name which is more specific to the inode allocators?
> >That way we can just add another u64 later for the metadata allocators,
> >should we decide to do the same for them.
> How about osb_inode_alloc_group?

That works for me.
	--Mark

--
Mark Fasheh
