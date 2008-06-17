From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 17 Jun 2008 10:59:03 -0700
Subject: [Ocfs2-devel] [PATCH 7/8] ocfs2: Add extended attributes
	support. v1
In-Reply-To: <48563EF6.2090203@oracle.com>
References: <484792D1.3080802@oracle.com>
	<1212650694-9603-1-git-send-email-tiger.yang@oracle.com>
	<20080613032230.GW28100@wotan.suse.de>
	<48563EF6.2090203@oracle.com>
Message-ID: <20080617175903.GC28100@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jun 16, 2008 at 06:22:46PM +0800, Tiger Yang wrote:
> Mark Fasheh wrote:
> >You'll have to go through the code and determine where we need to use the
> >new functions. Please do this as a seperate patch by the way - it's a 
> >tricky
> >enough operation that I will refuse to read the change if it's intermingled
> >with other stuff.
> >  
> This is a serious problem. The patch attached fix this problem.

Great! I have one more comment regarding all this, below.


> My patch could handle EAs in inode block or in external block at the 
> same times. That is little different between design doc.
> If we find free space inline, we will set EAs in it firstly, otherwise 
> we will set EAs in external block. This resolution just like ext3 does.
> So i_xattr_loc could only be used for contain the number of external block.

Go ahead and add a field to record inline xattr size on the inode. For now,
if we're going to take some space for inline EA, you will always just set it
to osb->s_min_inline_xattr, which is always OCFS2_MIN_XATTR_INLINE_SIZE.

So, use osb->s_min_inline_xattr to figure out whether there's enough space
in the inode for xattrs and set the initial inode field based on it. But
after that, use i_inline_xattr_size (or whatever you call it) to figure out
offset to start in the inode from the end of block, how many bytes to scan,
etc.

The two reasons I think this is a good idea:

- The inline xattr data size is explicitely stored on disk, as opposed to
  being assumed from a constant stored in memory.

- We don't have to rely on the minimum size to stay the same for all inodes on
  a file system. If we need to tune defaults, this becomes much easier if
  new inodes can just inherit the new value without affecting existing ones.


> >What hash function is this? Where did you get it from? How good is it for
> >  
> >use with EA names? How good is it for other uses? Answers to all those
> >questions belong here in e-mail, as well as a nice big comment at the top 
> >of
> >this function.
> >
> >
> >Also, there's this item in the design doc:
> > * need a random seed in super block which is never printed on console
> >
> >We want to combine the random seed with the hashing process somehow so that
> >the results for a given name are not globally predictable for all Ocfs2 
> >file
> >systems.
> >  
> I got this hash function form  ext3_xattr_hash_entry().  In design doc, 
> "The hash value is calculated using the full (prefix.suffix) name of the 
> xattr to avoid hash collisions when the same suffix is used in multiple 
> attribute namespaces. It it used to identify when a name is not going to 
> match before doing a string comparison to verify that the name is a 
> match.", so I got the hash value form EA's prefix and EA's name. 
> Actually I didn't compare hash value and sort EAs when EAs in inode for 
> in external block, Because only few EAs could be stored in inode or 
> external block. Tao use this hash value for large number EAs in bucket.  
> Next I will use that random seed for hash value.

Ok, thanks for the explanation. We should keep in mind that ext3 can't store
as many xattrs as we can so a bit of investigation into the effectiveness of
this hash function for our use might be a good idea.


> I will correct other problems you commented.

Thanks, Tiger.
	--Mark

--
Mark Fasheh
