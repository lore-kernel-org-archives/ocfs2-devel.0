From: alex chen <alex.chen@huawei.com>
Date: Wed, 7 Jan 2015 10:19:14 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: add a mount option
 journal_async_commit on ocfs2 filesystem
In-Reply-To: <20150106155832.27f4fe62123215f4ef8bc909@linux-foundation.org>
References: <549B7C11.8030704@huawei.com>
	<20150106155832.27f4fe62123215f4ef8bc909@linux-foundation.org>
Message-ID: <54AC97A2.5080707@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On 2015/1/7 7:58, Andrew Morton wrote:
> On Thu, 25 Dec 2014 10:53:05 +0800 alex chen <alex.chen@huawei.com> wrote:
> 
>> Add a mount option to support JBD2 feature:
>> JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT. When this feature is opened,
>> journal commit block can be written to disk without waiting for
>> descriptor blocks, which can improve journal commit performance. This
>> option will enable 'journal_checksum' internally.
>>
>> Using the fs_mark benchmark, using journal_async_commit shows a 50%
>> improvement, the files per second go up from 215.2 to 317.5.
>>
>> test script:
>> fs_mark  -d  /mnt/ocfs2/  -s  10240  -n  1000
>>
>> default:
>> FSUse%        Count         Size    Files/sec     App Overhead
>>      0         1000        10240        215.2            17878
>>
>> with journal_async_commit option:
>> FSUse%        Count         Size    Files/sec     App Overhead
>>      0         1000        10240        317.5            17881
> 
> For some reason this patch is a bit mangled and I had to apply the
> first hunk by hand.
> 

Sorry for my mistake? I will send the new patch based on linux-next
kernel. Thanks.
Alex
>>  fs/ocfs2/ocfs2.h |  2 ++
>>  fs/ocfs2/super.c | 17 +++++++++++++++++
> 
> Documentation/filesystems/ocfs2.txt needs an update.
OK
> 
> 
> 
> .
> 
