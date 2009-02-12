From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 12 Feb 2009 11:02:53 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: set xh_free_start when xattr
	header in inode/block
In-Reply-To: <20090211185007.GJ9512@mail.oracle.com>
References: <499238F3.9010208@oracle.com>
	<1234319891-7020-1-git-send-email-tiger.yang@oracle.com>
	<20090211185007.GJ9512@mail.oracle.com>
Message-ID: <4993915D.8050807@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, Joel,

Thanks for quick review.  I have thought of that and have already made a 
patch for it. But as we didn't officially release tools which support 
EAs(include mkfs) even in git tree, do we really need this patch?

thanks
tiger

Joel Becker wrote:
> On Wed, Feb 11, 2009 at 10:38:11AM +0800, Tiger Yang wrote:
>> This patch update fields about xh_free_start and
>> xh_name_value_len when xattr header in inode/block.
>> Those fields only be used for bucket before.
>> With xh_free_start, we are free to calculate minimum
>> offset of xattr name/value.
> 
> 	The math of the patch is fine, but it doesn't take into account
> filesystems in the wild.  xattrs were released with .28, which means
> there are filesystems in the wild that have xh_free_start==0.  This
> patch removes the old math that calculated offsets without
> xh_free_start.  We probably should checking for xh_free_start==0 and
> recalculating it.
> 	The places in this patch and the next patch where you pad the
> space with 4 bytes shouldn't use 'sizeof(__u32)'.  Create a #define
> (something like OCFS2_XATTR_HEADER_GAP == 4).
> 
> Joel


-------------- next part --------------
A non-text attachment was scrubbed...
Name: xattr.patch
Type: text/x-patch
Size: 2006 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20090212/d84e2fac/attachment.bin 
