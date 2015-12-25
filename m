From: Eric Ren <zren@suse.com>
Date: Fri, 25 Dec 2015 17:05:11 +0800
Subject: [Ocfs2-devel] The root cause analysis about buffer read getting
 starvation
In-Reply-To: <56736AAA020000F9001A9EEA@relay2.provo.novell.com>
References: <56736AAA020000F9001A9EEA@relay2.provo.novell.com>
Message-ID: <20151225090511.GA18080@laptop.ha>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark and Gang,

> In the past days, I and Eric were looking at a customer issue, the customer is complaining that buffer reading sometimes lasts too much time ( 1 - 10 seconds) in case reading/writing the same file from different nodes concurrently, some day ago I sent a mail to the list for some discussions, you can read some details via the link https://oss.oracle.com/pipermail/ocfs2-devel/2015-December/011389.html.
> But, this problem does not happen under SLES10 (sp1 - sp4), the customer upgraded his Linux OS to SLES11(sp3 or sp4), the problem happened, this is why the customer complains, he hope we can give a investigation, to see how to make OCFS2 buffer reading/writing behavior be consistent with SLES10.
Sorry for the previous false testing report, which must mislead you somehow. Actually, sle10
sp4(not sure how about sp2/3) is free of the problem we're discussing, according to both code
analysis and new more careful testing result. As Gang said, the cluster lock and local lock
has changed a lot. The 2 biggest change in my head is:
1. for read, cluster lock is put into *_readpage(s), leaving the rest part of read() such as
copying data from page cache to user space. This can result in page cache being truncated by
downconvert thread on behalf of another node before copied to user space, especially in
fierce contention of cluster lock.

2. The order of getting cluster lock and local lock is changed, in order to avoid
deadlock, then the unblocked way to get cluster lock was introduced. Gang concern about this
more. So I won't repeat it;-)

Here I want to focus on the 1st case, because there's only one thread, i.e either reading or
writing on each node in this case, so local lock may not matter too much, besides the lock
inversion problem.

OK, just some thoughts on 1st issue. Please correct me if anything wrong.
1. to be convinient for discussion, I'd like to give read() and write() path here:
 vfs_read()
  ocfs2_file_aio_read()
    ocfs2_inode_lock_atime
    ocfs2_inode_unlock()
      generic_file_aio_read()
        do_generic_file_read()
           page_cache_sync_readahead() or page_cache_async_readahead()
              ocfs2_readpages()
                  ocfs2_inode_lock_full(NOBLOCK)
                  down_read_trylock(ip_alloc_sem)
              ocfs2_readpage() /* continue to retry until to succeed */
                  ocfs2_inode_lock_with_page(NOBLOCK)
                  down_read_trylock(ip_alloc_sem)
                  ocfs2_inode_unlock
              PAGE OK: COPY PAGE TO USER SPACE

 vfs_write()
    ocfs2_file_aio_write()
      ocfs2_rw_lock(EX)
       generic_buffered_write()
        generic_perform_write()
         ocfs2_write_begin()
              ocfs2_inode_lock_full()
              dow_write(ip_alloc_sem)
          COPY FROM USER SPACE
          ocfs2_write_end()
               up_write(ip_alloc_sem)
               ocfs2_inode_unlock
      ocfs2_rw_unlock()

2. There is a race window to truncate page cache, making the effort of readahead and
*_readpage stuff go to waste!

