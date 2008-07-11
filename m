From: tristan <tristan.ye@oracle.com>
Date: Fri, 11 Jul 2008 10:21:48 +0800
Subject: [Ocfs2-devel] [PATCH 08/15] ocfs2: Add extended
	attribute	support v2
In-Reply-To: <20080710231119.GB32459@wotan.suse.de>
References: <48648B3E.6050808@oracle.com>
	<1214551656-22529-1-git-send-email-tiger.yang@oracle.com>
	<1214551656-22529-2-git-send-email-tiger.yang@oracle.com>
	<20080710231119.GB32459@wotan.suse.de>
Message-ID: <1215742908.7387.6.camel@tristan-laptop.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 2008-07-10 at 16:11 -0700, Mark Fasheh wrote:
> On Fri, Jun 27, 2008 at 03:27:35PM +0800, Tiger Yang wrote:
> > +static int ocfs2_xattr_has_space_inline(struct ocfs2_inode_info *oi,
> > +					struct ocfs2_dinode *di,
> > +					int xattrsize)
> > +{
> > +	int free;
> > +
> > +	if (xattrsize < OCFS2_MIN_XATTR_INLINE_SIZE)
> > +		return 0;
> > +
> > +	if (oi->ip_dyn_features & OCFS2_INLINE_DATA_FL) {
> > +		struct ocfs2_inline_data *idata = &di->id2.i_data;
> > +		free = le16_to_cpu(idata->id_count) - le64_to_cpu(di->i_size);
> > +	} else {
> > +		struct ocfs2_extent_list *el = &di->id2.i_list;
> > +		free = (le16_to_cpu(el->l_count) -
> > +			le16_to_cpu(el->l_next_free_rec)) *
> > +			sizeof(struct ocfs2_extent_rec);
> > +	}
> > +	if (free >= xattrsize)
> > +		return 1;
> > +
> > +	return 0;
> > +}
> 
> Btw, neither this, nor any of the other code seems to take symlinks into
> account. As far as I can tell, it's valid to set xattrs on a symlink. Is
> this correct? If so, we need to handle fast symlinks and also symlinks with
> extents. Though I suppose symlinks using extents probably don't need any
> extra work since they otherwise look like regular files.

I agree,current VFS has exported an API lsetxattr which expects to set
xattr on symlink directly without following it,unfortunately i did not
see it was supported actually by ext3,and the same situation with our
ocfs2.


> 
> 
> 
> 
> --
> Mark Fasheh
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
