From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed, 14 Jun 2006 11:54:31 -0700
Subject: [Ocfs2-devel] ext2 attributes for OCFS2
In-Reply-To: <20060614104400.GA19984@MAIL.13thfloor.at>
References: <20060610123253.GA23924@MAIL.13thfloor.at>
	<20060611174510.GW3082@ca-server1.us.oracle.com>
	<20060612214116.GA13582@MAIL.13thfloor.at>
	<20060613235625.GD3082@ca-server1.us.oracle.com>
	<20060614104400.GA19984@MAIL.13thfloor.at>
Message-ID: <20060614185431.GE3082@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jun 14, 2006 at 12:44:00PM +0200, Herbert Poetzl wrote:
> > Yeah, it should mostly work just fine, but I'm betting there are some
> > paths which will need a manual re-check as things may have changed out
> > from under the VFS while we weren't holding a cluster lock. It should
> > be easy enough to check things like the immutable flag in those places
> > though.
> 
> might be, I already wondered why things like
> mark_inode_dirty() do not work with ocfs2,
> IMHO the vfs/ocfs2 synchronization is broken
> (to some degree) but maybe that is intentional
Yeah, it's difficult to get the VFS to "cluster lock" without affecting the
runtime of other file systems, so we have to work within that constraint :/


> > I agree that using a new field seems nicer. 
> 
> > Can we compress things though and just use a u16?
> 
> sure we can, but I think we should either use
> the flags _as is_ and do not map/change anything
> or compress them into the existing i_flags, 
> avoiding the new on disk field completely
No, I'd rather not use the existing i_flags, though I never really explained
why. 

Basically that field (i_flags) should be saved for bits "internal" to the
file system things that the user can't directly change or see. That's why I
thought using a new field was such a good idea. Now, the size of the field
is something I'd like to minimize - there's no sense using a full 32 bits
for something that will only ever use nine of them.

Please keep in mind that this has implications for things other than just
the disk inode structure. LVB space is _far_ more limited for example - only
64 bytes. Using 16 bits there instead of the full 32 will definitely show up
as we're adding features which require more fields there.

Now, you correctly point out that using anything less than a u32 will
require some level of mapping to ext2, which can be ugly. And I agree that
it's ugly, but it's less important than the other two issues thus far
outlined. Luckily, the ext2 mapping part just has to happen in ioctl.c, so
at least we're not polluting the rest of the code with it :)


> I'd prefer to use the flag by flag mapping instead
> of some magic shift/mask which doesn't actually 
> gain that much
That's perfectly fine with me. I agree that we might as well mangle them as
cleanly as possible :)


> > You won't ever hit the 'default' case because
> > ocfs2_meta_lvb_is_trustable() will always return false. Which is what
> > we probably want in this case because if you're going to allow nodes
> > which don't understand the attributes to be in the cluster we don't
> > want to trust their lvbs (and instead read from disk) as they won't
> > have put anything useful in the flags lvb field.
> 
> ah, okay, good to know, so we simply reduce that to
> oi->ip_iflags = be32_to_cpu(lvb->lvb_iflags), yes?
Right.


> > Hmm, you also left out the corresponding code in __ocfs2_stuff_meta_lvb()
> 
> hmm, I did? .. checking ... hmm, what about this part?
Oops, sorry - for some reason I didn't see that on my last reading!


> well, I actually used ip_iattr in the second patch
> I did, but this actually makes things even more
> confusing, as for example the functions would then
> look like this:
> 
> +void ocfs2_set_inode_flags(struct inode *inode)
> +{
> +	unsigned int flags = OCFS2_I(inode)->ip_iattr;
> +
> +	inode->i_flags &= ...
> 
> and this:
> 
> +int ocfs2_get_iattr(struct inode *inode, unsigned *flags)
> +int ocfs2_set_iattr(struct inode *inode, unsigned flags, unsigned mask)
How about ocfs2_get_attr_flags(...) and ocfs2_set_attr_flags(...)? Anyway,
this isn't a big deal or anything :)


> > So IMHO, and you can probably tell this by the lack of patch comments
> > that things are coming along pretty well. Thanks again for doing all
> > this :)
> 
> you're welcome! and tx for the quick feedback!
No problem :)


> PS: did I miss the quickly attached patch? :)
Eh, did I forget that too? Heh, well I'll attach this time around so you get
an idea of what I was talking about, but you pretty much got it, save for
field sizes, and adding to a debug function.

Thanks,
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh at oracle.com

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index d57860d..774a7a7 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1330,6 +1330,7 @@ static void __ocfs2_stuff_meta_lvb(struc
 		cpu_to_be64(ocfs2_pack_timespec(&inode->i_ctime));
 	lvb->lvb_imtime_packed =
 		cpu_to_be64(ocfs2_pack_timespec(&inode->i_mtime));
+	lvb->lvb_iattr_flags = cpu_to_be16(oi->ip_attr_flags);
 
 	mlog_meta_lvb(0, lockres);
 
@@ -1377,6 +1378,7 @@ static void ocfs2_refresh_inode_from_lvb
 			      be64_to_cpu(lvb->lvb_imtime_packed));
 	ocfs2_unpack_timespec(&inode->i_ctime,
 			      be64_to_cpu(lvb->lvb_ictime_packed));
+	oi->ip_attr_flags = be16_to_cpu(lvb->lvb_iattr_flags);
 	spin_unlock(&oi->ip_lock);
 
 	mlog_exit_void();
@@ -2908,8 +2910,9 @@ void ocfs2_dump_meta_lvb_info(u64 level,
 	     be32_to_cpu(lvb->lvb_iuid), be32_to_cpu(lvb->lvb_igid),
 	     be16_to_cpu(lvb->lvb_imode));
 	mlog(level, "nlink %u, atime_packed 0x%llx, ctime_packed 0x%llx, "
-	     "mtime_packed 0x%llx\n", be16_to_cpu(lvb->lvb_inlink),
+	     "mtime_packed 0x%llx, attr 0x%x\n", be16_to_cpu(lvb->lvb_inlink),
 	     (long long)be64_to_cpu(lvb->lvb_iatime_packed),
 	     (long long)be64_to_cpu(lvb->lvb_ictime_packed),
-	     (long long)be64_to_cpu(lvb->lvb_imtime_packed));
+	     (long long)be64_to_cpu(lvb->lvb_imtime_packed),
+	     be16_to_cpu(lvb->lvb_iattr_flags));
 }
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index 8f2d1db..cfb06cb 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -27,7 +27,7 @@
 #ifndef DLMGLUE_H
 #define DLMGLUE_H
 
-#define OCFS2_LVB_VERSION 2
+#define OCFS2_LVB_VERSION 3
 
 struct ocfs2_meta_lvb {
 	__be32       lvb_version;
@@ -40,7 +40,9 @@ struct ocfs2_meta_lvb {
 	__be64       lvb_isize;
 	__be16       lvb_imode;
 	__be16       lvb_inlink;
-	__be32       lvb_reserved[3];
+	__be16       lvb_iattr_flags;
+	__be16       lvb_reserved0;
+	__be32       lvb_reserved1[2];
 };
 
 /* ocfs2_meta_lock_full() and ocfs2_data_lock_full() 'arg_flags' flags */
