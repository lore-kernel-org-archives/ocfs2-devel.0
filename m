From: Minchan Kim <minchan.kim@gmail.com>
Date: Wed, 02 Jun 2010 06:03:31 -0000
Subject: [Ocfs2-devel] [PATCH V2 0/7] Cleancache (was Transcendent
	Memory): overview
In-Reply-To: <20100528173510.GA12166@ca-server1.us.oracle.com>
References: <20100528173510.GA12166@ca-server1.us.oracle.com>
Message-ID: <AANLkTilV-4_QaNq5O0WSplDx1Oq7JvkgVrEiR1rgf1up@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: chris.mason@oracle.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, ngupta@vflare.org, jeremy@goop.org, JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@suse.de, dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com, konrad.wilk@oracle.com

Hello.

I think cleancache approach is cool. :)
I have some suggestions and questions.

On Sat, May 29, 2010 at 2:35 AM, Dan Magenheimer
<dan.magenheimer@oracle.com> wrote:
> [PATCH V2 0/7] Cleancache (was Transcendent Memory): overview
>
> Changes since V1:
> - Rebased to 2.6.34 (no functional changes)
> - Convert to sane types (Al Viro)
> - Define some raw constants (Konrad Wilk)
> - Add ack from Andreas Dilger
>
> In previous patch postings, cleancache was part of the Transcendent
> Memory ("tmem") patchset. ?This patchset refocuses not on the underlying
> technology (tmem) but instead on the useful functionality provided for Linux,
> and provides a clean API so that cleancache can provide this very useful
> functionality either via a Xen tmem driver OR completely independent of tmem.
> For example: Nitin Gupta (of compcache and ramzswap fame) is implementing
> an in-kernel compression "backend" for cleancache; some believe
> cleancache will be a very nice interface for building RAM-like functionality
> for pseudo-RAM devices such as SSD or phase-change memory; and a Pune
> University team is looking at a backend for virtio (see OLS'2010).
>
> A more complete description of cleancache can be found in the introductory
> comment in mm/cleancache.c (in PATCH 2/7) which is included below
> for convenience.
>
> Note that an earlier version of this patch is now shipping in OpenSuSE 11.2
> and will soon ship in a release of Oracle Enterprise Linux. ?Underlying
> tmem technology is now shipping in Oracle VM 2.2 and was just released
> in Xen 4.0 on April 15, 2010. ?(Search news.google.com for Transcendent
> Memory)
>
> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> Reviewed-by: Jeremy Fitzhardinge <jeremy@goop.org>
>
> ?fs/btrfs/extent_io.c ? ? ? | ? ?9 +
> ?fs/btrfs/super.c ? ? ? ? ? | ? ?2
> ?fs/buffer.c ? ? ? ? ? ? ? ?| ? ?5 +
> ?fs/ext3/super.c ? ? ? ? ? ?| ? ?2
> ?fs/ext4/super.c ? ? ? ? ? ?| ? ?2
> ?fs/mpage.c ? ? ? ? ? ? ? ? | ? ?7 +
> ?fs/ocfs2/super.c ? ? ? ? ? | ? ?3
> ?fs/super.c ? ? ? ? ? ? ? ? | ? ?8 +
> ?include/linux/cleancache.h | ? 90 +++++++++++++++++++
> ?include/linux/fs.h ? ? ? ? | ? ?5 +
> ?mm/Kconfig ? ? ? ? ? ? ? ? | ? 22 ++++
> ?mm/Makefile ? ? ? ? ? ? ? ?| ? ?1
> ?mm/cleancache.c ? ? ? ? ? ?| ?203 +++++++++++++++++++++++++++++++++++++++++++++
> ?mm/filemap.c ? ? ? ? ? ? ? | ? 11 ++
> ?mm/truncate.c ? ? ? ? ? ? ?| ? 10 ++
> ?15 files changed, 380 insertions(+)
>
> Cleancache can be thought of as a page-granularity victim cache for clean
> pages that the kernel's pageframe replacement algorithm (PFRA) would like
> to keep around, but can't since there isn't enough memory. ?So when the
> PFRA "evicts" a page, it first attempts to put it into a synchronous
> concurrency-safe page-oriented pseudo-RAM device (such as Xen's Transcendent
> Memory, aka "tmem", or in-kernel compressed memory, aka "zmem", or other
> RAM-like devices) which is not directly accessible or addressable by the
> kernel and is of unknown and possibly time-varying size. ?And when a
> cleancache-enabled filesystem wishes to access a page in a file on disk,
> it first checks cleancache to see if it already contains it; if it does,
> the page is copied into the kernel and a disk access is avoided.
> This pseudo-RAM device links itself to cleancache by setting the
> cleancache_ops pointer appropriately and the functions it provides must
> conform to certain semantics as follows:
>
> Most important, cleancache is "ephemeral". ?Pages which are copied into
> cleancache have an indefinite lifetime which is completely unknowable
> by the kernel and so may or may not still be in cleancache at any later time.
> Thus, as its name implies, cleancache is not suitable for dirty pages. ?The
> pseudo-RAM has complete discretion over what pages to preserve and what
> pages to discard and when.
>
> A filesystem calls "init_fs" to obtain a pool id which, if positive, must be
> saved in the filesystem's superblock; a negative return value indicates
> failure. ?A "put_page" will copy a (presumably about-to-be-evicted) page into
> pseudo-RAM and associate it with the pool id, the file inode, and a page
> index into the file. ?(The combination of a pool id, an inode, and an index
> is called a "handle".) ?A "get_page" will copy the page, if found, from
> pseudo-RAM into kernel memory. ?A "flush_page" will ensure the page no longer
> is present in pseudo-RAM; a "flush_inode" will flush all pages associated
> with the specified inode; and a "flush_fs" will flush all pages in all
> inodes specified by the given pool id.
>
> A "init_shared_fs", like init, obtains a pool id but tells the pseudo-RAM
> to treat the pool as shared using a 128-bit UUID as a key. ?On systems
> that may run multiple kernels (such as hard partitioned or virtualized
> systems) that may share a clustered filesystem, and where the pseudo-RAM
> may be shared among those kernels, calls to init_shared_fs that specify the
> same UUID will receive the same pool id, thus allowing the pages to
> be shared. ?Note that any security requirements must be imposed outside
> of the kernel (e.g. by "tools" that control the pseudo-RAM). ?Or a
> pseudo-RAM implementation can simply disable shared_init by always
> returning a negative value.
>
> If a get_page is successful on a non-shared pool, the page is flushed (thus
> making cleancache an "exclusive" cache). ?On a shared pool, the page

Do you have any reason about force "exclusive" on a non-shared pool?
To free memory on pesudo-RAM?
I want to make it "inclusive" by some reason but unfortunately I can't
say why I want it now.

While you mentioned it's "exclusive", cleancache_get_page doesn't
flush the page at below code.
Is it a role of user who implement cleancache_ops->get_page?

+int __cleancache_get_page(struct page *page)
+{
+       int ret = 0;
+       int pool_id = page->mapping->host->i_sb->cleancache_poolid;
+
+       if (pool_id >= 0) {
+               ret = (*cleancache_ops->get_page)(pool_id,
+                                                 page->mapping->host->i_ino,
+                                                 page->index,
+                                                 page);
+               if (ret == CLEANCACHE_GET_PAGE_SUCCESS)
+                       succ_gets++;
+               else
+                       failed_gets++;
+       }
+       return ret;
+}
+EXPORT_SYMBOL(__cleancache_get_page);

If backed device is ram(ie), Could we _move_ the pages from page cache
to cleancache?
I mean I don't want to copy page when get/put operation. we can just
move page in case of backed device "ram". Is it possible?

You send the patches which is core of cleancache but I don't see any use case.
Could you send use case patches with this series?
It could help understand cleancache's benefit.

-- 
Kind regards,
Minchan Kim
