From: Li Zefan <lizefan@huawei.com>
Date: Wed, 4 Jul 2012 16:00:43 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: use spinlock irqsave for
 downconvert lock.patch
In-Reply-To: <20120704073156.GC9863@dhcp-172-17-9-228.mtv.corp.google.com>
References: <1327989082-31827-1-git-send-email-srinivas.eeda@oracle.com>
	<20120704073156.GC9863@dhcp-172-17-9-228.mtv.corp.google.com>
Message-ID: <4FF3F82B.9010704@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2012/7/4 15:32, Joel Becker wrote:

> On Mon, Jan 30, 2012 at 09:51:22PM -0800, Srinivas Eeda wrote:
>> When ocfs2dc thread holds dc_task_lock spinlock and receives soft IRQ it
>> deadlock itself trying to get same spinlock in ocfs2_wake_downconvert_thread.
>> Below is the stack snippet.
>>
>> The patch disables interrupts when acquiring dc_task_lock spinlock.
>>
>> 	ocfs2_wake_downconvert_thread
>> 	ocfs2_rw_unlock
>> 	ocfs2_dio_end_io
>> 	dio_complete
>> 	.....
>> 	bio_endio
>> 	req_bio_endio
>> 	....
>> 	scsi_io_completion
>> 	blk_done_softirq
>> 	__do_softirq
>> 	do_softirq
>> 	irq_exit
>> 	do_IRQ
>> 	ocfs2_downconvert_thread
>> 	[kthread]
>>
>> Signed-off-by: Srinivas Eeda <srinivas.eeda@oracle.com>
> 
> This patch is now (finally) part of the 'fixes' branch of ocfs2.git.
> 


Recently we hit this bug too, and planned to send exactly the same fix..
