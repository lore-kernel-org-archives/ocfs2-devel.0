From: Herbert Poetzl <herbert@13thfloor.at>
Date: Wed, 14 Jun 2006 12:44:00 +0200
Subject: [Ocfs2-devel] ext2 attributes for OCFS2
In-Reply-To: <20060613235625.GD3082@ca-server1.us.oracle.com>
References: <20060610123253.GA23924@MAIL.13thfloor.at>
	<20060611174510.GW3082@ca-server1.us.oracle.com>
	<20060612214116.GA13582@MAIL.13thfloor.at>
	<20060613235625.GD3082@ca-server1.us.oracle.com>
Message-ID: <20060614104400.GA19984@MAIL.13thfloor.at>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jun 13, 2006 at 04:56:25PM -0700, Mark Fasheh wrote:
> On Mon, Jun 12, 2006 at 11:41:17PM +0200, Herbert Poetzl wrote:
> > okay, so it looks like the ocfs2 folks are open to such
> > an extention which for me means that a mainline patch 
> > makes sense ...
> Yes - thanks for following up on this :)

always good to hear ...

> > the good news here is that some of the attributes (like
> > the immutable or append) work out of the box once they
> > are there (i.e. present in the generic inode flags)
> Yeah, it should mostly work just fine, but I'm betting there are some
> paths which will need a manual re-check as things may have changed out
> from under the VFS while we weren't holding a cluster lock. It should
> be easy enough to check things like the immutable flag in those places
> though.

might be, I already wondered why things like
mark_inode_dirty() do not work with ocfs2,
IMHO the vfs/ocfs2 synchronization is broken
(to some degree) but maybe that is intentional

> > okay, I moved those parts out of the ocfs2_ioctl
> > to match the general structure and enhance the
> > readabilitly - I hope I got the locks right this
> > time, please double check ...
> The locking looks good, thanks. The ioctl.[ch] parts of the patch
> looks pretty good now btw.

okay, good

> > okay, I added this and hopefully it will work as
> > expected, it didn't get exercised on my (up to now) 
> > single node test setup :)
> Cool. As much testing as you can do is good :) At any rate, we'll
> certainly be testing things out over here once the patch is good for
> inclusion.

guess it will get more testing once I set it up
as a cluster system 

> There is a small problem with the lvb stuff which I'll outline below.
>  
> > I decided to make this patch a little more agressive
> > than the last one, using a reserved field of the
> > on disk structure to store the new attributes, which
> > actually has two advantages IMHO:
> > 
> >  - the mapping between ext2/3 and ocfs2 isn't required
> >    anymore, as we an store the ext attrs without fear
> >    of collisions with existing ocfs2 flags
> > 
> >  - the mixing and separation of ocfs2 flags and ext
> >    flags can be avoided completely, probably enhancing
> >    readability while simplifying code

> I agree that using a new field seems nicer. 

> Can we compress things though and just use a u16?

sure we can, but I think we should either use
the flags _as is_ and do not map/change anything
or compress them into the existing i_flags, 
avoiding the new on disk field completely

> I don't mind the translation that we were doing before, so you can go
> ahead and pack the actual bit values for OCFS2's purposes.

> Also I would prefer if you could split the i_reserved0 __le32 into 
> a pair of __le16 values:
> 
> -/*10*/ __le32 i_reserved0;
> +/*10*/ __le16 i_attr_flags;
> +       __le16 i_reserved0;
> 
> Actually, looking at the values, it seems that OCFS2_DIRSYNC_FL is the
> only one that won't fit within 16 bits, so you could just give that
> one some new value and we'll only have to translate on one flag :)

I'd prefer to use the flag by flag mapping instead
of some magic shift/mask which doesn't actually 
gain that much

> > here is the new patch, this time inline for easier review and comments ...
> Great, thanks - more comments inline.
> 
> > @@ -1368,6 +1372,16 @@ static void ocfs2_refresh_inode_from_lvb
> >  		inode->i_blocks =
> >  			ocfs2_align_bytes_to_sectors(i_size_read(inode));
> >  
> > +	switch (version) {
> > +	case 3:
> > +		oi->ip_iflags = be32_to_cpu(lvb->lvb_iflags);
> > +		printk("lvb refresh for %p flags %x\n", inode, oi->ip_iflags);
> > +		break;
> > +	default:
> > +		oi->ip_iflags = 0;
> > +		printk("lvb refresh for %p flags = 0\n", inode);
> > +	}
> You won't ever hit the 'default' case because
> ocfs2_meta_lvb_is_trustable() will always return false. Which is what
> we probably want in this case because if you're going to allow nodes
> which don't understand the attributes to be in the cluster we don't
> want to trust their lvbs (and instead read from disk) as they won't
> have put anything useful in the flags lvb field.

