From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri Aug  6 18:58:32 2004
Subject: [Ocfs2-devel] why skip zero is removed?
In-Reply-To: <3ACA40606221794F80A5670F0AF15F8405167BDB@pdsmsx403>
References: <3ACA40606221794F80A5670F0AF15F8405167BDB@pdsmsx403>
Message-ID: <20040806235556.GG2595@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Aug 07, 2004 at 06:53:21AM +0800, Ling, Xiaofeng wrote:
> I found in r1323, the skip zero is removed from ocfs_extend_file.
> So what's the reason? The log say "skip_zeros is pointless with the new
> zeroing scheme."
> What's the new zeroing scheme?  Now the performance for directory droped
> again to 200/s in svn1331.

	The zeroing for files is handled by the pagecache now.  This is
the proper method for filesystems that do not support holes (see fat,
hpfs, adfs, affs, etc).  The code uses cont_prepare_write() out of our
prepare_write() function (for 2.6 it uses cont_prepare_write() directly,
for 2.4 it uses ocfs2_cont_prepare_write() -- see inode.c).
cont_prepare_write uses a value on the inode info structure,
OCFS_I(inode)->ip_mmu_private, to keep track of how much of the file has
already been zeroed.  This is always set to i_size on read_inode() and
verifyupdate().  It is zero on a new inode.  cont_prepare_write() uses
ip_mmu_private to compare with the page it is trying to prepare.  It
then calls __block_prepare_write() appropriately.  ocfs_get_block() is
the last actor in this drama.  It knows that when it gets a request for
a block past ip_mmu_private, it is a "new" block to the file (it's a
block past the old i_size), and it sets BH_New, allowing the entire
block to be cleared.
	That's what happens on write().  On a trucate() that extends, we
force this operation by calling prepare_write()/commit_write() on the
last page of the file.  Only file extend via write() and file extend via
truncate() ever get to this code.
	Directories and system files never get to this code, because
they are not in the pagecache.  Directories do not need zeroing, as you
know.  System files get their zeroing in ocfs_extend_file() as they have
always done.  Note that the check in ocfs_extend_file() is now
"if (system_file)".  This check will fail for directories, so there is
no point in adding skip_zeros to skip it.

Joel

-- 

"Lately I've been talking in my sleep.
 Can't imagine what I'd have to say.
 Except my world will be right
 When love comes back my way."

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
