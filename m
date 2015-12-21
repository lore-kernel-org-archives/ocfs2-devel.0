From: Gang He <ghe@suse.com>
Date: Mon, 21 Dec 2015 02:12:57 -0700
Subject: [Ocfs2-devel] The root cause analysis about buffer read getting
 starvation
In-Reply-To: <5677AC1A.1030907@oracle.com>
References: <56736AAA020000F9001A9EEA@relay2.provo.novell.com>
	<20151218090939.GB10744@desktop.lab.bej.apac.novell.com>
	<20151218232846.GN11072@wotan.suse.de>
	<5677DA3E020000F900023048@relay2.provo.novell.com>
	<5677AC1A.1030907@oracle.com>
Message-ID: <56783319020000F9000230DB@relay2.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello guys,


>>> 
> On 12/21/2015 10:53 AM, Gang He wrote:
>> Hello Mark and all,
>> 
>> 
> [ snip ]
> 
>>> > 
>>> > You are correct here - the change was introduced to solve a deadlock between
>>> > page lock and ip_alloc_sem(). Basically, ->readpage is going to be called
>>> > with the page lock held and we need to be aware of that.
>> Hello guys, my main question is, why we changed ip_alloc_sem lock/unlock 
> position from SLES10 to SLES11?
>> In SLES10, we get ip_alloc_sem lock before calling generic_file_read() or 
> generic_file_write_nolock in file.c, 
>> but in SLES11, we get ip_alloc_sem lock in ocfs2_readpage in aops.c, and 
> more, getting/putting the page lock and ip_alloc_sem lock orders are NOT 
> consistent in read/write path.
>> I just want to know the background behind this code evolution. If we keep 
> getting the ip_alloc_sem lock before calling generic_file_aio_read in SLES11, 
> the deadlock can be avoided?
>> then, we need not to use nonblocking way to get the lock in read_page(), 
> buffer read will not getting starvation in such case, the read/write IO 
> behavior will be the same with SLES10.
> Holding locks during generic_file_read() will stop reader and writer
> running parallel.
> For ip_alloc_sem, running parallel is bad as reader and writer may touch
> different pages.
> For inode_lock, looks acceptable, parallel running reader and writer
> will cause a lock ping-pang issue and keep truncating and flushing pages
> caches, this will cause bad performance. Of course, need fixing the
> recursive locking issue, or it will be very easy to run into deadlock.
The main concern is, why we do not use the related locks in read/write like SLES10 way? 
since the customer run a program, which read/write the same file from different nodes, 
the read behavior is not the same with SLES10, occasional long time read IO will let 
the customer program can't run normally. I want to discuss if we can do something to fix this problem.
Otherwise, this read behavior in parallel read/write IO is considered as a by-design issue, we will tell the truth to the customer.
Here, the read code in SLES10 like,
static ssize_t ocfs2_file_read(struct file *filp,
                               char __user *buf,
                               size_t count,
                               loff_t *ppos)
{
   ...
  
        ret = ocfs2_lock_buffer_inodes(&ctxt, NULL);  <<= cluster meta/data lock
        if (ret < 0) {
                mlog_errno(ret);
                goto bail_unlock;
        }

        down_read(&OCFS2_I(inode)->ip_alloc_sem); <<= get the lock before calling generic_file_read, then we need not to get any lock by non-block and retry way in the function, the read will become fair to get IO.

        ret = generic_file_read(filp, buf, count, ppos);

        up_read(&OCFS2_I(inode)->ip_alloc_sem);
   ...
}
   
But, the read code in SLES11 like,
there is not  cluster meta lock in ocfs2_file_aio_read(), the locks are moved into readpage function.

static int ocfs2_readpage(struct file *file, struct page *page)
{
        ...
        ret = ocfs2_inode_lock_with_page(inode, NULL, 0, page); <<= here, nonblock way to get the lock, it is not fair when there is parallel write from another node, next block way locking and retry (several hundreds times ) will cost a long time, this is why in the customer program occasional one read will cost too long time ( 1 - 15 secs). 
        if (ret != 0) {
                if (ret == AOP_TRUNCATED_PAGE)
                        unlock = 0;
                mlog_errno(ret);
                goto out;
        }

        if (down_read_trylock(&oi->ip_alloc_sem) == 0) {
                /*
                 * Unlock the page and cycle ip_alloc_sem so that we don't
                 * busyloop waiting for ip_alloc_sem to unlock
                 */
                ret = AOP_TRUNCATED_PAGE;
                unlock_page(page);
                unlock = 0;
                down_read(&oi->ip_alloc_sem);
                up_read(&oi->ip_alloc_sem);
                goto out_inode_unlock;
        }
  ...
}

Thanks
Gang

> 
> Thanks,
> Junxiao.
>> 
>> Thanks
>> Gang
>> 
