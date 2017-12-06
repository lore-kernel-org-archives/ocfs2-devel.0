From: Larry Chen <lchen@suse.com>
Date: Wed, 6 Dec 2017 17:18:08 +0800
Subject: [Ocfs2-devel] Fwd: RES: [Ocfs2-users] How do I resize Ocfs2
 filesystem using Pacemaker stack?
In-Reply-To: <5A27D51C020000F90009CAD1@suse.com>
References: <5A27D51C020000F90009CAD1@suse.com>
Message-ID: <af83ee30-a655-1046-869a-7cb72acef4d9@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Carlos,

Could you please provide the command line used to format

the partition?

I found this prompt comes from code of o2cb stack.

Unable to access cluster service while closing device
"/dev/mapper/storage1-part2"

Thanks,
Larry

>> Hello Gang,
>> Tank you for your fast answer.
>>
>>> Hello Carlos,
>>>> Hi all.
>>>>
>>>> We have a OCFS2 clustered file system running with Pacemaker stack
>>>> over a Dell storage.
>>>> Now we need to enlarge the size of the file system. We already have
>>>> grown it at the storage and with fdisk it was recreated the partition
>>>> to allocate the new available size.
>>>>
>>>> To resize the disk I umounted the filesystem and left the DLM running.
>>>>
>>>> When I tried to resize the OCFS2 filesystem with tunefs.ocfs2, it
>>>> couldn't find the cluster stack.
>>>>
>>>> apolo:~ # tunefs.ocfs2 -S /dev/mapper/storage1-part2
>>>> tunefs.ocfs2: Unable to access cluster service while closing device
>>>> "/dev/mapper/storage1-part2"
>>> Could you use "crm_mon" comand to identify the current cluster status is
>> OK?
>>
>> The file system is mounted at boot when the Pacemaker starts, as it is
>> configured on it.
>>
>> Last updated: Mon Dec  4 15:23:11 2017
>> Last change: Sat Dec  2 02:03:59 2017
>> Stack: corosync
>> Current DC: diana (2) - partition with quorum
>> Version: 1.1.12-1.1.12.git20140904.266d5c2
>> 2 Nodes configured
>> 13 Resources configured
>>
>>
>> Online: [ apolo diana ]
>>
>> stonith_sbd     (stonith:external/sbd): Started diana
>>   Clone Set: base-clone [dlm]
>>       Started: [ apolo diana ]
>>   Clone Set: c-clusterfs [clusterfs]
>>       Started: [ apolo diana ]
>>   Clone Set: web_server [apache]
>>       Started: [ apolo diana ]
>>   Clone Set: c-ip_httpd [ip_httpd]
>>       Started: [ apolo diana ]
>>
>>> Next, could you mount this partition first? just want to know if this
>> partition is integrated, since most people use LVM to extend the disk.
>>
>> This is how it is mounted
>> apolo:~ # mount | grep ocfs2
>> /dev/mapper/storage1-part2 on /export type ocfs2
>> (rw,noatime,heartbeat=none,nointr,data=ordered,errors=remount-ro,atime_quant
>> um=60,localalloc=1,cluster_stack=pcmk,coherency=full,user_xattr,acl)
>>
>>> Then do the file system extension command.
>> With the filesystem mounted the same issue happens.
>> apolo:~ # tunefs.ocfs2 -S /dev/mapper/storage1-part2
>> tunefs.ocfs2: Unable to access cluster service while closing device
>> "/dev/mapper/storage1-part2"
>>
>>> If still not work, please report a bug.
>> As openSUSE 13.2 isn't supported anymore, I don't know if they will take a
>> look at this.
>>
>> Is there a way I can change the stack of the filesystem, extend it and
>> change the stack back to Pacemaker?
>>
>> Regards,
>> Carlos.
