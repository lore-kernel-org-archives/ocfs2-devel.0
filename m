From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 24 Jun 2010 13:54:30 +0800
Subject: [Ocfs2-devel] [PATCH 0/3 v5][RFC] ext3/4: enhance fsync
 performance when using CFQ
In-Reply-To: <4C21D442.8080703@oracle.com>
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>
	<4C21D442.8080703@oracle.com>
Message-ID: <4C22F316.3080009@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tao Ma <tao.ma@oracle.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>, linux-ext4@vger.kernel.org, vgoyal@redhat.com

Hi Jeff,

On 06/23/2010 05:30 PM, Tao Ma wrote:
> Hi Jeff,
>
> On 06/23/2010 05:34 AM, Jeff Moyer wrote:
>> Hi,
>>
>> Running iozone with the fsync flag, or fs_mark, the performance of CFQ is
>> far worse than that of deadline for enterprise class storage when dealing
>> with file sizes of 8MB or less. I used the following command line as a
>> representative test case:
>>
>> fs_mark -S 1 -D 10000 -N 100000 -d /mnt/test/fs_mark -s 65536 -t 1 -w
>> 4096 -F
>>
>> When run using the deadline I/O scheduler, an average of the first 5
>> numbers
>> will give you 448.4 files / second. CFQ will yield only 106.7. With
>> this patch series applied (and the two patches I sent yesterday), CFQ now
>> achieves 462.5 files / second.
> which 2 patches? Could you paste the link or the subject? Just want to
> make my test env like yours. ;)
> As Joel mentioned in another mail, ocfs2 also use jbd/jbd2, so I'd like
> to give it a try and give you some feedback about the test.
I am sorry to say that the patch make jbd2 locked up when I tested 
fs_mark using ocfs2.
I have attached the log from my netconsole server. After I reverted the 
patch [3/3], the box works again.

Regards,
Tao
-------------- next part --------------
A non-text attachment was scrubbed...
Name: lockup.log
Type: text/x-log
Size: 4429 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20100624/a9724b6e/attachment.bin 
