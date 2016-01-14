From: Gang He <ghe@suse.com>
Date: Wed, 13 Jan 2016 20:13:31 -0700
Subject: [Ocfs2-devel] [PATCH v3 2/4] ocfs2: sysfile interfaces for
 online file check
In-Reply-To: <20160113233538.GL819@wotan.suse.de>
References: <1451027779-6849-1-git-send-email-ghe@suse.com>
	<1451027779-6849-3-git-send-email-ghe@suse.com>
	<20160113233538.GL819@wotan.suse.de>
Message-ID: <569782DB020000F900025A5F@relay2.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.de>
Cc: akpm@linux-foundation.org, ocfs2-devel@oss.oracle.com, rgoldwyn@suse.de, linux-kernel@vger.kernel.org

Hello Mark,


>>> 
> On Fri, Dec 25, 2015 at 03:16:17PM +0800, Gang He wrote:
>> Implement online file check sysfile interfaces, e.g.
>> how to create the related sysfile according to device name,
>> how to display/handle file check request from the sysfile.
>> 
>> Signed-off-by: Gang He <ghe@suse.com>
> 
> Most of this looks good, I have two comments below. Also thank you for
> redoing the interface to be more sysfs friendly.
> 
> 
>> diff --git a/fs/ocfs2/filecheck.c b/fs/ocfs2/filecheck.c
>> new file mode 100644
>> index 0000000..a83e4ba
>> --- /dev/null
>> +++ b/fs/ocfs2/filecheck.c
>> @@ -0,0 +1,605 @@
>> +static DEFINE_SPINLOCK(ocfs2_filecheck_sysfs_lock);
>> +static LIST_HEAD(ocfs2_filecheck_sysfs_list);
>> +
>> +struct ocfs2_filecheck {
>> +	struct list_head fc_head;	/* File check entry list head */
>> +	spinlock_t fc_lock;
>> +	unsigned int fc_max;	/* Maximum number of entry in list */
> 
> What is the point of fc_max? Only root can initiate file check so we need
> not worry about a malicious user eating up our memory. That should let us
> drop a bunch of the code below that is concerned with setting/reporting it.
the fc_max item is used to set the maximum number of file check entry (include doing and finished) in the list,
this means the kernel module will keep how many filecheck results (history records) at most when uses cat sysfile to inquire the filecheck results.
the kernel module will not cache all finished filecheck results, I think we need a value to limit this size.

> 
> 
>> +	unsigned int fc_size;	/* Current entry count in list */
>> +	unsigned int fc_done;	/* Finished entry count in list */
>> +};
>> +
>> +struct ocfs2_filecheck_sysfs_entry {	/* sysfs entry per mounting */
>> +	struct list_head fs_list;
>> +	atomic_t fs_count;
>> +	struct super_block *fs_sb;
>> +	struct kset *fs_devicekset;
>> +	struct kset *fs_fcheckkset;
>> +	struct ocfs2_filecheck *fs_fcheck;
>> +};
>> +
>> +#define OCFS2_FILECHECK_MAXSIZE		100
>> +#define OCFS2_FILECHECK_MINSIZE		10
>> +
>> +/* File check operation type */
>> +enum {
>> +	OCFS2_FILECHECK_TYPE_CHK = 0,	/* Check a file(inode) */
>> +	OCFS2_FILECHECK_TYPE_FIX,	/* Fix a file(inode) */
>> +	OCFS2_FILECHECK_TYPE_SET = 100	/* Set entry list maximum size */
>> +};
>> +
>> +struct ocfs2_filecheck_entry {
>> +	struct list_head fe_list;
>> +	unsigned long fe_ino;
>> +	unsigned int fe_type;
>> +	unsigned short fe_done:1;
>> +	unsigned short fe_status:15;
> 
> I don't see the need to use a short here (or bitfield) for fc_status. IMHO
> it is less error-prone if we just make it an int or unsigned int.
OK, I will make it an unsigned int type, but a bit field have to be used to indicate this file check entry is done, or under processing. 
Since we use this flag (fe_done) when we shrink the result records, we only can get rid of finished entries. 

> 
> 
> This is a bit off topic but I dream of the day when we can return errors
> which userspace undestands but are outside the tiny range of 0-255  :)
Yes, this is why we return a error string in the result, not a error number.
 Second, these file check errors (most) are not generic, then we can not utilize system error numbers. 

> 
> Thanks,
> 	--Mark
> 
> --
> Mark Fasheh
