From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 20 Jun 2006 09:07:47 +0200
Subject: [Ocfs2-devel] [-mm PATCH] ocfs2: Shared writeable mmap
In-Reply-To: <20060619170736.65237ce7.akpm@osdl.org>
References: <20060619234643.GK3082@ca-server1.us.oracle.com>
	<20060619170736.65237ce7.akpm@osdl.org>
Message-ID: <1150787267.28517.126.camel@lappy>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@osdl.org>
Cc: Mark Fasheh <mark.fasheh@oracle.com>, dhowells@redhat.com, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon, 2006-06-19 at 17:07 -0700, Andrew Morton wrote:
> Mark Fasheh <mark.fasheh@oracle.com> wrote:
> >
> > I finally got some time to sit down and implement an OCFS2 patch to make use
> > of the ->page_mkwrite() callback added by David Howells' patch (named
> > 'add-page_mkwrite-vm_operations-method.patch' in -mm). The patches, and an
> > MPI program to test this can be found at:
> > 
> > http://kernel.org/pub/linux/kernel/people/mfasheh/ocfs2/mmap/
> > 
> > There's one bug however, which will cause the test program on one of the
> > reading nodes to see stale data if it is run several times in a row against
> > the same file. I have verified that the same thing works fine on a local
> > file system (ext3). I'm not sure where the issue is, but I have a feeling
> > I'm doing something bad in ocfs2_data_convert_worker(). Another possibility
> > is that we missed a place to put the ->page_mkwrite callback.
> > 
> > Unfortunately, I have to step away from this patch for a bit as I have some
> > higher priority issues to deal with :/ Luckily, it seems to be in a state
> > which I think warrants it being pushed out to the public for general review,
> > testing, etc. If anyone is interested, I'd also appreciate any advice or
> > help regarding the bug -- my VM-foo is very weak :)
> 
> Peter Zijlstra told me yesterday:
> 
>   There is a problem with the page-mkwrite last posted to lkml.  /me
>   checks your tree...  Yeah, that version has a problem:
>   http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.17-rc6/2.6.17-rc6-mm2/broken-out/add-page_mkwrite-vm_operations-method.patch
> 
>   The thing is that get_user_pages(.write=1, .force=1) can generate COW
>   hits on read-only shared mappings, this patch traps those as mkpage_write
>   candidates and fails to handle them the old way.

The -v9 version of the dirty page tracking I send out fixes this problem
by affiliation; the following patch should also be enough:

---
 mm/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: 2.6-mm/mm/memory.c
===================================================================
--- 2.6-mm.orig/mm/memory.c	2006-06-20 09:02:58.000000000 +0200
+++ 2.6-mm/mm/memory.c	2006-06-20 09:06:01.000000000 +0200
@@ -1464,7 +1464,8 @@ static int do_wp_page(struct mm_struct *
 	if (!old_page)
 		goto gotten;
 
-	if (unlikely(vma->vm_flags & VM_SHARED)) {
+	if (unlikely(vma->vm_flags & (VM_SHARED|VM_WRITE) ==
+				VM_SHARED|VM_WRITE) {
 		if (vma->vm_ops && vma->vm_ops->page_mkwrite) {
 			/*
 			 * Notify the address space that the page is about to
