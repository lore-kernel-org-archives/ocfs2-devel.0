From: Gang He <ghe@suse.com>
Date: Thu, 29 Oct 2015 02:26:25 -0600
Subject: [Ocfs2-devel] [PATCH v2 0/4] Add online file check feature
In-Reply-To: <5631CEDC.8030901@oracle.com>
References: <1446013561-22121-1-git-send-email-ghe@suse.com>
	<5630F932.8050701@oracle.com>
	<563214C4020000F90001C407@relay2.provo.novell.com>
	<5631CEDC.8030901@oracle.com>
Message-ID: <563248B1020000F90001C446@relay2.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: srinivas.eeda@oracle.com, Mark Fasheh <MFasheh@suse.com>, rgoldwyn@suse.de
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Hello Srini,

The real cases are that we try to fix some independent issues without turning the file system off-line (error=continue was introduced).
You know, the online file check feature is used for fixing some independent or light meta-data block corruption, e.g. inode block, file extent block, dir entry block, etc.
These corruptions are usually like checksum error, blk number inconsistency, etc. 

Thanks
Gang  


-- 
<The HTML signature 'New Signature' does not contain any text>


>>> 
> Hi Gang,
> 
> thanks for pointing to explanation of the feature.
> 
> What I am curious about is ... what were the real cases that you came 
> across prompted this change and how this change would help in that case.
> 
> Thanks,
> --Srini
> 
> 
> On 10/28/2015 09:44 PM, Gang He wrote:
>> Hello Srini,
>>
>> There is a doc about ocfs2 online file check.
>>
>> OCFS2 online file check
>> -----------------------
>>
>> This document will describe OCFS2 online file check feature.
>>
>> Introduction
>> ============
>> OCFS2 is often used in high-availaibility systems. However, OCFS2 usually
>> converts the filesystem to read-only on errors. This may not be necessary, 
> since
>> turning the filesystem read-only would affect other running processes as 
> well,
>> decreasing availability. Then, a mount option (errors=continue) was 
> introduced,
>> which would return the EIO to the calling process and terminate furhter
>> processing so that the filesystem is not corrupted further. So,the 
> filesystem is
>> not converted to read-only, and the problematic file's inode number is 
> reported
>> in the kernel log so that the user can try to check/fix this file via online
>> filecheck feature.
>>
>> Scope
>> =====
>> This effort is to check/fix small issues which may hinder day-to-day 
> operations
>> of a cluster filesystem by turning the filesystem read-only. The scope of
>> checking/fixing is at the file level, initially for regular files and 
> eventually
>> to all files (including system files) of the filesystem.
>>
>> In case of directory to file links is incorrect, the directory inode is
>> reported as erroneous.
>>
>> This feature is not suited for extravagant checks which involve dependency 
> of
>> other components of the filesystem, such as but not limited to, checking if 
> the
>> bits for file blocks in the allocation has been set. In case of such an 
> error,
>> the offline fsck should/would be recommended.
>>
>> Finally, such an operation/feature should not be automated lest the 
> filesystem
>> may end up with more damage than before the repair attempt. So, this has to
>> be performed using user interaction and consent.
>>
>> User interface
>> ==============
>> When there are errors in the OCFS2 filesystem, they are usually accompanied
>> by the inode number which caused the error. This inode number would be the
>> input to check/fix the file.
>>
>> There is a sysfs file for each OCFS2 file system mounting:
>>
>>    /sys/fs/ocfs2/<devname>/filecheck
>>
>> Here, <devname> indicates the name of OCFS2 volumn device which has been 
> already
>> mounted. The file above would accept inode numbers. This could be used to
>> communicate with kernel space, tell which file(inode number) will be checked 
> or
>> fixed. Currently, three operations are supported, which includes checking
>> inode, fixing inode and setting the size of result record history.
>>
>> 1. If you want to know what error exactly happened to <inode> before fixing, 
> do
>>
>>    # echo "CHECK <inode>" > /sys/fs/ocfs2/<devname>/filecheck
>>    # cat /sys/fs/ocfs2/<devname>/filecheck
>>
>> The output is like this:
>>    INO		TYPE		DONE		ERROR
>> 39502		0		1		GENERATION
>>
>> <INO> lists the inode numbers.
>> <TYPE> is what kind of operation you've done, 0 for inode check,1 for inode 
> fix.
>> <DONE> 	indicates whether the operation has been finished.
>> <ERROR> says what kind of errors was found. For the details, please refer to 
> the
>> file linux/fs/ocfs2/filecheck.h.
>>
>> 2. If you determine to fix this inode, do
>>
>>    # echo "FIX <inode>" > /sys/fs/ocfs2/<devname>/filecheck
>>    # cat /sys/fs/ocfs2/<devname>/filecheck
>>
>> The output is like this:
>>    INO		TYPE		DONE		ERROR
>> 39502		1		1		SUCCESS
>>
>> This time, the <ERROR> column indicates whether this fix is successful or not.
>>
>> 3. The record cache is used to store the history of check/fix result. Its
>> defalut size is 10, and can be adjust between the range of 10 ~ 100. You can
>> adjust the size like this:
>>
>>    # echo "SET <size>" > /sys/fs/ocfs2/<devname>/filecheck
>>
>> Fixing stuff
>> ============
>> On receivng the inode, the filesystem would read the inode and the
>> file metadata. In case of errors, the filesystem would fix the errors
>> and report the problems it fixed in the kernel log. As a precautionary 
> measure,
>> the inode must first be checked for errors before performing a final fix.
>>
>> The inode and the fix history will be maintained temporarily in a
>> small linked list buffer which would contain the last (N) inodes
>> fixed/checked, along with the logs of what errors were reported/fixed.
>>
>> Thanks
>> Gang
>>
>>
>>> Hi Gang,
>>>
>>> thank you for implementing this. I would like to understand this better
>>> on where and how it helps ... would you mind sharing couple
>>> examples(real scenarios).
>>>
>>> Thanks,
>>> --Srini
>>>
>>>
>>> On 10/27/2015 11:25 PM, Gang He wrote:
>>>> When there are errors in the ocfs2 filesystem,
>>>> they are usually accompanied by the inode number which caused the error.
>>>> This inode number would be the input to fixing the file.
>>>> One of these options could be considered:
>>>> A file in the sys filesytem which would accept inode numbers.
>>>> This could be used to communication back what has to be fixed or is fixed.
>>>> You could write:
>>>> $# echo "CHECK <inode>" > /sys/fs/ocfs2/devname/filecheck
>>>> or
>>>> $# echo "FIX <inode>" > /sys/fs/ocfs2/devname/filecheck
>>>>
>>>> Compare with first version, I use strncasecmp instead of double strncmp
>>>> functions. Second, update the source file contribution vendor.
>>>>
>>>> Gang He (4):
>>>>     ocfs2: export ocfs2_kset for online file check
>>>>     ocfs2: sysfile interfaces for online file check
>>>>     ocfs2: create/remove sysfile for online file check
>>>>     ocfs2: check/fix inode block for online file check
>>>>
>>>>    fs/ocfs2/Makefile      |   3 +-
>>>>    fs/ocfs2/filecheck.c   | 566
>>> +++++++++++++++++++++++++++++++++++++++++++++++++
>>>>    fs/ocfs2/filecheck.h   |  48 +++++
>>>>    fs/ocfs2/inode.c       | 196 ++++++++++++++++-
>>>>    fs/ocfs2/inode.h       |   3 +
>>>>    fs/ocfs2/ocfs2_trace.h |   2 +
>>>>    fs/ocfs2/stackglue.c   |   3 +-
>>>>    fs/ocfs2/stackglue.h   |   2 +
>>>>    fs/ocfs2/super.c       |   5 +
>>>>    9 files changed, 820 insertions(+), 8 deletions(-)
>>>>    create mode 100644 fs/ocfs2/filecheck.c
>>>>    create mode 100644 fs/ocfs2/filecheck.h
>>>>
