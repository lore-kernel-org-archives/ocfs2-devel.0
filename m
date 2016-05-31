From: Goldwyn Rodrigues <rgoldwyn@suse.com>
Date: Tue, 31 May 2016 07:40:32 -0500
Subject: [Ocfs2-devel] [PATCH 2/5] Use the sysfs interface for creating
 filecheck files
In-Reply-To: <574C7704020000F900039256@suse.com>
References: <1464232219-12553-1-git-send-email-rgoldwyn@suse.de>
	<1464232219-12553-3-git-send-email-rgoldwyn@suse.de>
	<574C7704020000F900039256@suse.com>
Message-ID: <574D8640.1040204@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 05/30/2016 04:23 AM, Gang He wrote:
> Hello Goldwyn,
>
> Please see my comments inline.
> I just suggest to re-use the existing code as most as possible, since the code was tested by us.
>
> Thanks
> Gang
>
>
>>>>
>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>
>> This reduces the code base and removes unnecessary data structures
>> for filecheck information since all information is stored in ocfs2_super
>> now.
>>
>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>> ---
>>   fs/ocfs2/filecheck.c | 440 ++++++---------------------------------------------
>>   fs/ocfs2/filecheck.h |  10 ++
>>   fs/ocfs2/ocfs2.h     |   7 +
>>   fs/ocfs2/super.c     |   7 +
>>   fs/ocfs2/sysfs.c     |  91 ++++++++++-
>>   5 files changed, 161 insertions(+), 394 deletions(-)
>>
>> diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
>> index 2cabbcf..0b41967 100644
>> --- a/fs/ocfs2/filecheck.c
>> +++ b/fs/ocfs2/filecheck.c
>> @@ -17,15 +17,7 @@
>>    * General Public License for more details.
>>    */
>>
>> -#include <linux/list.h>
>> -#include <linux/spinlock.h>
>> -#include <linux/module.h>
>> -#include <linux/slab.h>
>> -#include <linux/kmod.h>
>>   #include <linux/fs.h>
>> -#include <linux/kobject.h>
>> -#include <linux/sysfs.h>
>> -#include <linux/sysctl.h>
>>   #include <cluster/masklog.h>
>>
>>   #include "ocfs2.h"
>> @@ -53,36 +45,6 @@ static const char * const ocfs2_filecheck_errs[] = {
>>   	"UNSUPPORTED"
>>   };
>>
>> -static DEFINE_SPINLOCK(ocfs2_filecheck_sysfs_lock);
>> -static LIST_HEAD(ocfs2_filecheck_sysfs_list);
>> -
>
>> -struct ocfs2_filecheck {
>> -	struct list_head fc_head;	/* File check entry list head */
>> -	spinlock_t fc_lock;
>> -	unsigned int fc_max;	/* Maximum number of entry in list */
>> -	unsigned int fc_size;	/* Current entry count in list */
>> -	unsigned int fc_done;	/* Finished entry count in list */
>> -};
> Gang: we can reuse this structure, please move this structure into struct ocfs2_super, instead of defining a few members in struct ocfs2_super.
> We should use a separate structure to handle all the file check related thing, make the code simple and easy to maintain.


Not sure why you are insistent on keeping a separate structure when it 
would not be references from different structures. Keeping a prefix of 
fc will make sure it is for filecheck attributes.

>
>
>> -
>> -struct ocfs2_filecheck_sysfs_entry {	/* sysfs entry per mounting */
>> -	struct list_head fs_list;
>> -	atomic_t fs_count;
>> -	struct super_block *fs_sb;
>> -	struct kset *fs_devicekset;
>> -	struct kset *fs_fcheckkset;
>> -	struct ocfs2_filecheck *fs_fcheck;
>> -};
> Gang: I think that we can not delete this structure directly, some members are still useful.
> e.g. fs_count, which is used to track if there are any pending file check entries, can be moved into struct ocfs2_filecheck.
> kset members maybe be kept in struct ocfs2_filecheck.

Okay, I will fix that.

>
>> -
>> -#define OCFS2_FILECHECK_MAXSIZE		100
>> -#define OCFS2_FILECHECK_MINSIZE		10
> Gang: any file will reference these two macro?
> if not, that means these are not interfaces, should be kept in source file.

Yes, they are referenced by multiple files.

>
>> -
>> -/* File check operation type */
>> -enum {
>> -	OCFS2_FILECHECK_TYPE_CHK = 0,	/* Check a file(inode) */
>> -	OCFS2_FILECHECK_TYPE_FIX,	/* Fix a file(inode) */
>> -	OCFS2_FILECHECK_TYPE_SET = 100	/* Set entry list maximum size */
>> -};
> Gang: delete the member OCFS2_FILECHECK_TYPE_SET,
> Move this enum to the header file if any other source file will use, otherwise should be kept in source file.

The idea of removing this structures was to simplify the code. More 
structures make more complicated code.

