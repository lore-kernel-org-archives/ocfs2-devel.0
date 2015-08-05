From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 5 Aug 2015 10:37:46 +0800
Subject: [Ocfs2-devel] Do you know this issue? thanks
In-Reply-To: <55C1E35D020000F900010F1A@relay2.provo.novell.com>
References: <55AFBD47020000F90000F7DF@relay2.provo.novell.com>
	<55B0536C.8020603@huawei.com>
	<55B104E6020000F90000F9E8@relay2.provo.novell.com>
	<55BFA4A6020000F900010B18@relay2.provo.novell.com>
	<55BF40BF.70701@huawei.com>
	<55C0A054020000F900010CFD@relay2.provo.novell.com>
	<55C0821E.5030903@huawei.com>
	<55C1E35D020000F900010F1A@relay2.provo.novell.com>
Message-ID: <55C176FA.3010604@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2015/8/5 10:20, Gang He wrote:
> Hi Joseph,
> 
> Thank a lot, more one question.
> 
> 
>>>>
>> Hi Gang,
>>
>> On 2015/8/4 11:21, Gang He wrote:
>>> Hi Joseph,
>>>
>>> Thank for your good explaining, have more one question.
>>>
>>>
>>>>>>
>>>> Hi Gang,
>>>> On 2015/8/3 17:28, Gang He wrote:
>>>>> Hello guys,
>>>>>
>>>>> I went through OCFS2 journal and JBD2 code, I just have one question as 
>>>> below,
>>>>> If there are some nodes which are running, one node (node A) suddenly 
>>>> crashes, one another node (node B) will recover node A's journal records. 
>> But 
>>>> here looks a problem, if node B ever changed one file, and node A also 
>>>> changed this same file, then node B will replay these changed meta buffers, 
>>>> JBD2 recovery code will memcpy the journal meta buffer to the node B's 
>>>> memory, this inode's meta buffer will be replaced by node A's journal 
>> record, 
>>>> but this inode structure in memory will not be reflected, this will cause 
>>>> this kind of issue? I feel that my guess should be wrong, since this problem 
>>
>>>> looks too obvious, but who can help to figure out how to solve this problem 
>>>> when a running node try to recover a crashed node's journal.
>>>>>
>>>> Please note that nodes can update the same inode only after it has got
>>>> the cluster lock. And if the lock level is not compatible, it will
>>>> downcovert first, which will do the checkpoint.
>>>> So I don't think the issue you described really exists.
>>> You means, if Node A try to change the same file when Node B is changing (or 
>> just changed) this file, it must wait until Node B finishes the checkpoint 
>> for these meta buffers,
>>> then, Node A will re-read these meta buffers from the shared disk and gets 
>> the lock, my understanding is right? if yes, how the inode meta buffer 
>> reflect the inode structure in the memory?
>>> There is a case, if Node A ever read a file, then Node B changes the same 
>> file and write the journal records to the log file (the meta buffers are not 
>> flushed to the file system) and crashes, at this moment, Node A is replaying 
>> the journal records and a user is trying to access/change this file, what 
>> will happen? the memory inode will be inconsistent with just recovered meta 
>> buffer? looks a little complicated.
>>>
>> Node A reads a file (take inode lock, level PR), then Node B changes the
>> same file (take inode lock, level EX). Here when Node B takes the inode
>> EX lock, Node A should downcovert to NL because PR and EX are incompatible.
>> So inode cache in Node A is invalid now.
>> And only after recovering Node B successfully, Node A can access the file.
>> (Because lock is holding by Node B).
> The answer looks reasonable, just one question for how Node A re-get  the file(inode) lock after Node B crashed?
> since Node B crashed, it no longer do anything, how Node A re-get the file cluster lock? base on timeout? or journal recovery of Node B from another Node (maybe or not maybe Node A), I just doubt that journal records do not include any DLM lock related information.
> 
As described in the previous mail, though Node B has crashed, but the
lockres master still thinks Node B has got the EX lock. Now Node A wants
to take the PR lock and it will be blocked. This requires DLM recovery
first.

Thanks,
Joseph
> 
> Thanks
> Gang
> 
>>
>>> Thanks
>>> Gang   
>>>  
>>>
>>>>
>>>> Thanks
>>>> Joseph
>>>>>
>>>>> Thanks
>>>>> Gang 
> 
> 
> .
> 
