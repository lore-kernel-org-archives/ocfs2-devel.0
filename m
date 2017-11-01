From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 1 Nov 2017 13:49:01 -0700
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: should wait dio before inode
 lock in ocfs2_setattr()
In-Reply-To: <59F81636.70508@huawei.com>
References: <59F81636.70508@huawei.com>
Message-ID: <20171101134901.3e5c2153b21edbe59185f646@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, 31 Oct 2017 14:20:38 +0800 alex chen <alex.chen@huawei.com> wrote:

> we should wait dio requests to finish before inode lock in
> ocfs2_setattr(), otherwise the following deadlock will be happened:
> process 1                  process 2                    process 3
> truncate file 'A'          end_io of writing file 'A'   receiving the bast messages
> ocfs2_setattr
>  ocfs2_inode_lock_tracker
>   ocfs2_inode_lock_full
>  inode_dio_wait
>   __inode_dio_wait
>   -->waiting for all dio
>   requests finish
>                                                         dlm_proxy_ast_handler
>                                                          dlm_do_local_bast
>                                                           ocfs2_blocking_ast
>                                                            ocfs2_generic_handle_bast
>                                                             set OCFS2_LOCK_BLOCKED flag
>                         dio_end_io
>                          dio_bio_end_aio
>                           dio_complete
>                            ocfs2_dio_end_io
>                             ocfs2_dio_end_io_write
>                              ocfs2_inode_lock
>                               __ocfs2_cluster_lock
>                                ocfs2_wait_for_mask
>                                -->waiting for OCFS2_LOCK_BLOCKED
>                                flag to be cleared, that is waiting
>                                for 'process 1' unlocking the inode lock
>                            inode_dio_end
>                            -->here dec the i_dio_count, but will never
>                            be called, so a deadlock happened.
> 

This sounds like something which should be backported into -stable
kernels.  Do you agree?
