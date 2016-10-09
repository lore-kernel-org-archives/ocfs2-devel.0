From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Sun, 9 Oct 2016 17:00:54 +0800
Subject: [Ocfs2-devel] What are the purposes of
 GLOBAL_INODE_ALLOC_SYSTEM_INODE and BAD_BLOCK_SYSTEM_INODE system file
In-Reply-To: <57FA748D020000F90004EEB3@prv-mh.provo.novell.com>
References: <57FA748D020000F90004EEB3@prv-mh.provo.novell.com>
Message-ID: <5f570c35-f9c7-d4f7-4ee3-9be40f17ab7c@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10/09/2016 04:47 PM, Gang He wrote:
> Hello Guys,
> 
> If you use debugfs.ocfs2 to list system files for a ocfs2 file system, you can find these two system files.
> sles12sp1-node1:/ # debugfs.ocfs2 /dev/sdb1
> debugfs.ocfs2 1.8.2
> debugfs: ls //
>  6               16   1    2  .
>  6               16   2    2  ..
>  7               24   10   1  bad_blocks             << ==  BAD_BLOCK_SYSTEM_INODE
>  8               32   18   1  global_inode_alloc     << ==  GLOBAL_INODE_ALLOC_SYSTEM_INODE
>   ....
> 
> But, What are the purposes of GLOBAL_INODE_ALLOC_SYSTEM_INODE and BAD_BLOCK_SYSTEM_INODE system file?
> For BAD_BLOCK_SYSTEM_INODE system file, it looks to be used to store bad blocks for a file system partition, but from the code, there is not any code for this system file.
> For GLOBAL_INODE_ALLOC_SYSTEM_INODE system file, there is also not any code for it, what is the purpose of this file ?
These two are not used. Maybe left for future extend.

Thanks,
Junxiao.
> 
> 
> Thanks
> Gang
> 
> 
> 
> 
