From: Gang He <ghe@suse.com>
Date: Fri, 03 Jul 2015 02:04:08 -0600
Subject: [Ocfs2-devel] [PATCH 0/4] ocfs2: add online file check feature
In-Reply-To: <559639AC.80602@huawei.com>
References: <1435123461-3525-1-git-send-email-ghe@suse.com>
	<559639AC.80602@huawei.com>
Message-ID: <5596B278020000F90000DB5B@relay2.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: joseph.qi@huawei.com
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <MFasheh@suse.com>, rgoldwyn@suse.de, linux-kernel@vger.kernel.org

Hi Joseph,

Thank for your reviewing.
Online file check feature will try to check/fix some independent block corruption problems.
Since these operations are under online file system, the features are limited, otherwise, we have
to use FSCK tools after file system is unmounted (e.g. some inconsistent meta-data problem).
This online file check will be implemented by some stages.
First, we give a online file check framework and inode block check.
Second, we will add other kinds of block check/fix, e.g.
Add checks/fixes for directory blocks.
Add checks/fixes for extent_block errors/corruption
Add checks/fixes directory indexing. fsck currently abandons the tree and rebuilds a new index, we can do the same.
Add checks/fixes for xattr blocks
Add checks/fixes for refcount blocks
Finally, add system file checks (journal, local_alloc etc).
Anyway, this feature only can address some independent problems, since we cannot block other file access when file check is running.
For more serious problem, have to stop file system and run FSCK to chech/fix step by step.

Thanks
Gang


>>> 
> Hi Gang,
> Thank you and Goldwyn for posting this feature as well as its framework.
> This patch set tries to fix inode related errors such as block no, valid
> flag, generation, metaecc, etc. I think it may fit some cases but not all.
> For example, valid flag not set readonly may be caused by an inode with
> two entries, so I think it is not right to just reset it.
> Moreover, in our environment, most readonly cases we have encountered are
> related gd and entent tree/block. So do you have any consideration about
> these cases?
> For more details about gd and entent tree/block readonly cases, please
> refer the previous mails:
> https://oss.oracle.com/pipermail/ocfs2-devel/2015-April/010768.html 
> https://oss.oracle.com/pipermail/ocfs2-devel/2015-June/010873.html 
> 
> Thanks,
> Joseph
> 
> On 2015/6/24 13:24, Gang He wrote:
>> When there are errors in the ocfs2 filesystem,
>> they are usually accompanied by the inode number which caused the error.
>> This inode number would be the input to fixing the file.
>> One of these options could be considered:
>> A file in the sys filesytem which would accept inode numbers.
>> This could be used to communication back what has to be fixed or is fixed.
>> You could write:
>> $# echo "CHECK <inode>" > /sys/fs/ocfs2/devname/filecheck
>> or
>> $# echo "FIX <inode>" > /sys/fs/ocfs2/devname/filecheck
>> 
>> Gang He (4):
>>   ocfs2: export ocfs2_kset for online file check
>>   ocfs2: sysfile interfaces for online file check
>>   ocfs2: create/remove sysfile for online file check
>>   ocfs2: check/fix inode block for online file check
>> 
>>  fs/ocfs2/Makefile      |   3 +-
>>  fs/ocfs2/filecheck.c   | 569 
> +++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/ocfs2/filecheck.h   |  48 +++++
>>  fs/ocfs2/inode.c       | 196 ++++++++++++++++-
>>  fs/ocfs2/inode.h       |   3 +
>>  fs/ocfs2/ocfs2_trace.h |   2 +
>>  fs/ocfs2/stackglue.c   |   3 +-
>>  fs/ocfs2/stackglue.h   |   2 +
>>  fs/ocfs2/super.c       |   5 +
>>  9 files changed, 823 insertions(+), 8 deletions(-)
>>  create mode 100644 fs/ocfs2/filecheck.c
>>  create mode 100644 fs/ocfs2/filecheck.h
>> 
