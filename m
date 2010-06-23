From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 22 Jun 2010 18:36:34 -0700
Subject: [Ocfs2-devel] Large (> 16TiB) volumes revisited
In-Reply-To: <AANLkTilj-EHDdqIN5SziVQXG3WGhvzWGxwKYXCwhTxnM@mail.gmail.com>
References: <AANLkTimtV44iqvA-UV5gRwWygJoh8oolTraSmcRO8ndz@mail.gmail.com>
	<20100623004937.GB20090@mail.oracle.com>
	<AANLkTilj-EHDdqIN5SziVQXG3WGhvzWGxwKYXCwhTxnM@mail.gmail.com>
Message-ID: <20100623013633.GC20090@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jun 22, 2010 at 06:12:01PM -0700, Patrick J. LoPresti wrote:
> On Tue, Jun 22, 2010 at 5:49 PM, Joel Becker <Joel.Becker@oracle.com> wrote:
> > On Tue, Jun 22, 2010 at 05:11:50PM -0700, Patrick J. LoPresti wrote:
> >
> > ? ? ? ?This patch is not sufficient. ?The journal options need to be
> > checked, as does the block addressing space of the kernel.
> 
> OK.  But I am new to this code base and would appreciate some pointers...
> 
> Specifically:
> 
> Which journal options?  Are they visible at this point in super.c?

	JBD2_FEATURE_INCOMPAT_64BIT.  You'll need to call
jbd2_journal_check_used_features() to see if the journal has it enabled.
Before you can do that, you have to ensure that the filesystem has the
OCFS2_FEATURE_COMPAT_JBD2_SB feature enabled.

> By "block addressing space of the kernel", are we just talking
> sizeof(some_kernel_type) or something more involved?

	sector_t.  You can copy what ext4 did here.

2709         if ((ext4_blocks_count(es) >
2710              (sector_t)(~0ULL) >> (sb->s_blocksize_bits - 9)) ||
2711             (ext4_blocks_count(es) >
2712              (pgoff_t)(~0ULL) >> (PAGE_CACHE_SHIFT - sb->s_blocksize_bits))     ) {
2713                 ext4_msg(sb, KERN_ERR, "filesystem"
2714                          " too large to mount safely on this system");

	blocks_count is, of course, the calculation we already perform
to turn di->i_clusters into how many blocks we have.
	We must always fail if we can't address our disk in sector_t.
Once we've gotten past that check, we then need to figure out if our
journal can address our entire disk.  So if our current test for ">
(u32)~0UL" returns true, one must then check for the 64BIT feature.

Joel

-- 

"You don't make the poor richer by making the rich poorer."
	- Sir Winston Churchill

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
