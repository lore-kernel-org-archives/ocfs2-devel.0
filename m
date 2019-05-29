From: Gang He <ghe@suse.com>
Date: Wed, 29 May 2019 02:12:08 -0600
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: add last unlock times in
 locking_state
In-Reply-To: <66083663-1d25-437b-ce98-07d200f446ab@oracle.com>
References: <20190523104047.14794-1-ghe@suse.com>
	<66083663-1d25-437b-ce98-07d200f446ab@oracle.com>
Message-ID: <5CEE3ED8020000F900068B85@prv1-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jlbec@evilplan.org, mark@fasheh.com, jiangqi903@gmail.com, Wengang <wen.gang.wang@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Hi Wengang,

>>> On 2019/5/29 at 1:22, in message
<66083663-1d25-437b-ce98-07d200f446ab@oracle.com>, Wengang
<wen.gang.wang@oracle.com> wrote:
> Hi Gang,
> 
> This idea sounds cool!
> Some comments in lines:
> 
> On 05/23/2019 03:40 AM, Gang He wrote:
>> ocfs2 file system uses locking_state file under debugfs to dump
>> each ocfs2 file system's dlm lock resources, but the dlm lock
>> resources in memory are becoming more and more after the files
>> were touched by the user. it will become a bit difficult to analyze
>> these dlm lock resource records in locking_state file by the upper
>> scripts, though some files are not active for now, which were
>> accessed long time ago.
>> Then, I'd like to add last pr/ex unlock times in locking_state file
>> for each dlm lock resource record, the the upper scripts can use
>> last unlock time to filter inactive dlm lock resource record.
>>
>> Signed-off-by: Gang He <ghe@suse.com>
>> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> ---
>>   fs/ocfs2/dlmglue.c | 21 +++++++++++++++++----
>>   fs/ocfs2/ocfs2.h   |  1 +
>>   2 files changed, 18 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
>> index af405586c5b1..dccf4136f8c1 100644
>> --- a/fs/ocfs2/dlmglue.c
>> +++ b/fs/ocfs2/dlmglue.c
>> @@ -448,7 +448,7 @@ static void ocfs2_update_lock_stats(struct 
> ocfs2_lock_res *res, int level,
>>   				    struct ocfs2_mask_waiter *mw, int ret)
>>   {
>>   	u32 usec;
>> -	ktime_t kt;
>> +	ktime_t last, kt;
>>   	struct ocfs2_lock_stats *stats;
>>   
>>   	if (level == LKM_PRMODE)
>> @@ -458,7 +458,8 @@ static void ocfs2_update_lock_stats(struct 
> ocfs2_lock_res *res, int level,
>>   	else
>>   		return;
>>   
>> -	kt = ktime_sub(ktime_get(), mw->mw_lock_start);
>> +	last = ktime_get();
> Will ktime_get_real() be better than ktime_get() here?
> Per description,
> ktime_get:
> Useful for reliable timestamps and measuring short time intervals 
> accurately. Starts at system boot time but stops during suspend.
> ktime_get_real:
> Returns the time in relative to the UNIX epoch starting in 1970 using 
> the Coordinated Universal Time (UTC), same as gettimeofday() user space.
> 
> Since ktime_get() returnis time since boot time, this value is 
> meaningless when compared to those from a different node in cluster, right?
Ok, maybe we can use ktime_get_real_seconds to get the seconds, but we 
need to use 64bit time64_t type to save the value and dump to the user-space.

Thanks
Gang

> 
> And we need a "__kernel_long_t" to rather than a "u32"?
> 
> 
>> +	kt = ktime_sub(last, mw->mw_lock_start);
>>   	usec = ktime_to_us(kt);
>>   
>>   	stats->ls_gets++;
>> @@ -474,6 +475,8 @@ static void ocfs2_update_lock_stats(struct 
> ocfs2_lock_res *res, int level,
>>   
>>   	if (ret)
>>   		stats->ls_fail++;
>> +
>> +	stats->ls_last = ktime_to_timespec(last).tv_sec;
>>   }
>>   
> Though maybe ocfs2_update_lock_stats() is designed to be called for each 
> successful lock request,
> seems current code calls it even when it returns with -EAGAIN which 
> breaks the design.  That's not introduced by your change, well, it may 
> lead to wrong stats...
> 
> thanks,
> wengang
> 
>>   static inline void ocfs2_track_lock_refresh(struct ocfs2_lock_res 
> *lockres)
>> @@ -3093,8 +3096,10 @@ static void *ocfs2_dlm_seq_next(struct seq_file *m, 
> void *v, loff_t *pos)
>>    *	- Lock stats printed
>>    * New in version 3
>>    *	- Max time in lock stats is in usecs (instead of nsecs)
>> + * New in version 4
>> + *	- Add last pr/ex unlock times in secs
>>    */
>> -#define OCFS2_DLM_DEBUG_STR_VERSION 3
>> +#define OCFS2_DLM_DEBUG_STR_VERSION 4
>>   static int ocfs2_dlm_seq_show(struct seq_file *m, void *v)
>>   {
>>   	int i;
>> @@ -3145,6 +3150,8 @@ static int ocfs2_dlm_seq_show(struct seq_file *m, void 
> *v)
>>   # define lock_max_prmode(_l)		((_l)->l_lock_prmode.ls_max)
>>   # define lock_max_exmode(_l)		((_l)->l_lock_exmode.ls_max)
>>   # define lock_refresh(_l)		((_l)->l_lock_refresh)
>> +# define lock_last_prmode(_l)		((_l)->l_lock_prmode.ls_last)
>> +# define lock_last_exmode(_l)		((_l)->l_lock_exmode.ls_last)
>>   #else
>>   # define lock_num_prmode(_l)		(0)
>>   # define lock_num_exmode(_l)		(0)
>> @@ -3155,6 +3162,8 @@ static int ocfs2_dlm_seq_show(struct seq_file *m, void 
> *v)
>>   # define lock_max_prmode(_l)		(0)
>>   # define lock_max_exmode(_l)		(0)
>>   # define lock_refresh(_l)		(0)
>> +# define lock_last_prmode(_l)		(0)
>> +# define lock_last_exmode(_l)		(0)
>>   #endif
>>   	/* The following seq_print was added in version 2 of this output */
>>   	seq_printf(m, "%u\t"
>> @@ -3165,6 +3174,8 @@ static int ocfs2_dlm_seq_show(struct seq_file *m, void 
> *v)
>>   		   "%llu\t"
>>   		   "%u\t"
>>   		   "%u\t"
>> +		   "%u\t"
>> +		   "%u\t"
>>   		   "%u\t",
>>   		   lock_num_prmode(lockres),
>>   		   lock_num_exmode(lockres),
>> @@ -3174,7 +3185,9 @@ static int ocfs2_dlm_seq_show(struct seq_file *m, void 
> *v)
>>   		   lock_total_exmode(lockres),
>>   		   lock_max_prmode(lockres),
>>   		   lock_max_exmode(lockres),
>> -		   lock_refresh(lockres));
>> +		   lock_refresh(lockres),
>> +		   lock_last_prmode(lockres),
>> +		   lock_last_exmode(lockres));
>>   
>>   	/* End the line */
>>   	seq_printf(m, "\n");
>> diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
>> index 1f029fbe8b8d..8efa022684f4 100644
>> --- a/fs/ocfs2/ocfs2.h
>> +++ b/fs/ocfs2/ocfs2.h
>> @@ -164,6 +164,7 @@ struct ocfs2_lock_stats {
>>   
>>   	/* Storing max wait in usecs saves 24 bytes per inode */
>>   	u32		ls_max;		/* Max wait in USEC */
>> +	u32		ls_last;	/* Last unlock time in SEC */
>>   };
>>   #endif
>>   
