From: Tristan <tristan.ye@oracle.com>
Date: Tue, 01 Dec 2009 09:25:14 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Implement new OCFS2_IOC_INFO
 ioctl for ocfs2.
In-Reply-To: <4B145A07.3070107@oracle.com>
References: <1259310276-7782-1-git-send-email-tristan.ye@oracle.com>
	<1259310276-7782-2-git-send-email-tristan.ye@oracle.com>
	<4B145A07.3070107@oracle.com>
Message-ID: <4B14707A.3030302@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil Mushran wrote:
> Tristan Ye wrote:
>> We implement the request as simple as possible to avoid
>> a possible extending if disk format get changed.
>>
>> Completenss of a request include the info required and a flag(FL_FILLED)
>> filled being returned to the end-user.
>>
>> Note: the requests in a series from userspace should be NULL-terminated.
>
> Pass in the buffer length. Expecting null-termination is asking for 
> trouble.

I agree, may discuss with joel later, a null-terminated flavor may 
become a security leak...

Actually, maybe we could take single request into account, which mean 
end-user deliver one request for one info each time.

For users, just a matter of call ioctl() mutiple times. For kernel, 
means simpler to handle...

>
>>
>> Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
>> ---
>> fs/ocfs2/ioctl.c | 184 
>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>> 1 files changed, 184 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
>> index 31fbb06..0ac5218 100644
>> --- a/fs/ocfs2/ioctl.c
>> +++ b/fs/ocfs2/ioctl.c
>> @@ -108,6 +108,188 @@ bail:
>> return status;
>> }
>>
>> +static int ocfs2_get_request_info(struct inode *inode,
>> + unsigned long arg)
>> +{
>> +
>> + int ret = 0, i = 0, num_reqs = 0;
>> +
>> + struct ocfs2_info_request req, *preq = NULL;
>> + struct ocfs2_info_request **reqs;
>> + struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>> +
>> + typedef struct ocfs2_info_request OIR, *POIR;
>> + typedef struct ocfs2_info_request_clustersize OIRC, *POIRC;
>> + typedef struct ocfs2_info_request_blocksize OIRB, *POIRB;
>> + typedef struct ocfs2_info_request_slotnum OIRS, *POIRS;
>> + typedef struct ocfs2_info_request_label OIRL, *POIRL;
>> + typedef struct ocfs2_info_request_uuid OIRU, *POIRU;
>> + typedef struct ocfs2_info_request_fs_features OIRF, *POIRF;
>> +
>
> Three no-nos.
> 1. Do not typedef structures.
> 2. Use all-caps only for #defines.
> 3. Do not pre-pend type to the variable name.
>
> For more refer to the kernel coding style.
> http://lxr.linux.no/source/Documentation/CodingStyle
Thank you for pointing this out.
>
>> + /*
>> + * The requests series from userspace need to be NULL-terminated.
>> + */
>> + do {
>> + preq = *((POIR *)((char *)arg + i * sizeof(POIR)));
>> + if (!preq)
>> + break;
>> + i++;
>> +
>> + } while (preq);
>> +
>> + num_reqs = i;
>
> If we pass in the length of the buffer, then num_reqs = len / 
> sizeof(struct ...);
>
>> +
>> + reqs = kmalloc(sizeof(POIR) * num_reqs, GFP_KERNEL);
>> + if (!reqs) {
>> + ret = -ENOMEM;
>> + goto bail;
>> + }
>
> We can then copy_from_user the buffer in one go. The remaining
> code have to change accordingly.

I also noticed that, we actually don't need the pointer array at all.

>
>> +
>> + ret = ocfs2_inode_lock(inode, NULL, 0);
>> + if (ret < 0) {
>> + mlog_errno(ret);
>> + goto bail;
>> + }
>
> The superblock lock is special. See ocfs2_super_lock().
>
> You'll need to traverse to the osb to use super_lock.
> struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>
> Also, make use of OCFS2_INFO_FL_NON_COHERENT.

Yes, that's my fault.

>
>> +
>> + for (i = 0; i < num_reqs; i++) {
>> +
>> + reqs[i] = NULL;
>> +
>> + preq = *((POIR *)((char *)arg + i * sizeof(POIR)));
>> +
>> + if (copy_from_user(&req, preq, sizeof(req))) {
>> + ret = -EFAULT;
>> + goto bail;
>> + }
>> +
>> + switch (req.ir_code) {
>> + case OCFS2_INFO_CLUSTERSIZE:
>> + reqs[i] = kmalloc(sizeof(OIRC), GFP_KERNEL);
>> +
>> + if (copy_from_user(reqs[i], preq, sizeof(OIRC))) {
>> + ret = -EFAULT;
>> + goto bail;
>> + }
>> +
>> + ((POIRC)(reqs[i]))->ir_clustersize = osb->s_clustersize;
>> + reqs[i]->ir_flags |= OCFS2_INFO_FL_FILLED;
>> +
>> + if (copy_to_user(preq, reqs[i], sizeof(OIRC))) {
>> + ret = EFAULT;
>
> -EFAULT.
>
>> + goto bail;
>> + }
>> +
>> + break;
>> + case OCFS2_INFO_BLOCKSIZE:
>> + reqs[i] = kmalloc(sizeof(OIRB), GFP_KERNEL);
>> +
>> + if (copy_from_user(reqs[i], preq, sizeof(OIRB))) {
>> + ret = -EFAULT;
>> + goto bail;
>> + }
>> +
>> + ((POIRB)(reqs[i]))->ir_blocksize =
>> + inode->i_sb->s_blocksize;
>> + reqs[i]->ir_flags |= OCFS2_INFO_FL_FILLED;
>> +
>> + if (copy_to_user(preq, reqs[i], sizeof(OIRB))) {
>> + ret = -EFAULT;
>> + goto bail;
>> + }
>> +
>> + break;
>> + case OCFS2_INFO_SLOTNUM:
>> + reqs[i] = kmalloc(sizeof(OIRS), GFP_KERNEL);
>> +
>> + if (copy_from_user(reqs[i], preq, sizeof(OIRS))) {
>> + ret = -EFAULT;
>> + goto bail;
>> + }
>> +
>> + ((POIRS)(reqs[i]))->ir_slotnum = osb->max_slots;
>> + reqs[i]->ir_flags |= OCFS2_INFO_FL_FILLED;
>> +
>> + if (copy_to_user(preq, reqs[i], sizeof(OIRS))) {
>> + ret = -EFAULT;
>> + goto bail;
>> + }
>> +
>> + break;
>> + case OCFS2_INFO_LABEL:
>> + reqs[i] = kmalloc(sizeof(OIRL), GFP_KERNEL);
>> +
>> + if (copy_from_user(reqs[i], preq, sizeof(OIRL))) {
>> + ret = -EFAULT;
>> + goto bail;
>> + }
>> +
>> + memmove(((POIRL)(reqs[i]))->ir_label, osb->vol_label,
>> + OCFS2_MAX_VOL_LABEL_LEN);
>
> Why memmove() when memcpy() will do?
I always have a thought that memmove handled thing more gracefully than 
memcpy when overlap happens.

>
>> + reqs[i]->ir_flags |= OCFS2_INFO_FL_FILLED;
>> +
>> + if (copy_to_user(preq, reqs[i], sizeof(OIRL))) {
>> + ret = -EFAULT;
>> + goto bail;
>> + }
>> +
>> + break;
>> + case OCFS2_INFO_UUID:
>> + reqs[i] = kmalloc(sizeof(OIRU), GFP_KERNEL);
>> +
>> + if (copy_from_user(reqs[i], preq, sizeof(OIRU))) {
>> + ret = -EFAULT;
>> + goto bail;
>> + }
>> +
>> + memmove(((POIRU)(reqs[i]))->ir_uuid, osb->uuid,
>> + OCFS2_VOL_UUID_LEN);
>> + reqs[i]->ir_flags |= OCFS2_INFO_FL_FILLED;
>> +
>> + if (copy_to_user(preq, reqs[i], sizeof(OIRU))) {
>> + ret = -EFAULT;
>> + goto bail;
>> + }
>> +
>> + break;
>> + case OCFS2_INFO_FS_FEATURES:
>> + reqs[i] = kmalloc(sizeof(OIRF), GFP_KERNEL);
>> +
>> + if (copy_from_user(reqs[i], preq, sizeof(OIRF))) {
>> + ret = -EFAULT;
>> + goto bail;
>> + }
>> +
>> + ((POIRF)(reqs[i]))->ir_compat_features =
>> + osb->s_feature_compat;
>> + ((POIRF)(reqs[i]))->ir_incompat_features =
>> + osb->s_feature_incompat;
>> + ((POIRF)(reqs[i]))->ir_ro_compat_features =
>> + osb->s_feature_ro_compat;
>> + reqs[i]->ir_flags |= OCFS2_INFO_FL_FILLED;
>> +
>> + if (copy_to_user(preq, reqs[i], sizeof(OIRF))) {
>> + ret = -EFAULT;
>> + goto bail;
>> + }
>> +
>> + break;
>> + default:
>> + break;
>> + }
>> +
>> + }
>> +bail:
>> + for (i = 0; i < num_reqs; i++)
>> + kfree(reqs[i]);
>> +
>> + kfree(reqs);
>> +
>> + ocfs2_inode_unlock(inode, 0);
>> +
>> + mlog_exit(ret);
>> + return ret;
>> +}
>> +
>> long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>> {
>> struct inode *inode = filp->f_path.dentry->d_inode;
>> @@ -173,6 +355,8 @@ long ocfs2_ioctl(struct file *filp, unsigned int 
>> cmd, unsigned long arg)
>> preserve = (args.preserve != 0);
>>
>> return ocfs2_reflink_ioctl(inode, old_path, new_path, preserve);
>> + case OCFS2_IOC_INFO:
>> + return ocfs2_get_request_info(inode, arg);
>> default:
>> return -ENOTTY;
>> }
>
