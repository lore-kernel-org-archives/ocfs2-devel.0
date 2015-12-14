From: Ryan Ding <ryan.ding@oracle.com>
Date: Mon, 14 Dec 2015 13:31:23 +0800
Subject: [Ocfs2-devel] [PATCH 0/8] ocfs2: fix ocfs2 direct io code patch
 to support sparse file and data ordering semantics
In-Reply-To: <566955C2.4020302@huawei.com>
References: <1441959559-29947-1-git-send-email-ryan.ding@oracle.com>
	<5609148B.6040506@huawei.com> <5615DF35.3030802@oracle.com>
	<561609A0.5010108@huawei.com> <561B5474.6060104@oracle.com>
	<56692F9B.4040701@huawei.com> <56693C4D.8070104@oracle.com>
	<566955C2.4020302@huawei.com>
Message-ID: <566E542B.4060605@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joseph,

On 12/10/2015 06:36 PM, Joseph Qi wrote:
> Hi Ryan,
>
> On 2015/12/10 16:48, Ryan Ding wrote:
>> Hi Joseph,
>>
>> Thanks for your comments, please see my reply:
>>
>> On 12/10/2015 03:54 PM, Joseph Qi wrote:
>>> Hi Ryan,
>>>
>>> On 2015/10/12 14:34, Ryan Ding wrote:
>>>> Hi Joseph,
>>>>
>>>> On 10/08/2015 02:13 PM, Joseph Qi wrote:
>>>>> Hi Ryan,
>>>>>
>>>>> On 2015/10/8 11:12, Ryan Ding wrote:
>>>>>> Hi Joseph,
>>>>>>
>>>>>> On 09/28/2015 06:20 PM, Joseph Qi wrote:
>>>>>>> Hi Ryan,
>>>>>>> I have gone through this patch set and done a simple performance test
>>>>>>> using direct dd, it indeed brings much performance promotion.
>>>>>>>              Before      After
>>>>>>> bs=4K    1.4 MB/s    5.0 MB/s
>>>>>>> bs=256k  40.5 MB/s   56.3 MB/s
>>>>>>>
>>>>>>> My questions are:
>>>>>>> 1) You solution is still using orphan dir to keep inode and allocation
>>>>>>> consistency, am I right? From our test, it is the most complicated part
>>>>>>> and has many race cases to be taken consideration. So I wonder if this
>>>>>>> can be restructured.
>>>>>> I have not got a better idea to do this. I think the only reason why direct io using orphan is to prevent space lost when system crash during append direct write. But maybe a 'fsck -f' will do that job. Is it necessary to use orphan?
>>>>> The idea is taken from ext4, but since ocfs2 is cluster filesystem, so
>>>>> it is much more complicated than ext4.
>>>>> And fsck can only be used offline, but using orphan is to perform
>>>>> recovering online. So I don't think fsck can replace it in all cases.
>>>>>
>>>>>>> 2) Rather than using normal block direct io, you introduce a way to use
>>>>>>> write begin/end in buffer io. IMO, if it wants to perform like direct
>>>>>>> io, it should be committed to disk by forcing committing journal. But
>>>>>>> journal committing will consume much time. Why does it bring performance
>>>>>>> promotion instead?
>>>>>> I use buffer io to write only the zero pages. Actual data payload is written as direct io. I think there is no need to do a force commit. Because direct means "Try to minimize cache effects of the I/O to and from this file.", it does not means "write all data & meta data to disk before write return".
>>> I think we cannot mix zero pages with direct io here, which will lead
>>> to direct io data to be overwritten by zero pages.
>>> For example, a ocfs2 volume with block size 4K and cluster size 4K.
>>> Firstly I create a file with size of 5K and it will be allocated 2
>>> clusters (8K) and the last 3K without zeroed (no need at this time).
>> I think the last 3K will be zeroed no matter you use direct io or buffer io to create the a file with 5K.
>>> Then I seek to offset 9K and do direct write 1K, then back to 4K and do
>>> direct write 5K. Here we have to zero allocated space to avoid dirty
>>> data. But since direct write data goes to disk directly and zero pages
>>> depends on journal commit, so direct write data will be overwritten and
>>> file corrupts.
>> do_blockdev_direct_IO() will zero unwritten area within block size(in this case, 6K~8K), when get_block callback return a map with buffer_new flag. This zero operation is also using direct io.
>> So the buffer io zero operation in my design will not work at all in this case.It only works to zero the area beyond block size, but within cluster size. For example, when block size 4KB cluster size 1MB, a 4KB direct write will trigger a zero buffer page of size 1MB-4KB=1020KB.
>> I think your question is this zero buffer page will conflict with the later direct io writing to the same area. The truth is conflict will not exist, because before direct write, all conflict buffer page will be flushed to disk first (in __generic_file_write_iter()).
> How can it make sure the zero pages to be flushed to disk first? In
> ocfs2_direct_IO, it calls ocfs2_dio_get_block which uses write_begin
> and write_end, and then __blockdev_direct_IO.
> I've backported your patch set to kernel 3.0 and tested with vhd-util,
> and the result fails. The test case is below.
> 1) create a 1G dynamic vhd file, the actual size is 5K.
> # vhd-util create -n test.vhd -s 1024
> 2) resize it to 4G, the actual size becomes to 11K
> # vhd-util resize -n test.vhd -s 4096 -j test.log
> 3) hexdump the data, say hexdump1
> 4) umount to commit journal and mount again, and hexdump the data again,
> say hexdump2, which is not equal to hexdump1.
> I am not sure if there is any relations with kernel version, which
> indeed has many differences due to refactoring.
I have backported it to kernel 3.8, and run the scripts below (I think 
it's the same as your test):

     mount /dev/dm-1 /mnt
     pushd /mnt/
     rm test.vhd -f
     vhd-util create -n test.vhd -s 1024
     vhd-util resize -n test.vhd -s 4096 -j test.log
     hexdump test.vhd > ~/test.hex.1
     popd
     umount /mnt/
     mount /dev/dm-1 /mnt/
     hexdump /mnt/test.vhd > ~/test.hex.2
     umount /mnt

block size & cluster size are all 4K.
It shows there is no difference between test.hex.1 and test.hex.2. I 
think this issue is related to specified kernel version, so which 
version is your kernel? Please provide the backport patches if you wish :)

