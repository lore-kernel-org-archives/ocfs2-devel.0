From: Andreas Dilger <adilger@dilger.ca>
Date: Tue, 25 Jun 2019 14:37:37 -0600
Subject: [Ocfs2-devel] [PATCH v4 0/7] vfs: make immutable files actually
	immutable
In-Reply-To: <20190625180326.GC2230847@magnolia>
References: <156116141046.1664939.11424021489724835645.stgit@magnolia>
	<20190625103631.GB30156@infradead.org>
	<20190625180326.GC2230847@magnolia>
Message-ID: <E84C8EBC-8341-49E5-8EED-0980D158CD50@dilger.ca>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, matthew.garrett@nebula.com, yuchao0@huawei.com, Theodore Ts'o <tytso@mit.edu>, ard.biesheuvel@linaro.org, Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, dsterba@suse.com, Jaegeuk Kim <jaegeuk@kernel.org>, jk@ozlabs.org, reiserfs-devel@vger.kernel.org, linux-efi@vger.kernel.org, devel@lists.orangefs.org, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, linux-xfs <linux-xfs@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On Jun 25, 2019, at 12:03 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> On Tue, Jun 25, 2019 at 03:36:31AM -0700, Christoph Hellwig wrote:
>> On Fri, Jun 21, 2019 at 04:56:50PM -0700, Darrick J. Wong wrote:
>>> Hi all,
>>> 
>>> The chattr(1) manpage has this to say about the immutable bit that
>>> system administrators can set on files:
>>> 
>>> "A file with the 'i' attribute cannot be modified: it cannot be deleted
>>> or renamed, no link can be created to this file, most of the file's
>>> metadata can not be modified, and the file can not be opened in write
>>> mode."
>>> 
>>> Given the clause about how the file 'cannot be modified', it is
>>> surprising that programs holding writable file descriptors can continue
>>> to write to and truncate files after the immutable flag has been set,
>>> but they cannot call other things such as utimes, fallocate, unlink,
>>> link, setxattr, or reflink.
>> 
>> I still think living code beats documentation.  And as far as I can
>> tell the immutable bit never behaved as documented or implemented
>> in this series on Linux, and it originated on Linux.
> 
> The behavior has never been consistent -- since the beginning you can
> keep write()ing to a fd after the file becomes immutable, but you can't
> ftruncate() it.  I would really like to make the behavior consistent.
> Since the authors of nearly every new system call and ioctl since the
> late 1990s have interpreted S_IMMUTABLE to mean "immutable takes effect
> everywhere immediately" I resolved the inconsistency in favor of that
> interpretation.
> 
> I asked Ted what he thought that that userspace having the ability to
> continue writing to an immutable file, and he thought it was an
> implementation bug that had been there for 25 years.  Even he thought
> that immutable should take effect immediately everywhere.
> 
>> If you want  hard cut off style immutable flag it should really be a
>> new API, but I don't really see the point.  It isn't like the usual
>> workload is to set the flag on a file actively in use.
> 
> FWIW Ted also thought that since it's rare for admins to set +i on a
> file actively in use we could just change it without forcing everyone
> onto a new api.

On the flip side, it is possible to continue to write to an open fd
after removing the write permission, and this is a problem we've hit
in the real world with NFS export, so real applications do this.

It may be the same case with immutable files, where an application sets
the immutable flag immediately after creation, but continues to write
until it closes the file, so that the file can't be modified by other
processes, and there isn't a risk that the file is missing the immutable
flag if the writing process dies before setting it at the end.

Cheers, Andreas





-------------- next part --------------
A non-text attachment was scrubbed...
Name: signature.asc
Type: application/pgp-signature
Size: 873 bytes
Desc: Message signed with OpenPGP
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20190625/bbdf3c99/attachment.bin 
