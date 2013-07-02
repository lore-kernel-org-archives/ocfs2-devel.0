From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 1 Jul 2013 18:50:40 -0700
Subject: [Ocfs2-devel] [PATCH V3] ocfs2: xattr: fix inlined xattr reflink
In-Reply-To: <51D22814.7050500@oracle.com>
References: <1372388183-6378-1-git-send-email-junxiao.bi@oracle.com>
	<20130701225746.GC965@localhost> <51D22814.7050500@oracle.com>
Message-ID: <20130702015040.GJ965@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jul 02, 2013 at 09:08:36AM +0800, Junxiao Bi wrote:
> Hi Joel,
> 
> On 07/02/2013 06:57 AM, Joel Becker wrote:
> > On Fri, Jun 28, 2013 at 10:56:23AM +0800, Junxiao Bi wrote:
> >> Inlined xattr shared free space of inode block with inlined data
> >> or data extent record, so the size of the later two should be
> >> adjusted when inlined xattr is enabled. See ocfs2_xattr_ibody_init().
> >> But this isn't done well when reflink. For inode with inlined data,
> >> its max inlined data size is adjusted in ocfs2_duplicate_inline_data(),
> >> no problem. But for inode with data extent record, its record count isn't
> >> adjusted. Fix it, or data extent record and inlined xattr may overwrite
> >> each other, then cause data corruption or xattr failure.
<snip>
> >>  	new_oi = OCFS2_I(args->new_inode);
> >> +	/*
> >> +	 * Adjust extent record count to reserve space for extended attribute.
> >> +	 * Inline data count had been adjusted in ocfs2_duplicate_inline_data().
> >> +	 */
> >> +	if (!(new_oi->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
> >> +	    !(ocfs2_inode_is_fast_symlink(args->new_inode))) {
> >> +		struct ocfs2_extent_list *el = &new_di->id2.i_list;
> >> +		le16_add_cpu(&el->l_count, -(inline_size /
> >> +					sizeof(struct ocfs2_extent_rec)));
> >> +	}
> > Why are you referencing the inode before taking the lock?
> I think we didn't need take the lock here because this is in reflink,
> it's a new inode. It can not be access from other process or node at
> that time.

	You're sure about that?  The orphan_dir scan cannot find it?  If
you are correct, why are we looking it just another line below?
Shouldn't you remove those locks?  The inconsistency is glaring.

Joel


-- 

 One look at the From:
 understanding has blossomed
 .procmailrc grows
        - Alexander Viro

			http://www.jlbec.org/
			jlbec at evilplan.org