>
>> -
>>   struct ocfs2_filecheck_entry {
>>   	struct list_head fe_list;
>>   	unsigned long fe_ino;
>> @@ -91,14 +53,6 @@ struct ocfs2_filecheck_entry {
>>   	unsigned int fe_status:31;
>>   };
>>
>> -struct ocfs2_filecheck_args {
>> -	unsigned int fa_type;
>> -	union {
>> -		unsigned long fa_ino;
>> -		unsigned int fa_len;
>> -	};
>> -};
>> -
>>   static const char *
>>   ocfs2_filecheck_error(int errno)
>>   {
>> @@ -110,321 +64,51 @@ ocfs2_filecheck_error(int errno)
>>   	return ocfs2_filecheck_errs[errno - OCFS2_FILECHECK_ERR_START + 1];
>>   }
>>
>> -static ssize_t ocfs2_filecheck_show(struct kobject *kobj,
>> -				    struct kobj_attribute *attr,
>> -				    char *buf);
>> -static ssize_t ocfs2_filecheck_store(struct kobject *kobj,
>> -				     struct kobj_attribute *attr,
>> -				     const char *buf, size_t count);
>> -static struct kobj_attribute ocfs2_attr_filecheck_chk =
>> -					__ATTR(check, S_IRUSR | S_IWUSR,
>> -					ocfs2_filecheck_show,
>> -					ocfs2_filecheck_store);
>> -static struct kobj_attribute ocfs2_attr_filecheck_fix =
>> -					__ATTR(fix, S_IRUSR | S_IWUSR,
>> -					ocfs2_filecheck_show,
>> -					ocfs2_filecheck_store);
>> -static struct kobj_attribute ocfs2_attr_filecheck_set =
>> -					__ATTR(set, S_IRUSR | S_IWUSR,
>> -					ocfs2_filecheck_show,
>> -					ocfs2_filecheck_store);
>> -
>> -static int ocfs2_filecheck_sysfs_wait(atomic_t *p)
>> -{
>> -	schedule();
>> -	return 0;
>> -}
>> -
>> -static void
>> -ocfs2_filecheck_sysfs_free(struct ocfs2_filecheck_sysfs_entry *entry)
>> -{
>> -	struct ocfs2_filecheck_entry *p;
>> -
>> -	if (!atomic_dec_and_test(&entry->fs_count))
>> -		wait_on_atomic_t(&entry->fs_count, ocfs2_filecheck_sysfs_wait,
>> -				 TASK_UNINTERRUPTIBLE);
>> -
>> -	spin_lock(&entry->fs_fcheck->fc_lock);
>> -	while (!list_empty(&entry->fs_fcheck->fc_head)) {
>> -		p = list_first_entry(&entry->fs_fcheck->fc_head,
>> -				     struct ocfs2_filecheck_entry, fe_list);
>> -		list_del(&p->fe_list);
>> -		BUG_ON(!p->fe_done); /* To free a undone file check entry */
>> -		kfree(p);
>> -	}
>> -	spin_unlock(&entry->fs_fcheck->fc_lock);
>> -
>> -	kset_unregister(entry->fs_fcheckkset);
>> -	kset_unregister(entry->fs_devicekset);
>> -	kfree(entry->fs_fcheck);
>> -	kfree(entry);
>> -}
> Gang: we cannot delete the function ocfs2_filecheck_sysfs_free() directly, this will be used to free the file check entries.
> Please keep the code, otherwise, it will lead to memory leak.

Yes, there should a cleanup routine.

>
>> -
>> -static void
>> -ocfs2_filecheck_sysfs_add(struct ocfs2_filecheck_sysfs_entry *entry)
>> -{
>> -	spin_lock(&ocfs2_filecheck_sysfs_lock);
>> -	list_add_tail(&entry->fs_list, &ocfs2_filecheck_sysfs_list);
>> -	spin_unlock(&ocfs2_filecheck_sysfs_lock);
>> -}
>> -
>> -static int ocfs2_filecheck_sysfs_del(const char *devname)
>> -{
>> -	struct ocfs2_filecheck_sysfs_entry *p;
>> -
>> -	spin_lock(&ocfs2_filecheck_sysfs_lock);
>> -	list_for_each_entry(p, &ocfs2_filecheck_sysfs_list, fs_list) {
>> -		if (!strcmp(p->fs_sb->s_id, devname)) {
>> -			list_del(&p->fs_list);
>> -			spin_unlock(&ocfs2_filecheck_sysfs_lock);
>> -			ocfs2_filecheck_sysfs_free(p);
>> -			return 0;
>> -		}
>> -	}
>> -	spin_unlock(&ocfs2_filecheck_sysfs_lock);
>> -	return 1;
>> -}
>> -
>> -static void
>> -ocfs2_filecheck_sysfs_put(struct ocfs2_filecheck_sysfs_entry *entry)
>> -{
>> -	if (atomic_dec_and_test(&entry->fs_count))
>> -		wake_up_atomic_t(&entry->fs_count);
>> -}
>> -
>> -static struct ocfs2_filecheck_sysfs_entry *
>> -ocfs2_filecheck_sysfs_get(const char *devname)
>> -{
>> -	struct ocfs2_filecheck_sysfs_entry *p = NULL;
>> -
>> -	spin_lock(&ocfs2_filecheck_sysfs_lock);
>> -	list_for_each_entry(p, &ocfs2_filecheck_sysfs_list, fs_list) {
>> -		if (!strcmp(p->fs_sb->s_id, devname)) {
>> -			atomic_inc(&p->fs_count);
>> -			spin_unlock(&ocfs2_filecheck_sysfs_lock);
>> -			return p;
>> -		}
>> -	}
>> -	spin_unlock(&ocfs2_filecheck_sysfs_lock);
>> -	return NULL;
>> -}
> Gang: We can't delete these code directly, fs_count variable is used to track if there is any process to use file check related data.
> Please consider this variable before delete this part code.
>
>
>> -int ocfs2_filecheck_create_sysfs(struct super_block *sb)
>> -{
>> -	int ret = 0;
>> -	struct kset *device_kset = NULL;
>> -	struct kset *fcheck_kset = NULL;
>> -	struct ocfs2_filecheck *fcheck = NULL;
>> -	struct ocfs2_filecheck_sysfs_entry *entry = NULL;
>> -	struct attribute **attrs = NULL;
>> -	struct attribute_group attrgp;
>> -
>> -	if (!ocfs2_kset)
>> -		return -ENOMEM;
>> -
>> -	attrs = kmalloc(sizeof(struct attribute *) * 4, GFP_NOFS);
>> -	if (!attrs) {
>> -		ret = -ENOMEM;
>> -		goto error;
>> -	} else {
>> -		attrs[0] = &ocfs2_attr_filecheck_chk.attr;
>> -		attrs[1] = &ocfs2_attr_filecheck_fix.attr;
>> -		attrs[2] = &ocfs2_attr_filecheck_set.attr;
>> -		attrs[3] = NULL;
>> -		memset(&attrgp, 0, sizeof(attrgp));
>> -		attrgp.attrs = attrs;
>> -	}
>> -
>> -	fcheck = kmalloc(sizeof(struct ocfs2_filecheck), GFP_NOFS);
>> -	if (!fcheck) {
>> -		ret = -ENOMEM;
>> -		goto error;
>> -	} else {
>> -		INIT_LIST_HEAD(&fcheck->fc_head);
>> -		spin_lock_init(&fcheck->fc_lock);
>> -		fcheck->fc_max = OCFS2_FILECHECK_MINSIZE;
>> -		fcheck->fc_size = 0;
>> -		fcheck->fc_done = 0;
>> -	}
>> -
>> -	if (strlen(sb->s_id) <= 0) {
>> -		mlog(ML_ERROR,
>> -		"Cannot get device basename when create filecheck sysfs\n");
>> -		ret = -ENODEV;
>> -		goto error;
>> -	}
>> -
>> -	device_kset = kset_create_and_add(sb->s_id, NULL, &ocfs2_kset->kobj);
>> -	if (!device_kset) {
>> -		ret = -ENOMEM;
>> -		goto error;
>> -	}
>> -
>> -	fcheck_kset = kset_create_and_add("filecheck", NULL,
>> -					  &device_kset->kobj);
>> -	if (!fcheck_kset) {
>> -		ret = -ENOMEM;
>> -		goto error;
>> -	}
>> -
>> -	ret = sysfs_create_group(&fcheck_kset->kobj, &attrgp);
>> -	if (ret)
>> -		goto error;
>> -
>> -	entry = kmalloc(sizeof(struct ocfs2_filecheck_sysfs_entry), GFP_NOFS);
>> -	if (!entry) {
>> -		ret = -ENOMEM;
>> -		goto error;
>> -	} else {
>> -		atomic_set(&entry->fs_count, 1);
>> -		entry->fs_sb = sb;
>> -		entry->fs_devicekset = device_kset;
>> -		entry->fs_fcheckkset = fcheck_kset;
>> -		entry->fs_fcheck = fcheck;
>> -		ocfs2_filecheck_sysfs_add(entry);
>> -	}
>> -
>> -	kfree(attrs);
>> -	return 0;
>> -
>> -error:
>> -	kfree(attrs);
>> -	kfree(entry);
>> -	kfree(fcheck);
>> -	kset_unregister(fcheck_kset);
>> -	kset_unregister(device_kset);
>> -	return ret;
>> -}
>> -
>> -int ocfs2_filecheck_remove_sysfs(struct super_block *sb)
>> -{
>> -	return ocfs2_filecheck_sysfs_del(sb->s_id);
>> -}
> Gang: this part code can be re-used after a little modification.

For what?

>
>> -
>>   static int
>> -ocfs2_filecheck_erase_entries(struct ocfs2_filecheck_sysfs_entry *ent,
>> +ocfs2_filecheck_erase_entries(struct ocfs2_super *,
>>   			      unsigned int count);
>> -static int
>> -ocfs2_filecheck_adjust_max(struct ocfs2_filecheck_sysfs_entry *ent,
>> -			   unsigned int len)
>> +
>> +int ocfs2_filecheck_set_max_entries(struct ocfs2_super *osb,
>> +				int len)
>>   {
>>   	int ret;
>>
>>   	if ((len < OCFS2_FILECHECK_MINSIZE) || (len > OCFS2_FILECHECK_MAXSIZE))
>>   		return -EINVAL;
>>
>> -	spin_lock(&ent->fs_fcheck->fc_lock);
>> -	if (len < (ent->fs_fcheck->fc_size - ent->fs_fcheck->fc_done)) {
>> +	spin_lock(&osb->fc_lock);
>> +	if (len < (osb->fc_size - osb->fc_done)) {
>>   		mlog(ML_ERROR,
>>   		"Cannot set online file check maximum entry number "
>>   		"to %u due to too many pending entries(%u)\n",
>> -		len, ent->fs_fcheck->fc_size - ent->fs_fcheck->fc_done);
>> +		len, osb->fc_size - osb->fc_done);
>>   		ret = -EBUSY;
>>   	} else {
>> -		if (len < ent->fs_fcheck->fc_size)
>> -			BUG_ON(!ocfs2_filecheck_erase_entries(ent,
>> -				ent->fs_fcheck->fc_size - len));
>> +		if (len < osb->fc_size)
>> +			BUG_ON(!ocfs2_filecheck_erase_entries(osb,
>> +				osb->fc_size - len));
>>
>> -		ent->fs_fcheck->fc_max = len;
>> +		osb->fc_max = len;
>>   		ret = 0;
>>   	}
>> -	spin_unlock(&ent->fs_fcheck->fc_lock);
>> +	spin_unlock(&osb->fc_lock);
>>
>>   	return ret;
>>   }
>>
>> -#define OCFS2_FILECHECK_ARGS_LEN	24
>> -static int
>> -ocfs2_filecheck_args_get_long(const char *buf, size_t count,
>> -			      unsigned long *val)
>> -{
>> -	char buffer[OCFS2_FILECHECK_ARGS_LEN];
>> -
>> -	memcpy(buffer, buf, count);
>> -	buffer[count] = '\0';
>> -
>> -	if (kstrtoul(buffer, 0, val))
>> -		return 1;
>> -
>> -	return 0;
>> -}
>> -
>> -static int
>> -ocfs2_filecheck_type_parse(const char *name, unsigned int *type)
>> -{
>> -	if (!strncmp(name, "fix", 4))
>> -		*type = OCFS2_FILECHECK_TYPE_FIX;
>> -	else if (!strncmp(name, "check", 6))
>> -		*type = OCFS2_FILECHECK_TYPE_CHK;
>> -	else if (!strncmp(name, "set", 4))
>> -		*type = OCFS2_FILECHECK_TYPE_SET;
>> -	else
>> -		return 1;
>> -
>> -	return 0;
>> -}
>> -
>> -static int
>> -ocfs2_filecheck_args_parse(const char *name, const char *buf, size_t count,
>> -			   struct ocfs2_filecheck_args *args)
>> -{
>> -	unsigned long val = 0;
>> -	unsigned int type;
>> -
>> -	/* too short/long args length */
>> -	if ((count < 1) || (count >= OCFS2_FILECHECK_ARGS_LEN))
>> -		return 1;
>> -
>> -	if (ocfs2_filecheck_type_parse(name, &type))
>> -		return 1;
>> -	if (ocfs2_filecheck_args_get_long(buf, count, &val))
>> -		return 1;
>> -
>> -	if (val <= 0)
>> -		return 1;
>>
>> -	args->fa_type = type;
>> -	if (type == OCFS2_FILECHECK_TYPE_SET)
>> -		args->fa_len = (unsigned int)val;
>> -	else
>> -		args->fa_ino = val;
>> -
>> -	return 0;
>> -}
>> -
> Gang: please keep the ocfs2_filecheck_args_parse function, or write a similar argument checking function since the arguments are from user-space, must be check strictly.
> Otherwise, this will be a way for malicious users to panic the kernel.

How? Do you have an example?

>
>> -static ssize_t ocfs2_filecheck_show(struct kobject *kobj,
>> -				    struct kobj_attribute *attr,
>> +int ocfs2_filecheck_show(struct ocfs2_super *osb, unsigned int type,
>>   				    char *buf)
>>   {
>>
>>   	ssize_t ret = 0, total = 0, remain = PAGE_SIZE;
>> -	unsigned int type;
>>   	struct ocfs2_filecheck_entry *p;
>> -	struct ocfs2_filecheck_sysfs_entry *ent;
>> -
>> -	if (ocfs2_filecheck_type_parse(attr->attr.name, &type))
>> -		return -EINVAL;
>> -
>> -	ent = ocfs2_filecheck_sysfs_get(kobj->parent->name);
> Gang: if delete file check data reference count mechanism, how to make sure the resource race condition (e.g. list the check results during the file system umounting.)
> Please consider this race condition problem.

Isn't spinlock enough? What is the race?

>
>> -	if (!ent) {
>> -		mlog(ML_ERROR,
>> -		"Cannot get the corresponding entry via device basename %s\n",
>> -		kobj->name);
>> -		return -ENODEV;
>> -	}
>> -
>> -	if (type == OCFS2_FILECHECK_TYPE_SET) {
>> -		spin_lock(&ent->fs_fcheck->fc_lock);
>> -		total = snprintf(buf, remain, "%u\n", ent->fs_fcheck->fc_max);
>> -		spin_unlock(&ent->fs_fcheck->fc_lock);
>> -		goto exit;
>> -	}
>>
>>   	ret = snprintf(buf, remain, "INO\t\tDONE\tERROR\n");
>>   	total += ret;
>>   	remain -= ret;
>> -	spin_lock(&ent->fs_fcheck->fc_lock);
>> -	list_for_each_entry(p, &ent->fs_fcheck->fc_head, fe_list) {
>> +	spin_lock(&osb->fc_lock);
>> +	list_for_each_entry(p, &osb->file_check_entries, fe_list) {
>>   		if (p->fe_type != type)
>>   			continue;
>>
>> @@ -443,24 +127,21 @@ static ssize_t ocfs2_filecheck_show(struct kobject
>> *kobj,
>>   		total += ret;
>>   		remain -= ret;
>>   	}
>> -	spin_unlock(&ent->fs_fcheck->fc_lock);
>> -
>> -exit:
>> -	ocfs2_filecheck_sysfs_put(ent);
>> +	spin_unlock(&osb->fc_lock);
>>   	return total;
>>   }
>>
>>   static int
>> -ocfs2_filecheck_erase_entry(struct ocfs2_filecheck_sysfs_entry *ent)
>> +ocfs2_filecheck_erase_entry(struct ocfs2_super *osb)
>>   {
>>   	struct ocfs2_filecheck_entry *p;
>>
>> -	list_for_each_entry(p, &ent->fs_fcheck->fc_head, fe_list) {
>> +	list_for_each_entry(p, &osb->file_check_entries, fe_list) {
>>   		if (p->fe_done) {
>>   			list_del(&p->fe_list);
>>   			kfree(p);
>> -			ent->fs_fcheck->fc_size--;
>> -			ent->fs_fcheck->fc_done--;
>> +			osb->fc_size--;
>> +			osb->fc_done--;
>>   			return 1;
>>   		}
>>   	}
>> @@ -469,14 +150,14 @@ ocfs2_filecheck_erase_entry(struct
>> ocfs2_filecheck_sysfs_entry *ent)
>>   }
>>
>>   static int
>> -ocfs2_filecheck_erase_entries(struct ocfs2_filecheck_sysfs_entry *ent,
>> +ocfs2_filecheck_erase_entries(struct ocfs2_super *osb,
>>   			      unsigned int count)
>>   {
>>   	unsigned int i = 0;
>>   	unsigned int ret = 0;
>>
>>   	while (i++ < count) {
>> -		if (ocfs2_filecheck_erase_entry(ent))
>> +		if (ocfs2_filecheck_erase_entry(osb))
>>   			ret++;
>>   		else
>>   			break;
>> @@ -486,24 +167,24 @@ ocfs2_filecheck_erase_entries(struct
>> ocfs2_filecheck_sysfs_entry *ent,
>>   }
>>
>>   static void
>> -ocfs2_filecheck_done_entry(struct ocfs2_filecheck_sysfs_entry *ent,
>> +ocfs2_filecheck_done_entry(struct ocfs2_super *osb,
>>   			   struct ocfs2_filecheck_entry *entry)
>>   {
>>   	entry->fe_done = 1;
>> -	spin_lock(&ent->fs_fcheck->fc_lock);
>> -	ent->fs_fcheck->fc_done++;
>> -	spin_unlock(&ent->fs_fcheck->fc_lock);
>> +	spin_lock(&osb->fc_lock);
>> +	osb->fc_done++;
>> +	spin_unlock(&osb->fc_lock);
>>   }
>>
>>   static unsigned int
>> -ocfs2_filecheck_handle(struct super_block *sb,
>> +ocfs2_filecheck_handle(struct ocfs2_super *osb,
>>   		       unsigned long ino, unsigned int flags)
>>   {
>>   	unsigned int ret = OCFS2_FILECHECK_ERR_SUCCESS;
>>   	struct inode *inode = NULL;
>>   	int rc;
>>
>> -	inode = ocfs2_iget(OCFS2_SB(sb), ino, flags, 0);
>> +	inode = ocfs2_iget(osb, ino, flags, 0);
>>   	if (IS_ERR(inode)) {
>>   		rc = (int)(-(long)inode);
>>   		if (rc >= OCFS2_FILECHECK_ERR_START &&
>> @@ -518,89 +199,64 @@ ocfs2_filecheck_handle(struct super_block *sb,
>>   }
>>
>>   static void
>> -ocfs2_filecheck_handle_entry(struct ocfs2_filecheck_sysfs_entry *ent,
>> +ocfs2_filecheck_handle_entry(struct ocfs2_super *osb,
>>   			     struct ocfs2_filecheck_entry *entry)
>>   {
>>   	if (entry->fe_type == OCFS2_FILECHECK_TYPE_CHK)
>> -		entry->fe_status = ocfs2_filecheck_handle(ent->fs_sb,
>> +		entry->fe_status = ocfs2_filecheck_handle(osb,
>>   				entry->fe_ino, OCFS2_FI_FLAG_FILECHECK_CHK);
>>   	else if (entry->fe_type == OCFS2_FILECHECK_TYPE_FIX)
>> -		entry->fe_status = ocfs2_filecheck_handle(ent->fs_sb,
>> +		entry->fe_status = ocfs2_filecheck_handle(osb,
>>   				entry->fe_ino, OCFS2_FI_FLAG_FILECHECK_FIX);
>>   	else
>>   		entry->fe_status = OCFS2_FILECHECK_ERR_UNSUPPORTED;
>>
>> -	ocfs2_filecheck_done_entry(ent, entry);
>> +	ocfs2_filecheck_done_entry(osb, entry);
>>   }
>>
>> -static ssize_t ocfs2_filecheck_store(struct kobject *kobj,
>> -				     struct kobj_attribute *attr,
>> -				     const char *buf, size_t count)
>> +int ocfs2_filecheck_add_inode(struct ocfs2_super *osb,
>> +				     unsigned long ino)
>>   {
>> -	struct ocfs2_filecheck_args args;
>>   	struct ocfs2_filecheck_entry *entry;
>> -	struct ocfs2_filecheck_sysfs_entry *ent;
>>   	ssize_t ret = 0;
>>
>> -	if (count == 0)
>> -		return count;
>> -
>> -	if (ocfs2_filecheck_args_parse(attr->attr.name, buf, count, &args)) {
>> -		mlog(ML_ERROR, "Invalid arguments for online file check\n");
>> -		return -EINVAL;
>> -	}
>> -
>> -	ent = ocfs2_filecheck_sysfs_get(kobj->parent->name);
>> -	if (!ent) {
>> -		mlog(ML_ERROR,
>> -		"Cannot get the corresponding entry via device basename %s\n",
>> -		kobj->parent->name);
>> -		return -ENODEV;
>> -	}
>> -
>> -	if (args.fa_type == OCFS2_FILECHECK_TYPE_SET) {
>> -		ret = ocfs2_filecheck_adjust_max(ent, args.fa_len);
>> -		goto exit;
>> -	}
>> -
>>   	entry = kmalloc(sizeof(struct ocfs2_filecheck_entry), GFP_NOFS);
>>   	if (!entry) {
>>   		ret = -ENOMEM;
>>   		goto exit;
>>   	}
>>
>> -	spin_lock(&ent->fs_fcheck->fc_lock);
>> -	if ((ent->fs_fcheck->fc_size >= ent->fs_fcheck->fc_max) &&
>> -	    (ent->fs_fcheck->fc_done == 0)) {
>> +	spin_lock(&osb->fc_lock);
>> +	if ((osb->fc_size >= osb->fc_max) &&
>> +	    (osb->fc_done == 0)) {
>>   		mlog(ML_ERROR,
>>   		"Cannot do more file check "
>>   		"since file check queue(%u) is full now\n",
>> -		ent->fs_fcheck->fc_max);
>> +		osb->fc_max);
>>   		ret = -EBUSY;
>>   		kfree(entry);
>>   	} else {
>> -		if ((ent->fs_fcheck->fc_size >= ent->fs_fcheck->fc_max) &&
>> -		    (ent->fs_fcheck->fc_done > 0)) {
>> +		if ((osb->fc_size >= osb->fc_max) &&
>> +		    (osb->fc_done > 0)) {
>>   			/* Delete the oldest entry which was done,
>>   			 * make sure the entry size in list does
>>   			 * not exceed maximum value
>>   			 */
>> -			BUG_ON(!ocfs2_filecheck_erase_entry(ent));
>> +			BUG_ON(!ocfs2_filecheck_erase_entry(osb));
>>   		}
>>
>> -		entry->fe_ino = args.fa_ino;
>> -		entry->fe_type = args.fa_type;
>> +		entry->fe_ino = ino;
>> +		entry->fe_type = OCFS2_FILECHECK_TYPE_CHK;
>>   		entry->fe_done = 0;
>>   		entry->fe_status = OCFS2_FILECHECK_ERR_INPROGRESS;
>> -		list_add_tail(&entry->fe_list, &ent->fs_fcheck->fc_head);
>> -		ent->fs_fcheck->fc_size++;
>> +		list_add_tail(&entry->fe_list, &osb->file_check_entries);
>> +		osb->fc_size++;
>>   	}
>> -	spin_unlock(&ent->fs_fcheck->fc_lock);
>> +	spin_unlock(&osb->fc_lock);
>>
>>   	if (!ret)
>> -		ocfs2_filecheck_handle_entry(ent, entry);
>> +		ocfs2_filecheck_handle_entry(osb, entry);
>>
>>   exit:
>> -	ocfs2_filecheck_sysfs_put(ent);
>> -	return (!ret ? count : ret);
>> +	return ret;
>>   }
>> diff --git a/fs/ocfs2/filecheck.h b/fs/ocfs2/filecheck.h
>> index e5cd002..b1a0d8c 100644
>> --- a/fs/ocfs2/filecheck.h
>> +++ b/fs/ocfs2/filecheck.h
>> @@ -42,8 +42,18 @@ enum {
>>
>>   #define OCFS2_FILECHECK_ERR_START	OCFS2_FILECHECK_ERR_FAILED
>>   #define OCFS2_FILECHECK_ERR_END		OCFS2_FILECHECK_ERR_UNSUPPORTED
>> +#define OCFS2_FILECHECK_MAXSIZE         100
>> +#define OCFS2_FILECHECK_MINSIZE         10
>> +
>> +/* File check operation type */
>> +#define OCFS2_FILECHECK_TYPE_CHK  	1   /* Check a file(inode) */
>> +#define OCFS2_FILECHECK_TYPE_FIX  	2   /* Fix a file(inode) */
> Please use enum, not use macro definitions, maybe there will be more type.
> OCFS2_FILECHECK_TYPE_CHK should be zero, otherwise this macro is different with previous enum definitions.
>
>>
>>   int ocfs2_filecheck_create_sysfs(struct super_block *sb);
>>   int ocfs2_filecheck_remove_sysfs(struct super_block *sb);
>> +int ocfs2_filefix_inode(struct ocfs2_super *osb, unsigned long ino);
>> +int ocfs2_filecheck_add_inode(struct ocfs2_super *osb, unsigned long ino);
>> +int ocfs2_filecheck_set_max_entries(struct ocfs2_super *osb, int num);
>> +int ocfs2_filecheck_show(struct ocfs2_super *osb, unsigned int type, char
>> *buf);
>>
>>   #endif  /* FILECHECK_H */
>> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
>> index 8e66cdf..9ced543 100644
>> --- a/fs/ocfs2/ocfs2.h
>> +++ b/fs/ocfs2/ocfs2.h
>> @@ -474,6 +474,13 @@ struct ocfs2_super
>>   	 */
>>   	struct workqueue_struct *ocfs2_wq;
>>
>> +	/* file check */
>> +	struct list_head file_check_entries;
>> +	unsigned int fc_size;
>> +	unsigned int fc_max;
>> +	unsigned int fc_done;
>> +	spinlock_t fc_lock;
>> +
> Gang: please use a separate structure to include all the file check members, easy to read/maintain.


I would prefer it to be a part of ocfs2_super. It is easier to maintain 
and read.

>
>>   	struct kobject kobj;
>>   	struct completion kobj_unregister;
>>   };
>> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
>> index 96b7a9f..a7791fa 100644
>> --- a/fs/ocfs2/super.c
>> +++ b/fs/ocfs2/super.c
>> @@ -2215,6 +2215,13 @@ static int ocfs2_initialize_super(struct super_block
>> *sb,
>>
>>   	get_random_bytes(&osb->s_next_generation, sizeof(u32));
>>
>> +	/* file check information */
>> +	INIT_LIST_HEAD(&osb->file_check_entries);
>> +	osb->fc_max = OCFS2_FILECHECK_MINSIZE;
>> +	osb->fc_size = 0;
>> +	osb->fc_done = 0;
>> +	spin_lock_init(&osb->fc_lock);
>> +
> Gang: write a separate funtion in filecheck.c to include these line code, easy to read/maintain.

Why? Unless we are starting something specific to filecheck, I don't see 
any need.

>
>>   	/* FIXME
>>   	 * This should be done in ocfs2_journal_init(), but unknown
>>   	 * ordering issues will cause the filesystem to crash.
>> diff --git a/fs/ocfs2/sysfs.c b/fs/ocfs2/sysfs.c
>> index e21e699..81e3dd4 100644
>> --- a/fs/ocfs2/sysfs.c
>> +++ b/fs/ocfs2/sysfs.c
>> @@ -1,5 +1,6 @@
>>   #include "ocfs2.h"
>>   #include "sysfs.h"
>> +#include "filecheck.h"
>>
>>   struct ocfs2_sb_attr {
>>   	struct attribute attr;
>> @@ -9,8 +10,12 @@ struct ocfs2_sb_attr {
>>   			const char *buf, size_t count);
>>   };
>>
>> -#define OCFS2_SB_ATTR(_name, _mode) \
>> -struct ocfs2_sb_attr sb_attr_##_name = __ATTR(name, _mode, _show, _store)
>> +#define OCFS2_SB_ATTR(_name) \
>> +struct ocfs2_sb_attr sb_attr_##_name = { \
>> +	.attr = {.name = __stringify(_name), .mode = (S_IWUSR | S_IRUGO)},  \
>> +	.show = _name##_show, \
>> +	.store = _name##_store \
>> +}
>>
>>   #define OCFS2_SB_ATTR_RO(_name) \
>>   struct ocfs2_sb_attr sb_attr_##_name = __ATTR_RO(_name)
>> @@ -46,6 +51,81 @@ static ssize_t slot_num_show(struct ocfs2_super *osb,
>>   	return sprintf(buf, "%d\n", osb->slot_num);
>>   }
>>
>> +static ssize_t file_check_show(struct ocfs2_super *osb,
>> +		struct ocfs2_sb_attr *attr,
>> +		char *buf)
>> +{
>> +	return ocfs2_filecheck_show(osb, OCFS2_FILECHECK_TYPE_CHK, buf);
>> +}
>> +
>> +static ssize_t file_check_store(struct ocfs2_super *osb,
>> +		struct ocfs2_sb_attr *attr,
>> +		const char *buf, size_t count)
>> +{
>> +	unsigned long t;
>> +	int ret;
>> +
>> +	ret = kstrtoul(skip_spaces(buf), 0, &t);
>> +	if (ret)
>> +		return ret;
>> +	ret = ocfs2_filecheck_add_inode(osb, t);
>> +	if (ret)
>> +		return ret;
>> +	return count;
>> +}
>> +
>> +static ssize_t file_fix_show(struct ocfs2_super *osb,
>> +		struct ocfs2_sb_attr *attr,
>> +		char *buf)
>> +{
>> +	return ocfs2_filecheck_show(osb, OCFS2_FILECHECK_TYPE_FIX, buf);
>> +}
>> +
>> +static ssize_t file_fix_store(struct ocfs2_super *osb,
>> +		struct ocfs2_sb_attr *attr,
>> +		const char *buf, size_t count)
>> +{
>> +	unsigned long t;
>> +	int ret;
>> +
>> +	ret = kstrtoul(skip_spaces(buf), 0, &t);
>> +	if (ret)
>> +		return ret;
>> +	ret = ocfs2_filecheck_add_inode(osb, t);
>> +	if (ret)
>> +		return ret;
>> +	return count;
>> +}
>> +
>> +static ssize_t file_check_max_entries_show(struct ocfs2_super *osb,
>> +		struct ocfs2_sb_attr *attr,
>> +		char *buf)
>> +{
>> +	int len = 0;
>> +	spin_lock(&osb->fc_lock);
>> +	/* Show done, current size and max */
>> +	len += sprintf(buf, "%d\t%d\t%d\n", osb->fc_done, osb->fc_size,
>> +			osb->fc_max);
>> +	spin_unlock(&osb->fc_lock);
>> +	return len;
>> +}
>> +
>> +static ssize_t file_check_max_entries_store(struct ocfs2_super *osb,
>> +		struct ocfs2_sb_attr *attr, const char *buf, size_t count)
>> +{
>> +
>> +	unsigned long t;
>> +	int ret;
>> +
>> +	ret = kstrtoul(skip_spaces(buf), 0, &t);
> Gang: please make sure the function kstrtoul does work well since the inputed buf has not terminating null character.
> This is why I write a wrapper function ocfs2_filecheck_args_get_long().

Can you give an example on how this can be activated? Maybe a check on 
value < 0 may make sense.

>
>> +	if (ret)
>> +		return ret;
>> +	ret = ocfs2_filecheck_set_max_entries(osb, (int)t);
>> +	if (ret)
>> +		return ret;
>> +	return count;
>> +}
>> +
>>   static void sb_release(struct kobject *kobj)
>>   {
>>   	struct ocfs2_super *osb = container_of(kobj, struct ocfs2_super, kobj);
>> @@ -58,8 +138,15 @@ static const struct sysfs_ops ocfs2_sb_sysfs_ops = {
>>   };
>>
>>   static OCFS2_SB_ATTR_RO(slot_num);
>> +static OCFS2_SB_ATTR(file_check);
>> +static OCFS2_SB_ATTR(file_fix);
>> +static OCFS2_SB_ATTR(file_check_max_entries);
>> +
>>   static struct attribute *ocfs2_sb_attrs[] = {
>>   	&sb_attr_slot_num.attr,
>> +	&sb_attr_file_check.attr,
>> +	&sb_attr_file_fix.attr,
>> +	&sb_attr_file_check_max_entries.attr,
>>   	NULL
>>   };
> Gang: as I said in the first patch, please make all the file check related attributes in a separate sub directory.
> It will let us to be easy to read/debug, especially if there is any reference count leaking problem.

The main reason of the code is to remove unnecessary data structures 
which is making the code hard to understand. I don't see a point in 
keeping them in a separate structure besides adding more indirections.


-- 
Goldwyn