For read(), the cluster lock just be held when doing readpage() stuff, to get data from
disk  to page cache. When the contention of cluster lock for same file is rather fierce,
so it's likely EX lock from another node has been already queued. Once returning from readpage(),
cluster lock will been released, which will kick up downconvert thread to work. Then ocfs2dc will
truncate all cached pages:
---
3583 static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
3584                                      int blocking)
3585 {
 ...
3616         sync_mapping_buffers(mapping);
3617         if (blocking == DLM_LOCK_EX) {
3618                 truncate_inode_pages(mapping, 0);
3619         } else {
   ....
---

3. testing
I'd like to elaborate how I tested and the result data if you have intersts.
Not here, or this thead would extend too long. Overall, it looks that the more fiercer
the contention is, the more unfair read() is treated...

4. kernel version info
Linux sle10sp1 2.6.16.46-0.12-smp #1 SMP Thu May 17 14:00:09 UTC 2007 x86_64 x86_64 x86_64
GNU/Linux

sle10sp4:~ # uname -a
Linux sle10sp4 2.6.16.60-0.85.1-smp #1 SMP Thu Mar 17 11:45:06 UTC 2011 x86_64 x86_64
x86_64 GNU/Linux

5. readpage() on sle10 sp1 is like:
---
211 static int ocfs2_readpage(struct file *file, struct page *page)
212 {
213         int ret;
214 
215         mlog_entry("(0x%p, %lu)\n", file, (page ? page->index : 0));
216 
217         ret = block_read_full_page(page, ocfs2_get_block);
218 
219         mlog_exit(ret);
220 
221         return ret;
222 }
---

It's not long time for me on ocfs2, so I'm not really sure if I'm reporting stupid
issue again ;-)  Look forward your comments on this!

Thanks,
Eric
> According to our code reviewing and some testings, we found that the root cause to let buffer read get starvation.
> The suspicious code in aops.c 
>  274 static int ocfs2_readpage(struct file *file, struct page *page)
>  275 {
>  276         struct inode *inode = page->mapping->host;
>  277         struct ocfs2_inode_info *oi = OCFS2_I(inode);
>  278         loff_t start = (loff_t)page->index << PAGE_CACHE_SHIFT;
>  279         int ret, unlock = 1;
>  280         long delta;
>  281         struct timespec t_enter, t_mid1, t_mid2, t_exit;
>  282
>  283         trace_ocfs2_readpage((unsigned long long)oi->ip_blkno,
>  284                              (page ? page->index : 0));
>  285
>  286         ret = ocfs2_inode_lock_with_page(inode, NULL, 0, page);  <<= here, using nonblock way to get lock will bring many times retry, spend too much time
>  287         if (ret != 0) {
>  288                 if (ret == AOP_TRUNCATED_PAGE)
>  289                         unlock = 0;
>  290                 mlog_errno(ret);
>  291                 goto out;
>  292         }
>  293
>  294         if (down_read_trylock(&oi->ip_alloc_sem) == 0) {  <<= here, the same problem with above
>  295                 /*
>  296                  * Unlock the page and cycle ip_alloc_sem so that we don't
>  297                  * busyloop waiting for ip_alloc_sem to unlock
>  298                  */
>  299                 ret = AOP_TRUNCATED_PAGE;
>  300                 unlock_page(page);
>  301                 unlock = 0;
>  302                 down_read(&oi->ip_alloc_sem);
>  303                 up_read(&oi->ip_alloc_sem);
>  304                 goto out_inode_unlock;
>  305         }
> 
> 
> As you can see, using nonblock way to get lock will bring many time retry, spend too much time.
> We can't modify the code to using block way to get the lock, as this will bring a dead lock.
> Actually, we did some testing when trying to use block way to get the lock here, the deadlock problems were encountered.
> But, in SLES10 source code, there is not any using nonblock way to get lock in buffer reading/writing, this is why buffer reading/writing are very fair to get IO when reading/writing the same file from multiple nodes. 
> Why the dead locks happen on SLES11? you can see the source code, there are some code change, especially inode alloc_sem lock.
> On SLES11, to get  inode alloc_sem lock is moved into ocfs2_readpage and ocfs2_write_begin, why we need to do that? this will let us to bring a dead lock factor, to avoid the dead locks, we will have to use nonblocking way to get some locks in ocfs2_readpage, the result will let buffer reading be unfair to get IO. and that, to avoid CPU busy loop, add some code to get the lock with block way in case can't get a lock in nonblock way, waste too much time also.
> Finally, I want to discuss with your guys, how to fix this issue? could we move the inode alloc_sem lock back to ocfs2_file_aio_read/ocfs2_file_aio_write? 
> we can get the inode alloc_sem lock before calling into ocfs2_readpage/ocfs2_write_begin, just like SLES10. 
> Since I have not enough background behind these code changes, hope you can give some comments.
> 
> Thanks a lot.
> Gang
> 
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
