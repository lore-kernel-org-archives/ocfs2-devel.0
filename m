From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 11 Aug 2016 22:10:21 +0800
Subject: [Ocfs2-devel] About ocfs2 file sytem fragmentation tool
In-Reply-To: <57ACB571020000F900045773@prv-mh.provo.novell.com>
References: <57AC859C020000F9000456B9@prv-mh.provo.novell.com>
	<57AC1AB7.9060902@huawei.com>
	<57ACB571020000F900045773@prv-mh.provo.novell.com>
Message-ID: <57AC874D.3050105@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Gang,
I think you'd better analyze in which ENOSPC returns.
Once case is though free space looks enough, it still cannot fulfill
the requirement because of requesting contiguous space.

Thanks,
Joseph

On 2016/8/11 17:27, Gang He wrote:
> Hello Joseph,
> 
> Thank for your good suggestion.
> By the way, did you encounter the issue, the user could not write with the error message "No space left on device", although there was enough fs space available? the user just wondered if the problem was related to file system fragmentation (it looks like the bug, which was fixed by Eric some week ago). 
> 
> Thanks
> Gang
> 
> 
>>>>
>> Hi Gang,
>> We can also get some information from
>>     "debugfs.ocfs2 -R 'stat //global_bitmap' <device>"
>> But unfortunately there is no summary information such as fragmentation
>> ratio.
>> We have encountered a problem that once volume usage exceeds 95%, create
>> a new big file will consume much longer time, which is because of each
>> gd in chains has little contiguous clusters.
>>
>> Thanks,
>> Joseph
>>
>>
>> On 2016/8/11 14:03, Gang He wrote:
>>> Hello Guys,
>>>
>>> Our customer is asking one question, how to detect a ocfs2 file system 
>> fragmentation status.
>>> Current, I can think of ways for detecting fragmentation as below,
>>> 1) o2info --freefrag N /dev/vdb3
>>> this command can give some information for how many free chunks (based on 
>> size) are here,
>>> but it can not give any conclusive information, e.g. the file system is 
>> fragmented, or not.  fragmentation ratio.
>>> 2) debugfs.ocfs2 -R "frag /fio1/test1"  /dev/vdb3
>>> this command can give some information only for one file, how to get the 
>> whole volume information, e.g. the file system fragmentation ratio.
>>>
>>> So, anybody can give some suggestion for ocfs2 file system fragmentation 
>> tool, it is very appreciated.
>>> For example, there is any more better way to detect the file system 
>> fragmentation ratio.
>>> The further question, if there are some free blocks in the file system, but 
>> the user cannot create a file, it is also related to fragmentation problem?
>>> The use have to use "discontig-bg" feature to overcome this problem?
>>>
>>>
>>> Thanks
>>> Gang
>>>
>>>
>>> _______________________________________________
>>> Ocfs2-devel mailing list
>>> Ocfs2-devel at oss.oracle.com 
>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel 
>>>
>>>
> 
> 
> .
> 
