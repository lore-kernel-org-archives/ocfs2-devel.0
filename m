From: Jens Axboe <axboe@fb.com>
Date: Tue, 19 May 2015 13:59:50 -0600
Subject: [Ocfs2-devel] [Regression] Guest fs corruption with 'block:
 loop: improve performance via blk-mq'
In-Reply-To: <555A780E.7070701@oracle.com>
References: <5557A4EC.6000508@oracle.com>	<CACVXFVOd9gOte-9t1fgdHq_GYHUHQ8kkBXz2Dzz-J3a7bv50+A@mail.gmail.com>	<555A2A76.5050701@oracle.com>	<555A7237.1030004@oracle.com>
	<CACVXFVOxzAAdR8PuN8WBm7WYC8egStV7NFP36X4HsdN4C2T_0g@mail.gmail.com>
	<555A780E.7070701@oracle.com>
Message-ID: <555B9636.6050402@fb.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: santosh shilimkar <santosh.shilimkar@oracle.com>, Ming Lei <ming.lei@canonical.com>
Cc: Christoph Hellwig <hch@lst.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On 05/18/2015 05:38 PM, santosh shilimkar wrote:
> On 5/18/2015 4:25 PM, Ming Lei wrote:
>> On Tue, May 19, 2015 at 7:13 AM, santosh shilimkar
>> <santosh.shilimkar@oracle.com> wrote:
>>> On 5/18/2015 11:07 AM, santosh shilimkar wrote:
>>>>
>>>> On 5/17/2015 6:26 PM, Ming Lei wrote:
>>>>>
>>>>> Hi Santosh,
>>>>>
>>>>> Thanks for your report!
>>>>>
>>>>> On Sun, May 17, 2015 at 4:13 AM, santosh shilimkar
>>>>> <santosh.shilimkar@oracle.com> wrote:
>>>>>>
>>>>>> Hi Ming Lei, Jens,
>>>>>>
>>>>>> While doing few tests with recent kernels with Xen Server,
>>>>>> we saw guests(DOMU) disk image getting corrupted while booting it.
>>>>>> Strangely the issue is seen so far only with disk image over ocfs2
>>>>>> volume. If the same image kept on the EXT3/4 drive, no corruption
>>>>>> is observed. The issue is easily reproducible. You see the flurry
>>>>>> of errors while guest is mounting the file systems.
>>>>>>
>>>>>> After doing some debug and bisects, we zeroed down the issue with
>>>>>> commit "b5dd2f6 block: loop: improve performance via blk-mq". With
>>>>>> that commit reverted the corruption goes away.
>>>>>>
>>>>>> Some more details on the test setup:
>>>>>> 1. OVM(XEN) Server kernel(DOM0) upgraded to more recent kernel
>>>>>> which includes commit b5dd2f6. Boot the Server.
>>>>>> 2. On DOM0 file system create a ocfs2 volume
>>>>>> 3. Keep the Guest(VM) disk image on ocfs2 volume.
>>>>>> 4. Boot guest image. (xm create vm.cfg)
>>>>>
>>>>>
>>>>> I am not familiar with xen, so is the image accessed via
>>>>> loop block inside of guest VM? Is he loop block created
>>>>> in DOM0 or guest VM?
>>>>>
>>>> Guest. The Guest disk image is represented as a file by loop
>>>> device.
>>>>
>>>>>> 5. Observe the VM boot console log. VM itself use the EXT3 fs.
>>>>>> You will see errors like below and after this boot, that file
>>>>>> system/disk-image gets corrupted and mostly won't boot next time.
>>>>>
>>>>>
>>>>> OK, that means the image is corrupted by VM booting.
>>>>>
>>>> Right
>>>>
>>>> [...]
>>>>
>>>>>>
>>>>>>   From the debug of the actual data on the disk vs what is read by
>>>>>> the guest VM, we suspect the *reads* are actually not going all
>>>>>> the way to disk and possibly returning the wrong data. Because
>>>>>> the actual data on ocfs2 volume at those locations seems
>>>>>> to be non-zero where as the guest seems to be read it as zero.
>>>>>
>>>>>
>>>>> Two big changes in the patchset are: 1) use blk-mq request based IO;
>>>>> 2) submit I/O concurrently(write vs. write is still serialized)
>>>>>
>>>>> Could you apply the patch in below link to see if it can fix the
>>>>> issue?
>>>>> BTW, this patch only removes concurrent submission.
>>>>>
>>>>> http://marc.info/?t=143093223200004&r=1&w=2
>>>>>
>>>> What kernel is this patch generated against ? It doesn't apply against
>>>> v4.0. Does this need the AIO/DIO conversion patches as well. Do you
>>>> have the dependent patch-set I can't apply it against v4.0.
>>>>
>>> Anyways, I created patch(end of the email) against v4.0, based on
>>> your patch
>>> and tested it. The corruption is no more seen so it does fix
>>> the issue after backing out concurrent submission changes from
>>> commit b5dd2f6. Let me know whats you plan with it since linus
>>> tip as well as v4.0 needs this fix.
>>
>> If your issue is caused by concurrent IO submittion, it might be one
>> issue of ocfs2. As you see, there isn't such problem for ext3/ext4.
>>
> As we speak, I got to know about another regression with XFS as well
> and am quite confident based on symptom that its similar issue.
> I will get a confirmation on the same by tomorrow whether the patch
> fixes it or not.
>
>> And the single thread patch is introduced for aio/dio support, which
>> shouldn't have been a fix patch.
>>
>
> Well before the loop blk-mq conversion commit b5dd2f6, the loop driver
> was single threaded and as you see that issue seen with that
> commit. Now with this experiment, it also proves that those work-queue
> split changes are problematic. So am not sure why do you say that it
> shouldn't be a fix patch.

There should be no issue with having concurrent submissions. If 
something relies on serialization of some sort, then that is broken and 
should be fixed up. That's not a problem with the loop driver. That's 
why it's not a fix.

-- 
Jens Axboe
