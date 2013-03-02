From: Joel Becker <jlbec@evilplan.org>
Date: Sat, 2 Mar 2013 02:46:31 -0800
Subject: [Ocfs2-devel] [RFC PATCH 0/3] copy-on-write extents mapping
In-Reply-To: <20130225132844.GB8232@quack.suse.cz>
References: <51244A15.2060508@oracle.com>
	<20130221152520.GA17067@quack.suse.cz>
	<20130221180039.GX22221@lenny.home.zabbo.net>
	<512A18C6.6090601@oracle.com> <20130225132844.GB8232@quack.suse.cz>
Message-ID: <20130302104630.GC22177@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: Jeff Liu <jeff.liu@oracle.com>, zab@zabbo.net, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger@dilger.ca>, Dave Chinner <david@fromorbit.com>, Mark Fasheh <mfasheh@suse.com>, Chris Mason <chris.mason@fusionio.com>, Christoph Hellwig <hch@infradead.org>, ocfs2-devel@oss.oracle.com

On Mon, Feb 25, 2013 at 02:28:44PM +0100, Jan Kara wrote:
>   Hi Jeff,
> 
> On Sun 24-02-13 21:42:30, Jeff Liu wrote:
> > Thanks for both of your comments and sorry for my too late response since
> > I have to think it over and run tests to gather the performance
> > statistics.
>   Sure, no problem.
> 
> > On 02/22/2013 02:00 AM, Zach Brown wrote:
> > >>   Can you gather some performance numbers please - i.e. how long does it take
> > >> to map such file without FIEMAP_FLAG_COW and how long with it? I'm not
> > >> completely convinced it will make such a huge difference in practice (given
> > >> du(1) isn't very performance critical application).
> > > 
> > > Seconded.
> > > 
> > > I'd like to see measurements (wall time, cpu, ios) of the time it takes
> > > to find shared extents on a giant file *on a fresh uncached mount*.
> > > 
> > > Because this interface doesn't help the file system do the work more
> > > efficiently, the kernel still has to walk everything to see if its
> > > shared.  It just saves some syscalls and copying.
> > > 
> > > That's noise compared to the io/cache footprint of the operation.
> > Firstly, the results is really frustrating to me as there basically has no performance
> > improved against a 50GB file on OCFS2.
> > 
> > The result collected on a single node OCFS2:
> > /dev/sda5 on /ocfs2 type ocfs2 (rw,sync,_netdev,heartbeat=local)
> > 
> > Create a 50GB file, and create a reflinked file from it:
> > $ dd if=/dev/zero of=testfile bs=1M count=50000
> > $ ./ocfs2_reflink testfile testfile_reflinked
> > 
> > Make the first 48GB COWed:
> > $ dd if=/dev/zero of=testfile_reflinked bs=1M count=46000 seek=0 conv=notrunc
> > 46000+0 records in
> > 46000+0 records out
> > 48234496000 bytes (48 GB) copied, 1593.44 s, 30.3 MB/s
> > 
> > The original file has 968 shared extents:
> > $ ./cow_test testfile
> > Find 968 COW extents
> > 
> > After COWed, the target reflinked file has 101 extents in shared state:
> > The latest 101 extents are in shared state:
> > $ ./cow_test testfile_reflinked
> > Find 101 COW extents
> > 
> > No matter kernel is patched or not, there basically no performance
> > improvements although 12 times fiemap ioctl(2) are reduced
> <snip>
>   Yeah, I suspected that. As Zach said, kernel has to do all the work
> anyway so you just save some small overhead of additional syscalls. But
> those are rather cheap compared to other stuff you need to do.
> 
> > But I have another idea regarding the performance if considering the
> > practical situations.  Generally, the end user would run du(1) against a
> > partition with not only the reflinked files but also includes normal
> > files which are not contains any shared extents, or if the user check up
> > the shared extents for a previous reflinked file, but maybe this file has
> > already totally COWed, that is, now it does not contains any shared
> > extent at all.
> > 
> > In either case, du(1) has to call fiemap to look through the extents
> > against this kind of files no matter it contains shared extents or not,
> > that's would be an overhead(Yes, du(1) is not a very performance critical
> > application).
> > 
> > But with a prejudegement approach, we can bypass the normal files and
> > lookup shared extents against the COW file only.
>   Yes, that would be useful and as you showed it can bring noticeable
> speedup.
> 
> > Does the results above looks make sense?  If yes, I still felt that it's
> > not a formal approach to detect reflinked files.  IMHO, if we can improve
> > the stat(2)->getattr() to fill the mode member with a flag to indicate
> > that a file is reflinked/cow or not, it would be more convenient to check
> > as like S_ISREFLINK(stat.st_mode) from the user space since du(1) always
> > fetching the statistics per file disk space accounting.
>   I agree that adding filtering to FIEMAP just to accomodate the only
> practical use case of checking whether a file has any shared extent is
> really an overkill. But changing stat(2) the way you describe is ugly hack.
> st_mode has logically nothing to do with whether file has shared extents or
> not. If anything you could use ioctl IOC_GETFLAGS for that. I'm not 100%
> sure that's the right interface but at least it isn't that ugly.

Jumping in, because I'm now back in town and paying attention.  I'm
going to respond to a bunch of points in the thread.

 - If we were going to filter, I'd like to see something more generic.
   There can be shared extents that are not COW.  FIEMAP_FLAG_COW
   doesn't fit this.  FIEMAP_FLAG_SHARED is more aligned with how we
   describe the results in the response structure.
 - Specific filter flags in FIEMAP strike me as a bad idea.  We all seem
   to agree on that.
 - The right thing is for du(1) and similar programs to just ignore
   files that have no shared extents.  The kernel shouldn't be trying to
   be smart about this.
 - Whatever way we present userspace with "this file has shared extents"
   should be generic so that all filesystems supporting shared extents
   report the same thing.  btrfs' handling of FS_IOC_GETFLAGS kind of
   works like this.
 - The more I think about it, though, I'm liking zab's synthetic xattr.
   Why not feature flags ala processors?  Imagine the xattr
   "fs:file-features" reporting "shared-extents,immutable" or somesuch.
   Free-form strings allow us to add things without the header hoops.

Joel

-- 

Life's Little Instruction Book #197

	"Don't forget, a person's greatest emotional need is to 
	 feel appreciated."

			http://www.jlbec.org/
			jlbec at evilplan.org
