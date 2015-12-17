From: Gang He <ghe@suse.com>
Date: Thu, 17 Dec 2015 08:08:42 -0700
Subject: [Ocfs2-devel] The root cause analysis about buffer read getting
	starvation
Message-ID: <56736AAA020000F9001A9EEA@relay2.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Mark and all,
In the past days, I and Eric were looking at a customer issue, the customer is complaining that buffer reading sometimes lasts too much time ( 1 - 10 seconds) in case reading/writing the same file from different nodes concurrently, some day ago I sent a mail to the list for some discussions, you can read some details via the link https://oss.oracle.com/pipermail/ocfs2-devel/2015-December/011389.html.
But, this problem does not happen under SLES10 (sp1 - sp4), the customer upgraded his Linux OS to SLES11(sp3 or sp4), the problem happened, this is why the customer complains, he hope we can give a investigation, to see how to make OCFS2 buffer reading/writing behavior be consistent with SLES10.
According to our code reviewing and some testings, we found that the root cause to let buffer read get starvation.
The suspicious code in aops.c 
 274 static int ocfs2_readpage(struct file *file, struct page *page)
 275 {
 276         struct inode *inode = page->mapping->host;
 277         struct ocfs2_inode_info *oi = OCFS2_I(inode);
 278         loff_t start = (loff_t)page->index << PAGE_CACHE_SHIFT;
 279         int ret, unlock = 1;
 280         long delta;
 281         struct timespec t_enter, t_mid1, t_mid2, t_exit;
 282
 283         trace_ocfs2_readpage((unsigned long long)oi->ip_blkno,
 284                              (page ? page->index : 0));
 285
 286         ret = ocfs2_inode_lock_with_page(inode, NULL, 0, page);  <<= here, using nonblock way to get lock will bring many times retry, spend too much time
 287         if (ret != 0) {
 288                 if (ret == AOP_TRUNCATED_PAGE)
 289                         unlock = 0;
 290                 mlog_errno(ret);
 291                 goto out;
 292         }
 293
 294         if (down_read_trylock(&oi->ip_alloc_sem) == 0) {  <<= here, the same problem with above
 295                 /*
 296                  * Unlock the page and cycle ip_alloc_sem so that we don't
 297                  * busyloop waiting for ip_alloc_sem to unlock
 298                  */
 299                 ret = AOP_TRUNCATED_PAGE;
 300                 unlock_page(page);
 301                 unlock = 0;
 302                 down_read(&oi->ip_alloc_sem);
 303                 up_read(&oi->ip_alloc_sem);
 304                 goto out_inode_unlock;
 305         }


As you can see, using nonblock way to get lock will bring many time retry, spend too much time.
We can't modify the code to using block way to get the lock, as this will bring a dead lock.
Actually, we did some testing when trying to use block way to get the lock here, the deadlock problems were encountered.
But, in SLES10 source code, there is not any using nonblock way to get lock in buffer reading/writing, this is why buffer reading/writing are very fair to get IO when reading/writing the same file from multiple nodes. 
Why the dead locks happen on SLES11? you can see the source code, there are some code change, especially inode alloc_sem lock.
On SLES11, to get  inode alloc_sem lock is moved into ocfs2_readpage and ocfs2_write_begin, why we need to do that? this will let us to bring a dead lock factor, to avoid the dead locks, we will have to use nonblocking way to get some locks in ocfs2_readpage, the result will let buffer reading be unfair to get IO. and that, to avoid CPU busy loop, add some code to get the lock with block way in case can't get a lock in nonblock way, waste too much time also.
Finally, I want to discuss with your guys, how to fix this issue? could we move the inode alloc_sem lock back to ocfs2_file_aio_read/ocfs2_file_aio_write? 
we can get the inode alloc_sem lock before calling into ocfs2_readpage/ocfs2_write_begin, just like SLES10. 
Since I have not enough background behind these code changes, hope you can give some comments.

Thanks a lot.
Gang
