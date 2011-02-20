From: Tristan Ye <tristan.ye@oracle.com>
Date: Sun, 20 Feb 2011 20:59:51 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] Ocfs2: Add a new code
 'OCFS2_INFO_FREEINODE' for o2info ioctl.
In-Reply-To: <20110220120707.GG17784@noexit>
References: <1296368761-23043-1-git-send-email-tristan.ye@oracle.com>
	<1296368761-23043-3-git-send-email-tristan.ye@oracle.com>
	<20110220120707.GG17784@noexit>
Message-ID: <4D611047.9010607@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Sun, Jan 30, 2011 at 02:26:00PM +0800, Tristan Ye wrote:
>> The new code is dedicated to calculate free inodes number of all inode_allocs,
>> then return the info to userpace in terms of an array.
>>
>> Specially, flag 'OCFS2_INFO_FL_NON_COHERENT', manipulated by '--cluster-coherent'
>> from userspace, is now going to be involved. setting the flag on means no cluster
>> coherency considered, usually, userspace tools choose none-coherency strategy by
>> default for the sake of performace.
>>
>> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
>> ---
>>  fs/ocfs2/ioctl.c       |  122 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/ocfs2/ocfs2_ioctl.h |   11 ++++
>>  2 files changed, 133 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
>> index 731cf46..18812be 100644
>> --- a/fs/ocfs2/ioctl.c
>> +++ b/fs/ocfs2/ioctl.c
>> @@ -23,6 +23,9 @@
>>  #include "ioctl.h"
>>  #include "resize.h"
>>  #include "refcounttree.h"
>> +#include "sysfile.h"
>> +#include "dir.h"
>> +#include "buffer_head_io.h"
>>  
>>  #include <linux/ext2_fs.h>
>>  
>> @@ -62,6 +65,13 @@ static inline void __o2info_clear_request_filled(struct ocfs2_info_request *req)
>>  #define o2info_clear_request_filled(a) \
>>  		__o2info_clear_request_filled((struct ocfs2_info_request *)&(a))
>>  
>> +static inline int __o2info_coherent(struct ocfs2_info_request *req)
>> +{
>> +	return (!(req->ir_flags & OCFS2_INFO_FL_NON_COHERENT));
>> +}
>> +
>> +#define o2info_coherent(a) __o2info_coherent((struct ocfs2_info_request *)&(a))
>> +
>>  static int ocfs2_get_inode_attr(struct inode *inode, unsigned *flags)
>>  {
>>  	int status;
>> @@ -321,6 +331,114 @@ bail:
>>  	return status;
>>  }
>>  
>> +int ocfs2_info_scan_inode_alloc(struct ocfs2_super *osb,
>> +				struct inode *inode_alloc, u64 blkno,
>> +				struct ocfs2_info_freeinode *fi, u32 slot)
>> +{
>> +	int status = 0, unlock = 0;
>> +
>> +	struct buffer_head *bh = NULL;
>> +	struct ocfs2_dinode *dinode_alloc = NULL;
>> +
>> +	if (inode_alloc)
>> +		mutex_lock(&inode_alloc->i_mutex);
>> +
>> +	if (o2info_coherent(*fi)) {
>> +		status = ocfs2_inode_lock(inode_alloc, &bh, 0);
>> +		if (status < 0) {
>> +			mlog_errno(status);
>> +			goto bail;
>> +		}
>> +		unlock = 1;
>> +	} else {
>> +		status = ocfs2_read_blocks_sync(osb, blkno, 1, &bh);
>> +		if (status < 0) {
>> +			mlog_errno(status);
>> +			goto bail;
>> +		}
>> +	}
>> +
>> +	dinode_alloc = (struct ocfs2_dinode *)bh->b_data;
>> +
>> +	fi->ifi_stat[slot].lfi_total =
>> +		le32_to_cpu(dinode_alloc->id1.bitmap1.i_total);
>> +	fi->ifi_stat[slot].lfi_free =
>> +		le32_to_cpu(dinode_alloc->id1.bitmap1.i_total) -
>> +		le32_to_cpu(dinode_alloc->id1.bitmap1.i_used);
>> +
>> +bail:
>> +	if (unlock)
>> +		ocfs2_inode_unlock(inode_alloc, 0);
>> +
>> +	if (inode_alloc)
>> +		mutex_unlock(&inode_alloc->i_mutex);
>> +
>> +	if (inode_alloc)
>> +		iput(inode_alloc);
>> +
>> +	brelse(bh);
>> +
>> +	mlog_exit(status);
>> +	return status;
>> +}
>> +
>> +int ocfs2_info_handle_freeinode(struct inode *inode,
>> +				struct ocfs2_info_request __user *req)
>> +{
>> +	u32 i;
>> +	u64 blkno = -1;
>> +	char namebuf[40];
>> +	int status = -EFAULT, type = INODE_ALLOC_SYSTEM_INODE;
>> +	struct ocfs2_info_freeinode oifi;
>
> /build/jlbec/linux-2.6/working/fs/ocfs2/ioctl.c: In function ?ocfs2_info_handle_freeinode?:
> /build/jlbec/linux-2.6/working/fs/ocfs2/ioctl.c:441: warning: the frame size of 4192 bytes is larger than 2048 bytes
>
> 	This is speaking to the fact that you've put struct
> ocfs2_info_freeinode oifi on the stack.  It's over 4K in size.  It needs
> to be allocated.

    Joel, great catch, how did you builder get warning like that, needs 
to change makefile a bit?

And we're not allowed to put structure more than 2k, on stack for each 
function in kernel?


> 	Please respin this and the FREEFRAG patch based on it.
>
> Joel
>
