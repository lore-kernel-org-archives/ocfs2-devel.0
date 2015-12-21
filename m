From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Mon, 21 Dec 2015 15:36:58 +0800
Subject: [Ocfs2-devel] The root cause analysis about buffer read getting
 starvation
In-Reply-To: <5677DA3E020000F900023048@relay2.provo.novell.com>
References: <56736AAA020000F9001A9EEA@relay2.provo.novell.com>
	<20151218090939.GB10744@desktop.lab.bej.apac.novell.com>
	<20151218232846.GN11072@wotan.suse.de>
	<5677DA3E020000F900023048@relay2.provo.novell.com>
Message-ID: <5677AC1A.1030907@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 12/21/2015 10:53 AM, Gang He wrote:
> Hello Mark and all,
> 
> 
[ snip ]

>> > 
>> > You are correct here - the change was introduced to solve a deadlock between
>> > page lock and ip_alloc_sem(). Basically, ->readpage is going to be called
>> > with the page lock held and we need to be aware of that.
> Hello guys, my main question is, why we changed ip_alloc_sem lock/unlock position from SLES10 to SLES11?
> In SLES10, we get ip_alloc_sem lock before calling generic_file_read() or generic_file_write_nolock in file.c, 
> but in SLES11, we get ip_alloc_sem lock in ocfs2_readpage in aops.c, and more, getting/putting the page lock and ip_alloc_sem lock orders are NOT consistent in read/write path.
> I just want to know the background behind this code evolution. If we keep getting the ip_alloc_sem lock before calling generic_file_aio_read in SLES11, the deadlock can be avoided?
> then, we need not to use nonblocking way to get the lock in read_page(), buffer read will not getting starvation in such case, the read/write IO behavior will be the same with SLES10.
Holding locks during generic_file_read() will stop reader and writer
running parallel.
For ip_alloc_sem, running parallel is bad as reader and writer may touch
different pages.
For inode_lock, looks acceptable, parallel running reader and writer
will cause a lock ping-pang issue and keep truncating and flushing pages
caches, this will cause bad performance. Of course, need fixing the
recursive locking issue, or it will be very easy to run into deadlock.

Thanks,
Junxiao.
> 
> Thanks
> Gang
> 
