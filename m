From: Matthew Wilcox <willy@infradead.org>
Date: Wed, 7 Oct 2020 19:47:30 +0100
Subject: [Ocfs2-devel] [PATCH 1/7] 9P: Cast to loff_t before multiplying
In-Reply-To: <20201007054849.GA16556@infradead.org>
References: <20201004180428.14494-1-willy@infradead.org>
	<20201004180428.14494-2-willy@infradead.org>
	<20201007054849.GA16556@infradead.org>
Message-ID: <20201007184730.GW20115@casper.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, ericvh@gmail.com, lucho@ionkov.net, viro@zeniv.linux.org.uk, jlayton@kernel.org, idryomov@gmail.com, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-btrfs@vger.kernel.org, clm@fb.com, josef@toxicpanda.com, dsterba@suse.com, stable@vger.kernel.org

On Wed, Oct 07, 2020 at 06:48:49AM +0100, Christoph Hellwig wrote:
> > -		.range_start = vma->vm_pgoff * PAGE_SIZE,
> > +		.range_start = (loff_t)vma->vm_pgoff * PAGE_SIZE,
> 
> Given the may places where this issue shows up I think we really need
> a vma_offset or similar helper for it.  Much better than chasing missing
> casts everywhere.

Good point.  I think these patches need to go in to fix the bugs in
the various stable releases, but we should definitely have a helper
for the future.  Also, several of these patches are for non-VMA
pgoff_t.

vma_offset() is a bit weird for me -- vmas have all kinds of offsets.
vma_file_offset() would work or vma_fpos().  I tend to prefer the shorter
function name ;-)

A quick grep shows we probably want a vmf_fpos() too:

arch/powerpc/platforms/cell/spufs/file.c:       unsigned long area, offset = vmf->pgoff << PAGE_SHIFT;
arch/x86/entry/vdso/vma.c:      sym_offset = (long)(vmf->pgoff << PAGE_SHIFT) +
drivers/gpu/drm/gma500/framebuffer.c:   address = vmf->address - (vmf->pgoff << PAGE_SHIFT);
drivers/scsi/cxlflash/ocxl_hw.c:        offset = vmf->pgoff << PAGE_SHIFT;

I'm sure a lot of this will never run on a 32-bit kernel or with a 4GB
file, but it's not good to have bad code around for people to copy from.
