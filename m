From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 4 May 2015 09:46:06 +0800
Subject: [Ocfs2-devel] [RFC] Online File(system) check
In-Reply-To: <5544CC42.5080900@suse.de>
References: <20150427213227.GA28129@shrek.lan>
	<553F6853020000F90000822C@relay2.provo.novell.com>
	<553F7B56.2010909@suse.de> <553F891A.1080004@huawei.com>
	<5544CC42.5080900@suse.de>
Message-ID: <5546CF5E.6020904@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2015/5/2 21:08, Goldwyn Rodrigues wrote:
> 
> 
> On 04/28/2015 08:20 AM, Joseph Qi wrote:
>> Hi Goldwyn,
>>
>> Thanks for the good proposal.
>>
>> On 2015/4/28 20:21, Goldwyn Rodrigues wrote:
>>> Hi Gang,
>>>
>>> On 04/27/2015 10:00 PM, Gang He wrote:
>>>> Hi Glodwyn,
>>>>
>>>> Very nice proposal.
>>>> So far, there are some comments from me.
>>>> 1) which task will we do in check/fix a file, we need to define the detailed requirements further, since we just do a light-level file check/fix according to inode number, we need to know which items can be done by online check, which items can be done by offline fsck.
>>>
>>> For the first phase (regular files), these are all the reasons the disk validate function would fail. Some examples are ocfs2_validate_inode_block, ocfs2_validate_extent_block etc.
>>> As we take up system inodes (phase 2), we will add more functionality.
>>>
>> Can we classify all corrupted cases and their corresponding fix ways? Maybe we can get some hints from fsck.
> 
> That is a pretty big list. I would like to know of cases which would not work with this scenario at first.
> 
>> And I don't think errors=continue can fit for all cases.
>> For some cases we shouldn't let it continue with errors to prevent more damages.
> 
> Could you provide an example which would not fit into such a case to strengthen your argument?
> 
IMO, most system inodes would not fit. For example, group descriptor corruption.

>>
>>>> 2) can we keep check and fix two option, check option is to check if a file is good or bad, but not modify anything, fix option is to check and fix a file if the file is corrupted.
>>>
>>> Yes, there are two options, CHECKS only checks wheras FIX fixes the errors. As a precautionary measure, a CHECK command should be provided before a FIX is issued. IOW, a file should be checked for errors before actually fixing it.
>>>
>> A convenient way to know which to be checked should also be taken into consideration.
> 
> What do you infer by "which"? Is inode number not enough? Of course we would have to go through the errors reported to make sure the right inode number is listed.
>
Inode number is the basic information. But it may not be enough because
the corruption may be valid flag cleared, or an empty extent record.
So I think we have to know the corruption type.

>>
>>>> 3) when users execute the command "echo CHECK <inode> > /sys/fs/ocfs2/filecheck" to check a file, how to give the feedback information besides printing the messages to syslog?
>>>
>>> The output should be when you cat /sys/fs/ocfs2/filecheck. It would provide the results of the last (N) files checked. I don't want to flood the kernel log with this. Thanks for bringing this up, I will put it on the doc. Something like:
>>>
>>> Inode Status Description
>>> 1234   ERROR Metadata incorrect
>>> 2352   FIXED Valid flag not set
>>> 9382   CHECKING -
>>> 8926   GOOD -
>>> 7230   CANT-FIX Please execute fsck.ocfs2 after taking filesystem offline.
>>>
>>> So, for the current scenario, only 1234 can be fixed. An echo should err with EINVAL if any other inode number is provided with FIX.
>>>
>>>
>>>> 4) we should support a list to accept the "check/fix" requests from user-space and queue them, then handle them one by one, right? what is the behavior for the request user which execute "echo check ..." from the user space? the user post a request to the kernel space, then the command will end or wait for the file check end?
>>>>
>>>
>>> I would not suggest that, atleast for now. This is to improve availability. However, if the filesystem is very bad, we should suggest an offline check. However, the user can provide multiple CHECK requests.
>>>
>>
>>
>>
>>
> 