ah, okay, good to know, so we simply reduce that to
oi->ip_iflags = be32_to_cpu(lvb->lvb_iflags), yes?

> >  	inode->i_uid     = be32_to_cpu(lvb->lvb_iuid);
> >  	inode->i_gid     = be32_to_cpu(lvb->lvb_igid);
> >  	inode->i_mode    = be16_to_cpu(lvb->lvb_imode);
> Hmm, you also left out the corresponding code in __ocfs2_stuff_meta_lvb()

hmm, I did? .. checking ... hmm, what about this part?

--- linux-2.6.16.20/fs/ocfs2/dlmglue.c	2006-01-18 06:08:34 +0100
+++ linux-2.6.16.20-ocfs2-0.01/fs/ocfs2/dlmglue.c	2006-06-12 22:32:00 +0200
@@ -1321,6 +1321,7 @@ static void __ocfs2_stuff_meta_lvb(struc
 	lvb->lvb_version   = cpu_to_be32(OCFS2_LVB_VERSION);
 	lvb->lvb_isize	   = cpu_to_be64(i_size_read(inode));
 	lvb->lvb_iclusters = cpu_to_be32(oi->ip_clusters);
+	lvb->lvb_iflags    = cpu_to_be32(oi->ip_iflags);
 	lvb->lvb_iuid      = cpu_to_be32(inode->i_uid);
 	lvb->lvb_igid      = cpu_to_be32(inode->i_gid);
 	lvb->lvb_imode     = cpu_to_be16(inode->i_mode);

do we need more?

> I'll attach a quick, untested patch against dlmglue.[ch] which you can
> hopefully use.

okay, will check ...

> > diff -NurpP --minimal linux-2.6.16.20/fs/ocfs2/inode.h linux-2.6.16.20-ocfs2-0.01/fs/ocfs2/inode.h
> > --- linux-2.6.16.20/fs/ocfs2/inode.h	2006-04-09 13:49:54 +0200
> > +++ linux-2.6.16.20-ocfs2-0.01/fs/ocfs2/inode.h	2006-06-12 21:08:39 +0200
> > @@ -56,6 +56,7 @@ struct ocfs2_inode_info
> >  	struct ocfs2_journal_handle	*ip_handle;
> >  
> >  	u32				ip_flags; /* see below */
> > +	u32				ip_iflags; /* inode attributes */
> Minor nit, but would you mind changing the name to something
> like ip_attr_flags? I know - I'm the one who brought up that
> not-so-good-name in the first place :) Maybe we can just start saying
> attr_flags instead of iflags elsewhere too? I apologize for the poor
> 1st pass at naming this thing :)

well, I actually used ip_iattr in the second patch
I did, but this actually makes things even more
confusing, as for example the functions would then
look like this:

+void ocfs2_set_inode_flags(struct inode *inode)
+{
+	unsigned int flags = OCFS2_I(inode)->ip_iattr;
+
+	inode->i_flags &= ...

and this:

+int ocfs2_get_iattr(struct inode *inode, unsigned *flags)
+int ocfs2_set_iattr(struct inode *inode, unsigned flags, unsigned mask)

which IMHO is even more confusing, but, I think we
won't have this name clash if we stick to mangling
the existing ip_flags with the new ones ...

> > -/*70*/	__le64 i_reserved1[9];
> > +/*70*/	__le32 i_iflags;		/* inode attr flags */
> > +	__le32 i_reserved1;
> > +	__le64 i_reserved2[8];
> I guess just see my comment above on where to locate this.
> 
> 
> So IMHO, and you can probably tell this by the lack of patch comments
> that things are coming along pretty well. Thanks again for doing all
> this :)

you're welcome! and tx for the quick feedback!

will prepare a patch with the complete mangling
added back (in a slightly more readable way)

best,
Herbert

PS: did I miss the quickly attached patch? :)

> 	--Mark
> 
> --
> Mark Fasheh
> Senior Software Developer, Oracle
> mark.fasheh at oracle.com
