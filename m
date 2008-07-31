From: Tiger Yang <tiger.yang@oracle.com>
Date: Thu, 31 Jul 2008 17:37:12 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Add extended attribute support
	v3
In-Reply-To: <20080725215755.GH28014@wotan.suse.de>
References: <20080725215755.GH28014@wotan.suse.de>
Message-ID: <489187C8.7030708@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> The thing is, the locking as you have it here isn't protecting against
> racing a data write, which is reading l_count on the extent list (or id_count on
> inline data) and an xattr write which might want to shrink those. You'll
> need at least ip_alloc_sem around those, since ocfs2_page_mkwrite() doesn't
> take i_mutex because it doesn't want to deadlock against the mmap
> semaphore.
Thanks, You point out a potential bug in my patch. I didn't protect
reading/writing xattr against file data.

My patch check l_count/id_count in ocfs2_xattr_has_space_inline() and
may change it in ocfs2_xattr_ibody_set().
is patch attached fix this problem?


> Or are you trying to protect xattr against itself? If that's the case, you
> could push this lock up to the top and take it around entire operations.
Actually I am trying to protect xattr read/write by this semaphore,
since we found a bug about it.
http://oss.oracle.com/bugzilla/show_bug.cgi?id=990

So I need change comment about xattr semaphore.
/* protects extended attribute change on this inode */

Best regards,
tiger

-------------- next part --------------
A non-text attachment was scrubbed...
Name: 0009-2.patch
Type: text/x-patch
Size: 1253 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080731/7cf7eb39/attachment.bin 
