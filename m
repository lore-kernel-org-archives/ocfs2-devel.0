From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 28 Jun 2010 14:41:29 +0800
Subject: [Ocfs2-devel] [PATCH 0/3 v5][RFC] ext3/4: enhance fsync
 performance when using CFQ
In-Reply-To: <x49k4pk60ye.fsf@segfault.boston.devel.redhat.com>
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>	<4C21D442.8080703@oracle.com>
	<4C22F316.3080009@oracle.com>
	<x49k4pk60ye.fsf@segfault.boston.devel.redhat.com>
Message-ID: <4C284419.3000905@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Moyer <jmoyer@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, linux-ext4@vger.kernel.org, vgoyal@redhat.com

Hi Jeff,

On 06/27/2010 09:48 PM, Jeff Moyer wrote:
> Tao Ma<tao.ma@oracle.com>  writes:
>
>> Hi Jeff,
>>
>> On 06/23/2010 05:30 PM, Tao Ma wrote:
>>> Hi Jeff,
>>>
>>> On 06/23/2010 05:34 AM, Jeff Moyer wrote:
>>>> Hi,
>>>>
>>>> Running iozone with the fsync flag, or fs_mark, the performance of CFQ is
>>>> far worse than that of deadline for enterprise class storage when dealing
>>>> with file sizes of 8MB or less. I used the following command line as a
>>>> representative test case:
>>>>
>>>> fs_mark -S 1 -D 10000 -N 100000 -d /mnt/test/fs_mark -s 65536 -t 1 -w
>>>> 4096 -F
>>>>
>>>> When run using the deadline I/O scheduler, an average of the first 5
>>>> numbers
>>>> will give you 448.4 files / second. CFQ will yield only 106.7. With
>>>> this patch series applied (and the two patches I sent yesterday), CFQ now
>>>> achieves 462.5 files / second.
>>> which 2 patches? Could you paste the link or the subject? Just want to
>>> make my test env like yours. ;)
>>> As Joel mentioned in another mail, ocfs2 also use jbd/jbd2, so I'd like
>>> to give it a try and give you some feedback about the test.
>> I am sorry to say that the patch make jbd2 locked up when I tested
>> fs_mark using ocfs2.
>> I have attached the log from my netconsole server. After I reverted
>> the patch [3/3], the box works again.
>
> I can't reproduce this, unfortunately.  Also, when building with the
> .config you sent me, the disassembly doesn't line up with the stack
> trace you posted.
>
> I'm not sure why yielding the queue would cause a deadlock.  The only
> explanation I can come up with is that I/O is not being issued.  I'm
> assuming that no other I/O will be completed to the file system in
> question.  Is that right?  Could you send along the output from sysrq-t?
yes, I just mounted it and begin the test, so there should be no 
outstanding I/O. So do you need me to setup another disk for test?
I have attached the sysrq output in sysrq.log. please check.

btw, I also met with a NULL pointer deference in cfq_yield. I have 
attached the null.log also. This seems to be related to the previous 
deadlock and happens when I try to remount the same volume after reboot 
and ocfs2 try to do some recovery.

Regards,
Tao
-------------- next part --------------
A non-text attachment was scrubbed...
Name: sysrq.log
Type: text/x-log
Size: 33613 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20100628/d38b6b53/attachment-0002.bin 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: null.log
Type: text/x-log
Size: 4153 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20100628/d38b6b53/attachment-0003.bin 
