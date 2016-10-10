From: Gang He <ghe@suse.com>
Date: Sun, 09 Oct 2016 19:51:41 -0600
Subject: [Ocfs2-devel] What are the purposes of
 GLOBAL_INODE_ALLOC_SYSTEM_INODE and BAD_BLOCK_SYSTEM_INODE system file
In-Reply-To: <57FA1D0E.3020204@huawei.com>
References: <57FA748D020000F90004EEB3@prv-mh.provo.novell.com>
	<57FA1D0E.3020204@huawei.com>
Message-ID: <57FB64AD020000F90004EF8A@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Junxiao and Joseph,

Thank for your confirm. 

-Gang


>>> 
> Hi Gang,
> GLOBAL_INODE_ALLOC_SYSTEM_INODE is used for system file inodes
> allocation, you can refer mkfs.c for details.
> 
> Thanks,
> Joseph
> 
> On 2016/10/9 16:47, Gang He wrote:
>> Hello Guys,
>> 
>> If you use debugfs.ocfs2 to list system files for a ocfs2 file system, you 
> can find these two system files.
>> sles12sp1-node1:/ # debugfs.ocfs2 /dev/sdb1
>> debugfs.ocfs2 1.8.2
>> debugfs: ls //
>>  6               16   1    2  .
>>  6               16   2    2  ..
>>  7               24   10   1  bad_blocks             << ==  
> BAD_BLOCK_SYSTEM_INODE
>>  8               32   18   1  global_inode_alloc     << ==  
> GLOBAL_INODE_ALLOC_SYSTEM_INODE
>>   ....
>> 
>> But, What are the purposes of GLOBAL_INODE_ALLOC_SYSTEM_INODE and 
> BAD_BLOCK_SYSTEM_INODE system file?
>> For BAD_BLOCK_SYSTEM_INODE system file, it looks to be used to store bad 
> blocks for a file system partition, but from the code, there is not any code 
> for this system file.
>> For GLOBAL_INODE_ALLOC_SYSTEM_INODE system file, there is also not any code 
> for it, what is the purpose of this file ?
>> 
>> 
>> Thanks
>> Gang
>> 
>> 
>> 
>> 
>> 
>> .
>> 
