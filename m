From: Gang He <ghe@suse.com>
Date: Mon, 27 Jul 2015 21:15:43 -0600
Subject: [Ocfs2-devel] [patch -next] ocfs2: scheduling in atomic in
 ocfs2_filecheck_store()
In-Reply-To: <20150727140405.c8281f48d81bd33c6ef957a8@linux-foundation.org>
References: <20150727082723.GA3310@mwanda>
	<20150727140405.c8281f48d81bd33c6ef957a8@linux-foundation.org>
Message-ID: <55B7645F020000F90000FE93@relay2.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Andrew and Dan,

Thank for your efforts.
It is better than before.

Thanks a lot.
Gang


>>> 
> On Mon, 27 Jul 2015 11:27:23 +0300 Dan Carpenter <dan.carpenter@oracle.com> 
> wrote:
> 
>> We're hold "spin_lock(&ent->fs_fcheck->fc_lock)" so the allocation has
>> to be GFP_ATOMIC.
>> 
>> I changed the sizeof() because otherwise the line goes over the 80
>> character limit and also the new way is prefered kernel style.
>> 
>> Fixes: e467fe5da718 ('ocfs2: sysfile interfaces for online file check')
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>> 
>> diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
>> index 3332af1..9613663 100644
>> --- a/fs/ocfs2/filecheck.c
>> +++ b/fs/ocfs2/filecheck.c
>> @@ -544,7 +544,7 @@ static ssize_t ocfs2_filecheck_store(struct kobject 
> *kobj,
>>  			BUG_ON(!ocfs2_filecheck_erase_entry(ent));
>>  		}
>>  
>> -		entry = kmalloc(sizeof(struct ocfs2_filecheck_entry), GFP_NOFS);
>> +		entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
>>  		if (entry) {
>>  			entry->fe_ino = args.fa_ino;
>>  			entry->fe_type = args.fa_type;
> 
> GFP_NOFS is more reliable than GFP_ATOMIC, so we should retain that if
> possible.  And it's pretty easy to do here.
> 
> Gang, please carefully review and test?
> 
> 
> --- a/fs/ocfs2/filecheck.c~ocfs2-sysfile-interfaces-for-online-file-check-fix-2
> +++ a/fs/ocfs2/filecheck.c
> @@ -501,7 +501,7 @@ static ssize_t ocfs2_filecheck_store(str
>  				const char *buf, size_t count)
>  {
>  	struct ocfs2_filecheck_args args;
> -	struct ocfs2_filecheck_entry *entry = NULL;
> +	struct ocfs2_filecheck_entry *entry;
>  	struct ocfs2_filecheck_sysfs_entry *ent;
>  	ssize_t ret = 0;
>  
> @@ -527,12 +527,19 @@ static ssize_t ocfs2_filecheck_store(str
>  		return (!ret ? count : ret);
>  	}
>  
> +	entry = kmalloc(sizeof(*entry), GFP_NOFS);
> +	if (!entry) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
>  	spin_lock(&ent->fs_fcheck->fc_lock);
>  	if ((ent->fs_fcheck->fc_size >= ent->fs_fcheck->fc_max) &&
> -		(ent->fs_fcheck->fc_done == 0)) {
> -		mlog(ML_ERROR,
> -		"Online file check queue(%u) is full\n",
> -		ent->fs_fcheck->fc_max);
> +			(ent->fs_fcheck->fc_done == 0)) {
> +		mlog(ML_ERROR, "Online file check queue(%u) is full\n",
> +				ent->fs_fcheck->fc_max);
> +		kfree(entry);
> +		entry = NULL;
>  		ret = -EBUSY;
>  	} else {
>  		if ((ent->fs_fcheck->fc_size >= ent->fs_fcheck->fc_max) &&
> @@ -544,26 +551,21 @@ static ssize_t ocfs2_filecheck_store(str
>  			BUG_ON(!ocfs2_filecheck_erase_entry(ent));
>  		}
>  
> -		entry = kmalloc(sizeof(struct ocfs2_filecheck_entry), GFP_NOFS);
> -		if (entry) {
> -			entry->fe_ino = args.fa_ino;
> -			entry->fe_type = args.fa_type;
> -			entry->fe_done = 0;
> -			entry->fe_status = OCFS2_FILECHECK_ERR_INPROGRESS;
> -			list_add_tail(&entry->fe_list,
> -					&ent->fs_fcheck->fc_head);
> -
> -			ent->fs_fcheck->fc_size++;
> -			ret = count;
> -		} else {
> -			ret = -ENOMEM;
> -		}
> +		entry->fe_ino = args.fa_ino;
> +		entry->fe_type = args.fa_type;
> +		entry->fe_done = 0;
> +		entry->fe_status = OCFS2_FILECHECK_ERR_INPROGRESS;
> +		list_add_tail(&entry->fe_list, &ent->fs_fcheck->fc_head);
> +
> +		ent->fs_fcheck->fc_size++;
> +		ret = count;
>  	}
>  	spin_unlock(&ent->fs_fcheck->fc_lock);
>  
>  	if (entry)
>  		ocfs2_filecheck_handle_entry(ent, entry);
>  
> +out:
>  	ocfs2_filecheck_sysfs_put(ent);
>  	return ret;
>  }
> _
