From: Andreas Dilger <adilger@dilger.ca>
Date: Thu, 12 Dec 2013 15:22:20 -0700
Subject: [Ocfs2-devel] [PATCH 0/4 v3] fiemap: introduce
	EXTENT_DATA_COMPRESSED flag
In-Reply-To: <cover.1386778302.git.dsterba@suse.cz>
References: <cover.1386778302.git.dsterba@suse.cz>
Message-ID: <6CAFB777-F514-4DD9-BD8B-95E7525FD534@dilger.ca>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Sterba <dsterba@suse.cz>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Mark Fasheh <mfasheh@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com, linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, Ext4 Developers List <linux-ext4@vger.kernel.org>, "linux-btrfs@vger.kernel.org Btrfs" <linux-btrfs@vger.kernel.org>

On Dec 12, 2013, at 8:25 AM, David Sterba <dsterba@suse.cz> wrote:
> The original FIEMAP patch did not define this bit, btrfs will make use of
> it.  The defined constant maintains the same value as originally proposed.
> 
> Currently, the 'filefrag' utility has no way to recognize and denote a
> compressed extent. As implemented in btrfs right now, the compression step
> splits a big extent into smaller chunks and this is reported as a heavily
> fragmented file. Adding the flag to filefrag will at least give some
> explanation why, this has been confusing users for some time already.

The whole series looks good to me (one minor nit if it needs to be resubmitted
for some reason).  You can add my:

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> V3:
> Based on feedback from Andreas, implement #1 from V2, current users of
> fiemap_fill_next_extent (fs/, ext4, gfs2, ocfs2, nilfs2, xfs) updated
> accordingly, no functional change.
> 
> V2:
> Based on feedback from Andreas, the fiemap_extent is now able to hold the
> physical extent length, to be filled by the filesystem callback.
> 
> The filesystems do not have access to the structure that is passed back to
> userspace and are supposed to call fiemap_fill_next_extent, there's no direct
> way to fill fe_phys_length. There are two ways to pass it:
> 
> 1) extend fiemap_fill_next_extent to take phys_length and update all
>   users (ext4, gfs2, ocfs2, nilfs2, xfs)
> 
> 2) add new function that takes arguments for all the fiemap_extent items,
>   newly added phys_length compared to fiemap_fill_next_extent
> 
> David Sterba (4):
>  fiemap: fix comment at EXTENT_DATA_ENCRYPTED
>  fiemap: add EXTENT_DATA_COMPRESSED flag
>  btrfs: set FIEMAP_EXTENT_DATA_COMPRESSED for compressed extents
>  Documentation/fiemap: Document the DATA_COMPRESSED flag
> 
> Documentation/filesystems/fiemap.txt |   17 +++++++++++++----
> fs/btrfs/extent_io.c                 |    9 +++++++--
> fs/ext4/extents.c                    |    3 ++-
> fs/ext4/inline.c                     |    2 +-
> fs/gfs2/inode.c                      |    2 +-
> fs/ioctl.c                           |   18 ++++++++++++------
> fs/nilfs2/inode.c                    |    8 +++++---
> fs/ocfs2/extent_map.c                |    4 ++--
> fs/xfs/xfs_iops.c                    |    2 +-
> include/linux/fs.h                   |    2 +-
> include/uapi/linux/fiemap.h          |    8 ++++++--
> 11 files changed, 51 insertions(+), 24 deletions(-)
> 
> -- 
> 1.7.9
> 


Cheers, Andreas





-------------- next part --------------
A non-text attachment was scrubbed...
Name: signature.asc
Type: application/pgp-signature
Size: 833 bytes
Desc: Message signed with OpenPGP using GPGMail
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20131212/6348d653/attachment.bin 
