From: Darrick J. Wong <darrick.wong@oracle.com>
Date: Wed, 10 Feb 2016 11:18:48 -0800
Subject: [Ocfs2-devel] [LFS/MM TOPIC] fs reflink issues,
	fs online scrub/check, etc
In-Reply-To: <20160210191715.GB6339@birch.djwong.org>
References: <20160210191715.GB6339@birch.djwong.org>
Message-ID: <20160210191848.GC6346@birch.djwong.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lsf-pc@lists.linux-foundation.org
Cc: xfs <xfs@oss.sgi.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, ocfs2-devel@oss.oracle.com

[resend, email exploded, sorry...]

Hi,

I want to discuss a few FS related topics that I haven't already seen on
the mailing lists:

 * Shared pagecache pages for reflinked files (and by extension making dax
   work with reflink on xfs)

 * Providing a simple interface for scrubbing filesystem metadata in the
   background (the online check thing).  Ideally we'd make it easy to discover
   what kind of metadata there is to check and provide a simple interface to
   check the metadata, once discovered.  This is a tricky interface topic
   since FS design differs pretty widely.

 * Rudimentary online repair and rebuilding (xfs) from secondary metadata

 * Working out the variances in the btrfs/xfs/ocfs2/nfs reflink implementations
   and making sure they all get test coverage

I would also like participate in some of the proposed discussions:

 * The ext4 summit (and whatever meeting of XFS devs may happen)

 * Integrating existing filesystems into pmem, or hallway bofs about designing
   new filesystems for pmem

 * Actually seeing the fs developers (well, everyone!) in person again :)

--Darrick
