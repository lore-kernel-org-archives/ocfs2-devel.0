From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri Dec 21 09:39:46 2007
Subject: [Ocfs2-devel] [PATCH 06/30] ocfs2: Include	do_sync_mapping_range()
	from mainline
In-Reply-To: <20071221085242.GB18627@ca-server1.us.oracle.com>
References: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
	<1198193387-16606-5-git-send-email-sunil.mushran@oracle.com>
	<20071221085242.GB18627@ca-server1.us.oracle.com>
Message-ID: <476BFA11.40206@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Yes, this is better.

Joel Becker wrote:
> On Thu, Dec 20, 2007 at 03:29:23PM -0800, Sunil Mushran wrote:
>   
>> Commit 5b04aa3a64f854244bc40a6f528176ed50b5c4f6 introduced export symbol
>> do_sync_mapping_range(). This patch allows one to build ocfs2 with kernels
>> having/not having that change.
>>     
>
> 	Rather than putting this in alloc.c, I'd put it in
> kapi-include/sync_mapping_range.h, wrapped in the
> !HAVE_SYNC_MAPPING_RANGE check:
>
>     #ifndef KAPI_SYNC_MAPPING_RANGE_H
>     #define KAPI_SYNC_MAPPING_RANGE_H
>
>     #ifndef HAVE_SYNC_MAPPING_RANGE
>     int do_writepages...
>     {
>     }
>     int sync_mapping..
>     {
>     }
>     #endif
>     #endif
>
> then, in fs/ocfs2/Makefile, I'd do:
>
> ifdef HAS_SYNC_MAPPING_RANGE
> CPPFLAGS_alloc.o += -DHAS_SYNC_MAPPING_RANGE
> endif
>
> This applys the define to alloc.c only.  Thus, while all files would get
> -include kapi-compat/sync_mapping_range.h, every file except alloc.c
> would see it as empty.
> 	The other thing I would do would be to reverse the check.  Right
> now, you set HAS_SYNC_MAPPING_RANGE for new kernels.  If I ran "make -C
> /usr/src/linux M=`pwd`/fs/ocfs2" without running configure, it would
> fail against a recent kernel.
>
> Joel
>
>   
>> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
>> ---
>>  Config.make.in    |    2 +
>>  configure.in      |    5 +++
>>  fs/ocfs2/Makefile |    4 ++
>>  fs/ocfs2/alloc.c  |   93 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 104 insertions(+), 0 deletions(-)
>>
>> diff --git a/Config.make.in b/Config.make.in
>> index befeb79..1fe7ddc 100644
>> --- a/Config.make.in
>> +++ b/Config.make.in
>> @@ -59,6 +59,8 @@ EXTRA_CFLAGS += @KAPI_COMPAT_CFLAGS@
>>  
>>  DELAYED_WORK_DEFINED = @DELAYED_WORK_DEFINED@
>>  
>> +HAS_SYNC_MAPPING_RANGE  = @HAS_SYNC_MAPPING_RANGE@
>> +
>>  OCFS_DEBUG = @OCFS_DEBUG@
>>  
>>  ifneq ($(OCFS_DEBUG),)
>> diff --git a/configure.in b/configure.in
>> index 47b0da0..603dc94 100644
>> --- a/configure.in
>> +++ b/configure.in
>> @@ -172,6 +172,11 @@ OCFS2_CHECK_KERNEL([zero_user_page() in highmem.h], highmem.h,
>>    , highmem_compat_header="highmem.h", [zero_user_page])
>>  KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $highmem_compat_header"
>>  
>> +HAS_SYNC_MAPPING_RANGE=
>> +OCFS2_CHECK_KERNEL([do_sync_mapping_range() in fs.h], fs.h,
>> +  HAS_SYNC_MAPPING_RANGE=yes, , [do_sync_mapping_range(])
>> +AC_SUBST(HAS_SYNC_MAPPING_RANGE)
>> +
>>  # using -include has two advantages:
>>  #  the source doesn't need to know to include compat headers
>>  #  the compat header file names don't go through the search path
>> diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
>> index 0edfed7..3dc33a5 100644
>> --- a/fs/ocfs2/Makefile
>> +++ b/fs/ocfs2/Makefile
>> @@ -29,6 +29,10 @@ ifdef DELAYED_WORK_DEFINED
>>  EXTRA_CFLAGS += -DDELAYED_WORK_DEFINED
>>  endif
>>  
>> +ifdef HAS_SYNC_MAPPING_RANGE
>> +EXTRA_CFLAGS += -DHAS_SYNC_MAPPING_RANGE
>> +endif
>> +
>>  #
>>  # Since SUBDIRS means something to kbuild, define them safely.  Do not
>>  # include trailing slashes.
>> diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
>> index 5a8a4f2..0cc4729 100644
>> --- a/fs/ocfs2/alloc.c
>> +++ b/fs/ocfs2/alloc.c
>> @@ -29,6 +29,11 @@
>>  #include <linux/highmem.h>
>>  #include <linux/swap.h>
>>  
>> +#ifndef HAS_SYNC_MAPPING_RANGE
>> +#include <linux/writeback.h>
>> +#include <linux/mpage.h>
>> +#endif
>> +
>>  #define MLOG_MASK_PREFIX ML_DISK_ALLOC
>>  #include <cluster/masklog.h>
>>  
>> @@ -5750,6 +5755,94 @@ out:
>>  	return ret;
>>  }
>>  
>> +#ifndef HAS_SYNC_MAPPING_RANGE
>> +int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
>> +{
>> +	int ret;
>> +
>> +	if (wbc->nr_to_write <= 0)
>> +		return 0;
>> +	wbc->for_writepages = 1;
>> +	if (mapping->a_ops->writepages)
>> +		ret = mapping->a_ops->writepages(mapping, wbc);
>> +	else
>> +		ret = generic_writepages(mapping, wbc);
>> +	wbc->for_writepages = 0;
>> +	return ret;
>> +}
>> +
>> +/**
>> + * __filemap_fdatawrite_range - start writeback on mapping dirty pages in range
>> + * @mapping:	address space structure to write
>> + * @start:	offset in bytes where the range starts
>> + * @end:	offset in bytes where the range ends (inclusive)
>> + * @sync_mode:	enable synchronous operation
>> + *
>> + * Start writeback against all of a mapping's dirty pages that lie
>> + * within the byte offsets <start, end> inclusive.
>> + *
>> + * If sync_mode is WB_SYNC_ALL then this is a "data integrity" operation, as
>> + * opposed to a regular memory cleansing writeback.  The difference between
>> + * these two operations is that if a dirty page/buffer is encountered, it must
>> + * be waited upon, and not just skipped over.
>> + */
>> +int __filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
>> +				loff_t end, int sync_mode)
>> +{
>> +	int ret;
>> +	struct writeback_control wbc = {
>> +		.sync_mode = sync_mode,
>> +		.nr_to_write = mapping->nrpages * 2,
>> +		.range_start = start,
>> +		.range_end = end,
>> +	};
>> +
>> +	if (!mapping_cap_writeback_dirty(mapping))
>> +		return 0;
>> +
>> +	ret = do_writepages(mapping, &wbc);
>> +	return ret;
>> +}
>> +
>> +/*
>> + * `endbyte' is inclusive
>> + */
>> +static int do_sync_mapping_range(struct address_space *mapping, loff_t offset,
>> +				 loff_t endbyte, unsigned int flags)
>> +{
>> +	int ret;
>> +
>> +	if (!mapping) {
>> +		ret = -EINVAL;
>> +		goto out;
>> +	}
>> +
>> +	ret = 0;
>> +	if (flags & SYNC_FILE_RANGE_WAIT_BEFORE) {
>> +		ret = wait_on_page_writeback_range(mapping,
>> +					offset >> PAGE_CACHE_SHIFT,
>> +					endbyte >> PAGE_CACHE_SHIFT);
>> +		if (ret < 0)
>> +			goto out;
>> +	}
>> +
>> +	if (flags & SYNC_FILE_RANGE_WRITE) {
>> +		ret = __filemap_fdatawrite_range(mapping, offset, endbyte,
>> +						WB_SYNC_NONE);
>> +		if (ret < 0)
>> +			goto out;
>> +	}
>> +
>> +	if (flags & SYNC_FILE_RANGE_WAIT_AFTER) {
>> +		ret = wait_on_page_writeback_range(mapping,
>> +					offset >> PAGE_CACHE_SHIFT,
>> +					endbyte >> PAGE_CACHE_SHIFT);
>> +	}
>> +out:
>> +	return ret;
>> +}
>> +#endif
>> +
>>  /*
>>   * Zero the area past i_size but still within an allocated
>>   * cluster. This avoids exposing nonzero data on subsequent file
>> -- 
>> 1.5.2.5
>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel@oss.oracle.com
>> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>     
>
>   
