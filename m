From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Tue Jan  8 13:23:00 2008
Subject: [Ocfs2-devel] [PATCH 06/30] ocfs2: Include	do_sync_mapping_range()
	from mainline
In-Reply-To: <20080108211920.GF23506@ca-server1.us.oracle.com>
References: <1199388006-32658-1-git-send-email-sunil.mushran@oracle.com>
	<1199388006-32658-5-git-send-email-sunil.mushran@oracle.com>
	<20080108211920.GF23506@ca-server1.us.oracle.com>
Message-ID: <4783E96F.3030307@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

FLAGS_alloc.o += -DNO_SYNC_MAPPING_RANGE

It's only included with alloc.c.


Mark Fasheh wrote:
> On Thu, Jan 03, 2008 at 11:19:42AM -0800, Sunil Mushran wrote:
>   
>> Commit 5b04aa3a64f854244bc40a6f528176ed50b5c4f6 introduced export symbol
>> do_sync_mapping_range(). This patch allows one to build ocfs2 with kernels
>> having/not having that change.
>>
>> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
>> Signed-off-by: Joel Becker <joel.becker@oracle.com>
>> ---
>>  Config.make.in                           |    2 +
>>  Makefile                                 |    3 +-
>>  configure.in                             |    6 ++
>>  fs/ocfs2/Makefile                        |    4 +
>>  kapi-compat/include/sync_mapping_range.h |  103 ++++++++++++++++++++++++++++++
>>  5 files changed, 117 insertions(+), 1 deletions(-)
>>  create mode 100644 kapi-compat/include/sync_mapping_range.h
>>
>> diff --git a/Config.make.in b/Config.make.in
>> index 1dc4d44..67ee363 100644
>> --- a/Config.make.in
>> +++ b/Config.make.in
>> @@ -59,6 +59,8 @@ EXTRA_CFLAGS += @KAPI_COMPAT_CFLAGS@
>>  
>>  NO_DELAYED_WORK = @NO_DELAYED_WORK@
>>  
>> +NO_SYNC_MAPPING_RANGE  = @NO_SYNC_MAPPING_RANGE@
>> +
>>  OCFS_DEBUG = @OCFS_DEBUG@
>>  
>>  ifneq ($(OCFS_DEBUG),)
>> diff --git a/Makefile b/Makefile
>> index b7b86db..3ddb1aa 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -11,7 +11,8 @@ LINUX_INCLUDE_FILES =
>>  KAPI_COMPAT_FILES = \
>>  	kapi-compat/include/workqueue.h \
>>  	kapi-compat/include/compiler.h \
>> -	kapi-compat/include/highmem.h
>> +	kapi-compat/include/highmem.h \
>> +	kapi-compat/include/sync_mapping_range.h
>>  
>>  PATCH_FILES =
>>  
>> diff --git a/configure.in b/configure.in
>> index 0108f99..72698ae 100644
>> --- a/configure.in
>> +++ b/configure.in
>> @@ -172,6 +172,12 @@ OCFS2_CHECK_KERNEL([zero_user_page() in highmem.h], highmem.h,
>>    , highmem_compat_header="highmem.h", [zero_user_page])
>>  KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS $highmem_compat_header"
>>  
>> +NO_SYNC_MAPPING_RANGE=
>> +OCFS2_CHECK_KERNEL([do_sync_mapping_range() in fs.h], fs.h,
>> +  , NO_SYNC_MAPPING_RANGE=yes, [do_sync_mapping_range(])
>> +KAPI_COMPAT_HEADERS="$KAPI_COMPAT_HEADERS sync_mapping_range.h"
>> +AC_SUBST(NO_SYNC_MAPPING_RANGE)
>> +
>>  # using -include has two advantages:
>>  #  the source doesn't need to know to include compat headers
>>  #  the compat header file names don't go through the search path
>> diff --git a/fs/ocfs2/Makefile b/fs/ocfs2/Makefile
>> index 8bc2dff..737c12a 100644
>> --- a/fs/ocfs2/Makefile
>> +++ b/fs/ocfs2/Makefile
>> @@ -29,6 +29,10 @@ ifdef NO_DELAYED_WORK
>>  EXTRA_CFLAGS += -DNO_DELAYED_WORK
>>  endif
>>  
>> +ifdef NO_SYNC_MAPPING_RANGE
>> +CFLAGS_alloc.o += -DNO_SYNC_MAPPING_RANGE
>> +endif
>> +
>>  #
>>  # Since SUBDIRS means something to kbuild, define them safely.  Do not
>>  # include trailing slashes.
>> diff --git a/kapi-compat/include/sync_mapping_range.h b/kapi-compat/include/sync_mapping_range.h
>> new file mode 100644
>> index 0000000..d6e1b30
>> --- /dev/null
>> +++ b/kapi-compat/include/sync_mapping_range.h
>> @@ -0,0 +1,103 @@
>> +#ifndef KAPI_SYNC_MAPPING_RANGE_H
>> +#define KAPI_SYNC_MAPPING_RANGE_H
>> +
>> +#ifdef NO_SYNC_MAPPING_RANGE
>> +
>> +#include <linux/fs.h>
>> +#include <linux/types.h>
>> +#include <linux/slab.h>
>> +#include <linux/highmem.h>
>> +#include <linux/swap.h>
>> +#include <linux/writeback.h>
>> +#include <linux/mpage.h>
>> +#include <linux/pagemap.h>
>> +
>> +
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
>>     
>
> Shouldn't the function definitions be in a C file? It's pretty heavy for a
> header....
> 	--Mark
>
> --
> Mark Fasheh
> Principal Software Developer, Oracle
> mark.fasheh@oracle.com
>   
