From: Dave Chinner <david@fromorbit.com>
Date: Tue, 13 Jul 2010 11:25:06 +1000
Subject: [Ocfs2-devel] [PATCH 2/2] OCFS2: Allow huge (> 16 TiB) volumes
	to mount
In-Reply-To: <AANLkTikAEycm5PKTLPuRFcB0e4qNp5EuQbKUx5aruNrh@mail.gmail.com>
References: <871vbax86w.fsf@patl.com> <87zkxyvtjt.fsf@patl.com>
	<3BB069D5-B193-43A4-B678-B3CEA4873B58@dilger.ca>
	<AANLkTikAEycm5PKTLPuRFcB0e4qNp5EuQbKUx5aruNrh@mail.gmail.com>
Message-ID: <20100713012506.GA30737@dastard>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: Andreas Dilger <adilger@dilger.ca>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Mon, Jul 12, 2010 at 06:08:51PM -0700, Patrick J. LoPresti wrote:
> On Mon, Jul 12, 2010 at 5:21 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> > On 2010-07-11, at 11:04, Patrick J. LoPresti wrote:
> > >
> >> + ? ? /* Absolute addressability check (borrowed from ext4/super.c) */
> >> + ? ? if ((max_block >
> >> + ? ? ? ? ?(sector_t)(~0LL) >> (osb->sb->s_blocksize_bits - 9)) ||
> >> + ? ? ? ? (max_block > (pgoff_t)(~0LL) >> (PAGE_CACHE_SHIFT -
> >> + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?osb->sb->s_blocksize_bits))) {
> >> + ? ? ? ? ? ? mlog(ML_ERROR, "Volume too large "
> >> + ? ? ? ? ? ? ? ? ?"to mount safely on this system");
> >> + ? ? ? ? ? ? status = -EFBIG;
> >> + ? ? ? ? ? ? goto out;
> >> + ? ? }
> >
> > This hunk of code is actually in several filesystems. ?It wouldn't be a bad idea to make it a library function that can be called by the filesystem to check the kernel page cache and block layer can handle these large filesystems.
> 
> True, but some of them do it differently (e.g. see the #if switch in
> xfs_sb_validate_fsb_count).  Tracking down all variants and changing
> them is a much larger task than my simple patch.

The XFS code is different to the above because there is still a 16TB
size limit on 32 bit systemsi (i.e. page cache address limits). IOWs,
you can't just remove the above 16TB check unless you (i.e. OCFS2)
handle >16TB block devices on 32 bit systems correctly...

Cheers,

Dave.
-- 
Dave Chinner
david at fromorbit.com
