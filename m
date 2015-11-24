From: Ryan Ding <ryan.ding@oracle.com>
Date: Tue, 24 Nov 2015 11:24:19 +0800
Subject: [Ocfs2-devel] [PATCH 1/4] ocfs2: fix ip_unaligned_aio deadlock
 with dio work queue
In-Reply-To: <20151123162640.fa62db07934ad869b00e5435@linux-foundation.org>
References: <1448007799-10914-1-git-send-email-ryan.ding@oracle.com>
	<20151123162640.fa62db07934ad869b00e5435@linux-foundation.org>
Message-ID: <5653D863.9080308@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Andrew,

On 11/24/2015 08:26 AM, Andrew Morton wrote:
> On Fri, 20 Nov 2015 16:23:16 +0800 Ryan Ding <ryan.ding@oracle.com> wrote:
>
>> In the current implementation of unaligned aio+dio, lock order behave as follow:
>>
>> in user process context:
>>    -> call io_submit()
>>      -> get i_mutex
>> 		<== window1
>>        -> get ip_unaligned_aio
>>          -> submit direct io to block device
>>      -> release i_mutex
>>    -> io_submit() return
>>
>> in dio work queue context(the work queue is created in __blockdev_direct_IO):
>>    -> release ip_unaligned_aio
>> 		<== window2
>>      -> get i_mutex
>>        -> clear unwritten flag & change i_size
>>      -> release i_mutex
>>
>> There is a limitation to the thread number of dio work queue. 256 at default.
>> If all 256 thread are in the above 'window2' stage, and there is a user process
>> in the 'window1' stage, the system will became deadlock. Since the user process
>> hold i_mutex to wait ip_unaligned_aio lock, while there is a direct bio hold
>> ip_unaligned_aio mutex who is waiting for a dio work queue thread to be
>> schedule. But all the dio work queue thread is waiting for i_mutex lock in
>> 'window2'.
>>
>> This case only happened in a test which send a large number(more than 256) of
>> aio at one io_submit() call.
>>
>> My design is to remove ip_unaligned_aio lock. Change it to a sync io instead.
>> Just like ip_unaligned_aio lock, serialize the unaligned aio dio.
> So this patch series is a bunch of fixes against your previous patch series:
>
> ocfs2-add-ocfs2_write_type_t-type-to-identify-the-caller-of-write.patch
> ocfs2-use-c_new-to-indicate-newly-allocated-extents.patch
> ocfs2-test-target-page-before-change-it.patch
> ocfs2-do-not-change-i_size-in-write_end-for-direct-io.patch
> ocfs2-return-the-physical-address-in-ocfs2_write_cluster.patch
> ocfs2-record-unwritten-extents-when-populate-write-desc.patch
> ocfs2-fix-sparse-file-data-ordering-issue-in-direct-io.patch
> ocfs2-code-clean-up-for-direct-io.patch
>
> correct?
Yes, you are right. :)
> Those patches are languishing a bit, awaiting review/ack.  I'll send
> everything out for a round of review soon...
Thanks a lot!
Ryan
