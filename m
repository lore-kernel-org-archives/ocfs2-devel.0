From: Goldwyn Rodrigues <rgoldwyn@suse.com>
Date: Tue, 31 May 2016 07:40:31 -0500
Subject: [Ocfs2-devel] [PATCH 1/5] ocfs2: Provisions for sysfs entries
In-Reply-To: <574C61E7020000F9000391D6@suse.com>
References: <1464232219-12553-1-git-send-email-rgoldwyn@suse.de>
	<1464232219-12553-2-git-send-email-rgoldwyn@suse.de>
	<574C61E7020000F9000391D6@suse.com>
Message-ID: <574D863F.2000509@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 05/30/2016 02:53 AM, Gang He wrote:
> Hello Goldwyn,
>
> Thanks for your code, my comments are inline.
>
>
>>>>
>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>
>> This adds /sys/fs/ocfs2/<s_id> to the sys filesystem. This
> Gang: My suggestion is to create a sysfs directory device_name under /sys/fs/ocfs2 per each file system,
> The file system generic attributes should be located under this top sub directory /sys/fs/ocfs2/<s_id>,
> but we should create a separate sub directory (e.g. filecheck) under this top sub directory for file check feature,
> then, all the file check related attributes should be located under that directory /sys/fs/ocfs2/<s_id>/filecheck.
> You know, in the future, we maybe add more attributes/sub directories under  /sys/fs/ocfs2/<s_id>,
> I should make sure the file check feature is not mixed with other things, it is easy to read/debug for the users/developers.
>

I don't think keeping it separate is important. We would need a separate 
kset for incorporating all of this. Besides, mulitple redirections will 
mess it up more than keep it simple. However, we should document what 
each portion is used for.

I don't see a point in using multiple structures when they would not be 
references at multiple points, at least in this case.


