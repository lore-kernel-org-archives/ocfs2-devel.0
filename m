From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 8 Apr 2010 16:10:22 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: alloc orphaned inode in
	ocfs2_symlink
In-Reply-To: <201004080913.08494.lidongyang@novell.com>
References: <201004080913.08494.lidongyang@novell.com>
Message-ID: <20100408231022.GS11402@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Li,

On Thu, Apr 08, 2010 at 09:13:08AM +0800, Li Dongyang wrote:
> alloc the inode orphaned in ocfs2_symlink so we can delete the inode
> in the iput if we meet errors with the inode, e.g. ocfs2_add_inode_data.
> or ocfs2_query_inode_wipe will complain the inode is not orphaned on disk.

Thanks for the patch. Your solution is too heavy for such a special case -
we can't lock the orphan dir and orphan / de-orphan an inode every time a
symlink is made.

The good news is that I believe there's an easier way to handle this. You
can add a flag to ocfs2_inode_info->ip_flags (see fs/ocfs2/inode.h). I would
call this flag something like OCFS2_INODE_SKIP_ORPHAN_DIR. If the allocation
fails, we could mark the inode with that flag. From a quick look at the
code, the only places that need additional checking for the flag would be:
ocfs2_query_inode_wipe() and ocfs2_wipe_inode().


Ultimately, I think the best solution is for us to delete the inode
"in-place". We actually already have all the locks and journal credits we
need at that point. It's a bit tricky though because we have to be careful
what state the inode gets set in, which is why for a short-term fix, the
above solution is ok.
	--Mark

--
Mark Fasheh
