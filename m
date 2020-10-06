From: Jeff Layton <jlayton@kernel.org>
Date: Tue, 06 Oct 2020 13:20:42 -0400
Subject: [Ocfs2-devel] [PATCH 3/7] ceph: Promote to unsigned long long
	before shifting
In-Reply-To: <20201004180428.14494-4-willy@infradead.org>
References: <20201004180428.14494-1-willy@infradead.org>
	<20201004180428.14494-4-willy@infradead.org>
Message-ID: <f10381885b6e3ea8af828f1b7be5c2f7035e82df.camel@kernel.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-fsdevel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>
Cc: ericvh@gmail.com, lucho@ionkov.net, viro@zeniv.linux.org.uk, mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-btrfs@vger.kernel.org, clm@fb.com, josef@toxicpanda.com, dsterba@suse.com, stable@vger.kernel.org

On Sun, 2020-10-04 at 19:04 +0100, Matthew Wilcox (Oracle) wrote:
> On 32-bit systems, this shift will overflow for files larger than 4GB.
> 
> Cc: stable at vger.kernel.org
> Fixes: 61f68816211e ("ceph: check caps in filemap_fault and page_mkwrite")
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/ceph/addr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 6ea761c84494..970e5a094035 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1522,7 +1522,7 @@ static vm_fault_t ceph_filemap_fault(struct vm_fault *vmf)
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_file_info *fi = vma->vm_file->private_data;
>  	struct page *pinned_page = NULL;
> -	loff_t off = vmf->pgoff << PAGE_SHIFT;
> +	loff_t off = (loff_t)vmf->pgoff << PAGE_SHIFT;
>  	int want, got, err;
>  	sigset_t oldset;
>  	vm_fault_t ret = VM_FAULT_SIGBUS;


I went ahead and merged this into the ceph-client/testing branch. Given
how old this bug is, I don't see a real need to rush this into v5.9, but
if we have any other patches going in before that ships, then it might
be good to send this one along too.
-- 
Jeff Layton <jlayton@kernel.org>
