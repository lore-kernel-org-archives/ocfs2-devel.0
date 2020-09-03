From: Dave Chinner <david@fromorbit.com>
Date: Fri, 4 Sep 2020 07:13:06 +1000
Subject: [Ocfs2-devel] Broken O_{D,}SYNC behavior with FICLONE*?
In-Reply-To: <20200903035225.GJ6090@magnolia>
References: <20200903035225.GJ6090@magnolia>
Message-ID: <20200903211306.GE12131@dread.disaster.area>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, ocfs2 list <ocfs2-devel@oss.oracle.com>, Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, Theodore Ts'o <tytso@mit.edu>

On Wed, Sep 02, 2020 at 08:52:25PM -0700, Darrick J. Wong wrote:
> Hi,
> 
> I have a question for everyone-- do FICLONE and FICLONERANGE count as a
> "write operation" for the purposes of reasoning about O_SYNC and
> O_DSYNC?

I'd say yes, because we are changing metadata that is used to
directly reference the data in the file. O_DSYNC implies all the
metadata needed to access the data is on stable storage when the
operation returns....

> So, that's inconsistent behavior and I want to know if remap_file_range
> is broken or if we all just don't care about O_SYNC for these fancy
> IO accelerators?

Perhaps we should pay attention to the NFSD implementation of CloneFR -
if the operation is sync then it will run fsync on the destination
and commit_metadata on the source inode. See
nfsd4_clone_file_range().

So, yeah, I think clone operations need to pay attention to
O_DSYNC/O_SYNC/IS_SYNC()....

Cheers,

Dave.
-- 
Dave Chinner
david at fromorbit.com
