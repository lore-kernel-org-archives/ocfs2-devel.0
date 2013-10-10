From: Fengguang Wu <fengguang.wu@intel.com>
Date: Thu, 10 Oct 2013 03:38:40 -0000
Subject: [Ocfs2-devel] [XFS on bad superblock] BUG: unable to handle
 kernel NULL pointer dereference at 00000003
In-Reply-To: <20131010033300.GA12952@localhost>
References: <20131009073910.GA387@localhost>
	<20131010005900.GE2025@devil.localdomain>
	<20131010011640.GA5726@localhost> <20131010014117.GA6017@localhost>
	<20131010031515.GT4446@dastard> <20131010032637.GA12725@localhost>
	<20131010033300.GA12952@localhost>
Message-ID: <20131010033834.GA13141@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>

On Thu, Oct 10, 2013 at 11:33:00AM +0800, Fengguang Wu wrote:
> On Thu, Oct 10, 2013 at 11:26:37AM +0800, Fengguang Wu wrote:
> > Dave,
> > 
> > > I note that you have CONFIG_SLUB=y, which means that the cache slabs
> > > are shared with objects of other types. That means that the memory
> > > corruption problem is likely to be caused by one of the other
> > > filesystems that is probing the block device(s), not XFS.
> > 
> > Good to know that, it would easy to test then: just turn off every
> > other filesystems. I'll try it right away.
> 
> Seems that we don't even need to do that. A dig through the oops
> database and I find stack dumps from other FS.
> 
> This happens in the kernel with same kconfig and commit 3.12-rc1.

Here is a summary of all FS with oops:

    411 ocfs2_fill_super
    189 xfs_fs_fill_super
     86 jfs_fill_super
     50 isofs_fill_super
     33 fat_fill_super
     18 vfat_fill_super
     15 msdos_fill_super
     11 ext2_fill_super
     10 ext3_fill_super
      3 reiserfs_fill_super

Thanks,
Fengguang
