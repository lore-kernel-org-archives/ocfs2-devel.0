From: jiangyiwen <jiangyiwen@huawei.com>
Date: Thu, 20 Dec 2018 10:56:26 +0800
Subject: [Ocfs2-devel] About ocfs2 inode/extent meta file allocation
 problem
In-Reply-To: <5C19DB62020000F90004970B@prv1-mh.provo.novell.com>
References: <5C19DB62020000F90004970B@prv1-mh.provo.novell.com>
Message-ID: <5C1B04DA.4080104@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2018/12/19 13:47, Gang He wrote:
> Hello Guys,
> 
> When you read ocfs2 kernel code, you can find that ocfs2 uses inode_alloc:N / extent_alloc:N meta files to manage inode block/extent block allocation.
> The meta file per node will be increased via getting some blocks from global_bitmap meta file when the user create new files(inodes).
> But the meta files ( inode_alloc:N or extent_alloc:N) will not shrink back when these inode/extent blocks are deleted (e.g. these files are removed by the user).
> Then, if the user creates lots of files until the file system is full, next, the user deletes all the files.
> At this moment, the inode_alloc:N file is very big and occupy the whole file system, since this meta file can not shrink back.
> The user can not create a file with some data clusters, since the global_bitmap meta file has not more available cluster bits. 
> I did not do this testing in my machine, but from the code logic, I feel my idea should be true.
> Do you have any ideas for this problem? 
> My suggestion is, 
> we should return some blocks to global_bitmap meta file from inode_alloc:N / extent_alloc:N meta files when there are enough free blocks.
> 
> Thanks
> Gang      
> 
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> 

Hi Gang,

I feel the problem what you described will be exist. When there
are a lot of small files in the ocfs2 volume, it will use plentiful
enough space as inode/extent allocs' group descriptors.
I agree your idea, in addition, I think we need to fix it use
two steps as follows:
- Online fix, start a delayed work to check inode/extent alloc if
  exceeding a certain percentage, then return spaces to global_bitmap.
- Offline fix, to some extreme scenario, inode/extent alloc occupy
  enough spaces but none of gd can be freed, metadata should be
  moved in this case.

Thanks,
Yiwen.
