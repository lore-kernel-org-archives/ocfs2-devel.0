From: Joseph Qi <joseph.qi@huawei.com>
Date: Tue, 8 Dec 2015 11:55:18 +0800
Subject: [Ocfs2-devel] Buffer read will get starvation in case
 reading/writing the same file from different nodes concurrently
In-Reply-To: <5666BD4D020000F900021726@relay2.provo.novell.com>
References: <5666BD4D020000F900021726@relay2.provo.novell.com>
Message-ID: <566654A6.7060308@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Gang,
Eric and I have discussed this case before.
Using NONBLOCK here is because there is a lock inversion between inode
lock and page lock. You can refer to the comments of
ocfs2_inode_lock_with_page for details.
Actually I have found that NONBLOCK mode is only used in lock inversion
cases.

Thanks,
Joseph

On 2015/12/8 11:21, Gang He wrote:
> Hello Guys,
> 
> There is a issue from the customer, who is complaining that buffer reading sometimes lasts too much time ( 1 - 10 seconds) in case reading/writing the same file from different nodes concurrently.
> According to the demo code from the customer, we also can reproduce this issue at home (run the test program under SLES11SP4 OCFS2 cluster), actually this issue can be reproduced in openSuSe 13.2 (more newer code), but in direct-io mode, this issue will disappear.
> Base on my investigation, the root cause is the buffer-io using cluster-lock is different from direct-io, I do not know why buffer-io use cluster-lock like this way.
> the code details are as below,
> in aops.c file,
>  281 static int ocfs2_readpage(struct file *file, struct page *page)
>  282 {
>  283         struct inode *inode = page->mapping->host;
>  284         struct ocfs2_inode_info *oi = OCFS2_I(inode);
>  285         loff_t start = (loff_t)page->index << PAGE_CACHE_SHIFT;
>  286         int ret, unlock = 1;
>  287
>  288         trace_ocfs2_readpage((unsigned long long)oi->ip_blkno,
>  289                              (page ? page->index : 0));
>  290
>  291         ret = ocfs2_inode_lock_with_page(inode, NULL, 0, page);  <<== this line
>  292         if (ret != 0) {
>  293                 if (ret == AOP_TRUNCATED_PAGE)
>  294                         unlock = 0;
>  295                 mlog_errno(ret);
>  296                 goto out;
>  297         } 
>  
> in dlmglue.c file,
> 2 int ocfs2_inode_lock_with_page(struct inode *inode,
> 2443                               struct buffer_head **ret_bh,
> 2444                               int ex,
> 2445                               struct page *page)
> 2446 {
> 2447         int ret;
> 2448
> 2449         ret = ocfs2_inode_lock_full(inode, ret_bh, ex, OCFS2_LOCK_NONBLOCK); <<== there, why using NONBLOCK mode to get the cluster lock? this way will let reading IO get starvation. 
> 2450         if (ret == -EAGAIN) {
> 2451                 unlock_page(page);
> 2452                 if (ocfs2_inode_lock(inode, ret_bh, ex) == 0)
> 2453                         ocfs2_inode_unlock(inode, ex);
> 2454                 ret = AOP_TRUNCATED_PAGE;
> 2455         }
> 2456
> 2457         return ret;
> 2458 }
> 
> If you know the background behind the code, please tell us, why not use block way to get the lock in reading a page, then reading IO will get the page fairly when there is a concurrent writing IO from the other node.
> Second, I tried to modify that line from OCFS2_LOCK_NONBLOCK to 0 (switch to blocking way), the reading IO will not be blocked too much time (can erase the customer's complaining), but a new problem arises, sometimes the reading IO and writing IO get a dead lock (why dead lock? I am looking at). 
> 
> 
> Thanks
> Gang  
> 
> 
> 
> .
> 