Thanks,
Ryan
>
> Thanks,
> Joseph
>
>> BTW, there is a lot testcases to test the operations like buffer write, direct write, lseek.. (it's a mix of these operations) in ltp (Linux Test Project). This patch set has passed all of them. :)
>>>>> So this is protected by "UNWRITTEN" flag, right?
>>>>>
>>>>>>> 3) Do you have a test in case of lack of memory?
>>>>>> I tested it in a system with 2GB memory. Is that enough?
>>>>> What I mean is doing many direct io jobs in case system free memory is
>>>>> low.
>>>> I understand what you mean, but did not find a better way to test it. Since if free memory is too low, even the process can not be started. If free memory is fairlyenough, the test has no meaning.
>>>> So I try to collect the memory usage during io, and do a comparison test with buffer io. The result is:
>>>> 1. start 100 dd to do 4KB direct write:
>>>> [root at hnode3 ~]# cat /proc/meminfo | grep -E "^Cached|^Dirty|^MemFree|^MemTotal|^Buffers|^Writeback:"
>>>> MemTotal:        2809788 kB
>>>> MemFree:           21824 kB
>>>> Buffers:           55176 kB
>>>> Cached:          2513968 kB
>>>> Dirty:               412 kB
>>>> Writeback:            36 kB
>>>>
>>>> 2. start 100 dd to do 4KB buffer write:
>>>> [root at hnode3 ~]# cat /proc/meminfo | grep -E "^Cached|^Dirty|^MemFree|^MemTotal|^Buffers|^Writeback:"
>>>> MemTotal:        2809788 kB
>>>> MemFree:           22476 kB
>>>> Buffers:           15696 kB
>>>> Cached:          2544892 kB
>>>> Dirty:            320136 kB
>>>> Writeback:        146404 kB
>>>>
>>>> You can see from the 'Dirty' and 'Writeback' field that there is not so much memory used as buffer io. So I think what you concern is no longer exist. :-)
>>>>
>>>> Thanks,
>>>> Ryan
>>>>> Thanks,
>>>>> Joesph
>>>>>
>>>>>> Thanks,
>>>>>> Ryan
>
>
