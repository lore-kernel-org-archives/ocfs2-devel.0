From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 1 Jun 2018 16:47:52 -0700
Subject: [Ocfs2-devel] [PATCH v2] fs: ocfs2: Adding new return type
	vm_fault_t
In-Reply-To: <20180523153258.GA28451@jordon-HP-15-Notebook-PC>
References: <20180523153258.GA28451@jordon-HP-15-Notebook-PC>
Message-ID: <20180601164752.027e4f087da1b545f15c6832@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: mfasheh@versity.com, jlbec@evilplan.org, willy@infradead.org, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Wed, 23 May 2018 21:02:58 +0530 Souptick Joarder <jrdr.linux@gmail.com> wrote:

> Use new return type vm_fault_t for fault handler. For
> now, this is just documenting that the function returns
> a VM_FAULT value rather than an errno. Once all instances
> are converted, vm_fault_t will become a distinct type.
> 
> Ref-> commit 1c8f422059ae ("mm: change return type to vm_fault_t")
> 
> vmf_error() is the newly introduce inline function
> in 4.18.
> 
> Fix one checkpatch.pl warning by replacing BUG_ON()
> with WARN_ON()

err, no, I'll revert that part.

It could be that if this assertion triggers then filesystem corruption
would ensue, in which case a BUG_ON() is the appropriate handling. 
Such a change should be submitted separately, please.

--- a/fs/ocfs2/mmap.c~fs-ocfs2-adding-new-return-type-vm_fault_t-fix
+++ a/fs/ocfs2/mmap.c
@@ -120,7 +120,7 @@ static vm_fault_t __ocfs2_page_mkwrite(s
 		goto out;
 	}
 	err = ocfs2_write_end_nolock(mapping, pos, len, len, fsdata);
-	WARN_ON(err != len);
+	BUG_ON(err != len);
 	ret = VM_FAULT_LOCKED;
 out:
 	return ret;
_
