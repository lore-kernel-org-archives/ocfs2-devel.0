From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue, 13 Jun 2006 16:56:25 -0700
Subject: [Ocfs2-devel] ext2 attributes for OCFS2
In-Reply-To: <20060612214116.GA13582@MAIL.13thfloor.at>
References: <20060610123253.GA23924@MAIL.13thfloor.at>
	<20060611174510.GW3082@ca-server1.us.oracle.com>
	<20060612214116.GA13582@MAIL.13thfloor.at>
Message-ID: <20060613235625.GD3082@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jun 12, 2006 at 11:41:17PM +0200, Herbert Poetzl wrote:
> okay, so it looks like the ocfs2 folks are open to such
> an extention which for me means that a mainline patch 
> makes sense ...
Yes - thanks for following up on this :)


> the good news here is that some of the attributes (like
> the immutable or append) work out of the box once they
> are there (i.e. present in the generic inode flags)
Yeah, it should mostly work just fine, but I'm betting there are some paths
which will need a manual re-check as things may have changed out from under
the VFS while we weren't holding a cluster lock. It should be easy enough to
check things like the immutable flag in those places though.


> okay, I moved those parts out of the ocfs2_ioctl
> to match the general structure and enhance the
> readabilitly - I hope I got the locks right this
> time, please double check ...
The locking looks good, thanks. The ioctl.[ch] parts of the patch looks
pretty good now btw.


> okay, I added this and hopefully it will work as
> expected, it didn't get exercised on my (up to now) 
> single node test setup :)
Cool. As much testing as you can do is good :) At any rate, we'll certainly
be testing things out over here once the patch is good for inclusion.

There is a small problem with the lvb stuff which I'll outline below.

 
> I decided to make this patch a little more agressive
> than the last one, using a reserved field of the
> on disk structure to store the new attributes, which
> actually has two advantages IMHO:
> 
>  - the mapping between ext2/3 and ocfs2 isn't required
>    anymore, as we an store the ext attrs without fear
>    of collisions with existing ocfs2 flags
> 
>  - the mixing and separation of ocfs2 flags and ext
>    flags can be avoided completely, probably enhancing
>    readability while simplifying code
I agree that using a new field seems nicer. Can we compress things though
and just use a u16? I don't mind the translation that we were doing before,
so you can go ahead and pack the actual bit values for OCFS2's purposes.

Also I would prefer if you could split the i_reserved0 __le32 into a pair of
__le16 values:

-/*10*/ __le32 i_reserved0;
+/*10*/ __le16 i_attr_flags;
+       __le16 i_reserved0;

Actually, looking at the values, it seems that OCFS2_DIRSYNC_FL is the only
one that won't fit within 16 bits, so you could just give that one some new
value and we'll only have to translate on one flag :)


> here is the new patch, this time inline for easier review and comments ...
Great, thanks - more comments inline.


> @@ -1368,6 +1372,16 @@ static void ocfs2_refresh_inode_from_lvb
>  		inode->i_blocks =
>  			ocfs2_align_bytes_to_sectors(i_size_read(inode));
>  
> +	switch (version) {
> +	case 3:
> +		oi->ip_iflags = be32_to_cpu(lvb->lvb_iflags);
> +		printk("lvb refresh for %p flags %x\n", inode, oi->ip_iflags);
> +		break;
> +	default:
> +		oi->ip_iflags = 0;
> +		printk("lvb refresh for %p flags = 0\n", inode);
> +	}
You won't ever hit the 'default' case because ocfs2_meta_lvb_is_trustable()
will always return false. Which is what we probably want in this case
because if you're going to allow nodes which don't understand the attributes
to be in the cluster we don't want to trust their lvbs (and instead read
from disk) as they won't have put anything useful in the flags lvb field.

>  	inode->i_uid     = be32_to_cpu(lvb->lvb_iuid);
>  	inode->i_gid     = be32_to_cpu(lvb->lvb_igid);
>  	inode->i_mode    = be16_to_cpu(lvb->lvb_imode);
Hmm, you also left out the corresponding code in __ocfs2_stuff_meta_lvb()

I'll attach a quick, untested patch against dlmglue.[ch] which you can
hopefully use.


> diff -NurpP --minimal linux-2.6.16.20/fs/ocfs2/inode.h linux-2.6.16.20-ocfs2-0.01/fs/ocfs2/inode.h
> --- linux-2.6.16.20/fs/ocfs2/inode.h	2006-04-09 13:49:54 +0200
> +++ linux-2.6.16.20-ocfs2-0.01/fs/ocfs2/inode.h	2006-06-12 21:08:39 +0200
> @@ -56,6 +56,7 @@ struct ocfs2_inode_info
>  	struct ocfs2_journal_handle	*ip_handle;
>  
>  	u32				ip_flags; /* see below */
> +	u32				ip_iflags; /* inode attributes */
Minor nit, but would you mind changing the name to something like
ip_attr_flags? I know - I'm the one who brought up that not-so-good-name in
the first place :) Maybe we can just start saying attr_flags instead of
iflags elsewhere too? I apologize for the poor 1st pass at naming this thing
:)


> -/*70*/	__le64 i_reserved1[9];
> +/*70*/	__le32 i_iflags;		/* inode attr flags */
> +	__le32 i_reserved1;
> +	__le64 i_reserved2[8];
I guess just see my comment above on where to locate this.


So IMHO, and you can probably tell this by the lack of patch comments that
things are coming along pretty well. Thanks again for doing all this :)
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com
