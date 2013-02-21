From: Jan Kara <jack@suse.cz>
Date: Thu, 21 Feb 2013 16:25:20 +0100
Subject: [Ocfs2-devel] [RFC PATCH 0/3] copy-on-write extents mapping
In-Reply-To: <51244A15.2060508@oracle.com>
References: <51244A15.2060508@oracle.com>
Message-ID: <20130221152520.GA17067@quack.suse.cz>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger@dilger.ca>, Dave Chinner <david@fromorbit.com>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@fusionio.com>, Christoph Hellwig <hch@infradead.org>, ocfs2-devel@oss.oracle.com

  Hello,

On Wed 20-02-13 11:59:17, Jeff Liu wrote:
> We have the user requests to show the real disk usage for OCFS2/Btrfs
> with reflinked/cloned files.  AFAICS, integrate the existing fiemap
> interface to du(1) is fine to solve this issue because OCFS2 can return
> an extent in FIEMAP_EXTENT_SHARED state which is used to indicate the
> extent is reflinked, and Btrfs can be improved in the similar approach in
> the future.
> 
> Now another issue is regarding the performance when call fiemap ioctl(2)
> against a large file (like virtual disk images).  Assuming we created a
> 20Gb reflinked file, the first 19Gb has been written(COWed), and the left
> 1Gb is still in shared status, the user space has to call fiemap for
> multiple times to fetch the ending shared extents, that is not good if
> the target disk have many reflinked files in such situations.
  Can you gather some performance numbers please - i.e. how long does it take
to map such file without FIEMAP_FLAG_COW and how long with it? I'm not
completely convinced it will make such a huge difference in practice (given
du(1) isn't very performance critical application).

> I'd like to introduce a new flag FIEMAP_FLAG_COW to the fiemap interface,
> if this flag is set, the kernel space will only return the mapped extents
> in shared state, as a result, we can reduce the overheads for calling
> fiemap again an again.
  I'm a bit uneasy about this 'filtering' function of flags. But I guess
there aren't that many extent types so that flags couldn't accomodate that.
So if you show something like this is necessary to make du(1) application
practical, then I guess I can bear it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