>> is done by adding the kobj into the ocfs2_super. All other
>> files are added in this directory.
>>
>> Introduce ocfs2_sb_attr which encompasses the store() and show() functions.
>> Move all the important data structures with respect to filechecks
>> to ocfs2_super.
>>
>> More superblock information should move in here.
>>
>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>> ---
>>   fs/ocfs2/Makefile |  3 +-
>>   fs/ocfs2/ocfs2.h  |  4 +++
>>   fs/ocfs2/super.c  |  7 +++--
>>   fs/ocfs2/sysfs.c  | 92
>> +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   fs/ocfs2/sysfs.h  |  9 ++++++
>>   5 files changed, 111 insertions(+), 4 deletions(-)
>>   create mode 100644 fs/ocfs2/sysfs.c
>>   create mode 100644 fs/ocfs2/sysfs.h
>>
>> diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
>> index e27e652..716ed45 100644
>> --- a/fs/ocfs2/Makefile
>> +++ b/fs/ocfs2/Makefile
>> @@ -41,7 +41,8 @@ ocfs2-objs := \
>>   	quota_local.o		\
>>   	quota_global.o		\
>>   	xattr.o			\
>> -	acl.o	\
>> +	acl.o			\
>> +	sysfs.o			\
>>   	filecheck.o
>>
>>   ocfs2_stackglue-objs := stackglue.o
>> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
>> index e63af7d..8e66cdf 100644
>> --- a/fs/ocfs2/ocfs2.h
>> +++ b/fs/ocfs2/ocfs2.h
>> @@ -37,6 +37,7 @@
>>   #include <linux/mutex.h>
>>   #include <linux/lockdep.h>
>>   #include <linux/jbd2.h>
>> +#include <linux/kobject.h>
>>
>>   /* For union ocfs2_dlm_lksb */
>>   #include "stackglue.h"
>> @@ -472,6 +473,9 @@ struct ocfs2_super
>>   	 * workqueue and schedule on our own.
>>   	 */
>>   	struct workqueue_struct *ocfs2_wq;
>> +
>> +	struct kobject kobj;
>> +	struct completion kobj_unregister;
>>   };
>>
>>   #define OCFS2_SB(sb)	    ((struct ocfs2_super *)(sb)->s_fs_info)
>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>> index d7cae33..96b7a9f 100644
>> --- a/fs/ocfs2/super.c
>> +++ b/fs/ocfs2/super.c
>> @@ -75,6 +75,7 @@
>>
>>   #include "buffer_head_io.h"
>>   #include "filecheck.h"
>> +#include "sysfs.h"
>>
>>   static struct kmem_cache *ocfs2_inode_cachep;
>>   struct kmem_cache *ocfs2_dquot_cachep;
>> @@ -1200,8 +1201,8 @@ static int ocfs2_fill_super(struct super_block *sb,
>> void *data, int silent)
>>   	/* Start this when the mount is almost sure of being successful */
>>   	ocfs2_orphan_scan_start(osb);
>>
>> -	/* Create filecheck sysfile /sys/fs/ocfs2/<devname>/filecheck */
>> -	ocfs2_filecheck_create_sysfs(sb);
>> +	/* Create sysfs entries */
>> +	ocfs2_sysfs_sb_init(sb);
>>
>>   	return status;
>>
>> @@ -1651,9 +1652,9 @@ static void ocfs2_put_super(struct super_block *sb)
>>   {
>>   	trace_ocfs2_put_super(sb);
>>
>> +	ocfs2_sysfs_sb_exit(sb);
>>   	ocfs2_sync_blockdev(sb);
>>   	ocfs2_dismount_volume(sb, 0);
>> -	ocfs2_filecheck_remove_sysfs(sb);
>>   }
>>
>>   static int ocfs2_statfs(struct dentry *dentry, struct kstatfs *buf)
>> diff --git a/fs/ocfs2/sysfs.c b/fs/ocfs2/sysfs.c
>> new file mode 100644
>> index 0000000..e21e699
>> --- /dev/null
>> +++ b/fs/ocfs2/sysfs.c
> Gang: please add source file comments like other source files.
>
>> @@ -0,0 +1,92 @@
>> +#include "ocfs2.h"
>> +#include "sysfs.h"
>> +
>> +struct ocfs2_sb_attr {
>> +	struct attribute attr;
>> +	ssize_t (*show)(struct ocfs2_super *, struct ocfs2_sb_attr *,
>> +			char *buf);
>> +	ssize_t (*store)(struct ocfs2_super *, struct ocfs2_sb_attr *,
>> +			const char *buf, size_t count);
>> +};
>> +
>> +#define OCFS2_SB_ATTR(_name, _mode) \
>> +struct ocfs2_sb_attr sb_attr_##_name = __ATTR(name, _mode, _show, _store)
>> +
>> +#define OCFS2_SB_ATTR_RO(_name) \
>> +struct ocfs2_sb_attr sb_attr_##_name = __ATTR_RO(_name)
>> +
>> +static ssize_t ocfs2_sb_attr_show(struct kobject *kobj,
>> +		struct attribute *attr, char *buf)
>> +{
>> +	struct ocfs2_sb_attr *oa =
>> +		container_of(attr, struct ocfs2_sb_attr, attr);
>> +	struct ocfs2_super *osb = container_of(kobj, struct ocfs2_super, kobj);
>> +	if (!oa->show)
>> +		return -EIO;
>> +
>> +	return oa->show(osb, oa, buf);
>> +}
>> +
>> +static ssize_t ocfs2_sb_attr_store(struct kobject *kobj,
>> +		struct attribute *attr, const char *buf, size_t count)
>> +{
>> +	struct ocfs2_sb_attr *oa =
>> +		container_of(attr, struct ocfs2_sb_attr, attr);
>> +	struct ocfs2_super *osb = container_of(kobj, struct ocfs2_super, kobj);
>> +	if (!oa->store)
>> +		return -EIO;
>> +
>> +	return oa->store(osb, oa, buf, count);
>> +}
>> +
>> +static ssize_t slot_num_show(struct ocfs2_super *osb,
>> +			     struct ocfs2_sb_attr *attr,
>> +	  		     char *buf)
>> +{
>> +	return sprintf(buf, "%d\n", osb->slot_num);
>> +}
>> +
>> +static void sb_release(struct kobject *kobj)
>> +{
>> +	struct ocfs2_super *osb = container_of(kobj, struct ocfs2_super, kobj);
>> +	complete(&osb->kobj_unregister);
>> +}
>> +
>> +static const struct sysfs_ops ocfs2_sb_sysfs_ops = {
>> +	.show = ocfs2_sb_attr_show,
>> +	.store = ocfs2_sb_attr_store,
>> +};
>> +
>> +static OCFS2_SB_ATTR_RO(slot_num);
>> +static struct attribute *ocfs2_sb_attrs[] = {
>> +	&sb_attr_slot_num.attr,
>> +	NULL
>> +};
>> +
>> +static struct kobj_type ocfs2_sb_ktype = {
>> +	.sysfs_ops 	= &ocfs2_sb_sysfs_ops,
>> +	.default_attrs 	= ocfs2_sb_attrs,
>> +	.release	= sb_release,
>> +};
>> +
>> +
>> +int ocfs2_sysfs_sb_init(struct super_block *sb)
>> +{
>> +	int err;
>> +	struct ocfs2_super *osb = OCFS2_SB(sb);
>> +	init_completion(&osb->kobj_unregister);
>> +	osb->kobj.kset = ocfs2_kset;
>> +	err = kobject_init_and_add(&osb->kobj, &ocfs2_sb_ktype, NULL, "%s", sb->s_id);
>> +	return err;
>> +
>> +}
>> +
>> +void ocfs2_sysfs_sb_exit(struct super_block *sb)
>> +{
>> +	struct ocfs2_super *osb = OCFS2_SB(sb);
>> +	kobject_del(&osb->kobj);
>> +	kobject_put(&osb->kobj);
>> +	wait_for_completion(&osb->kobj_unregister);
>> +}
>> +
>> +
>> diff --git a/fs/ocfs2/sysfs.h b/fs/ocfs2/sysfs.h
>> new file mode 100644
>> index 0000000..d929ac1
>> --- /dev/null
>> +++ b/fs/ocfs2/sysfs.h
> Gang: please add header file comments like other header files.
>

Agree.

>> @@ -0,0 +1,9 @@
>> +
>> +
>> +#ifndef _SYS_H
>> +#define _SYS_H
>> +
>> +int ocfs2_sysfs_sb_init(struct super_block *sb);
>> +void ocfs2_sysfs_sb_exit(struct super_block *sb);
>> +
>> +#endif
>> --
>> 2.6.6
>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 
Goldwyn
