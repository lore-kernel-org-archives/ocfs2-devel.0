From: John Hubbard <jhubbard@nvidia.com>
Date: Tue, 18 Feb 2020 15:00:12 -0800
Subject: [Ocfs2-devel] [PATCH v6 04/16] mm: Tweak readahead loop slightly
In-Reply-To: <7691abe7-d0e9-e091-b158-764fb624c2d7@nvidia.com>
References: <20200217184613.19668-1-willy@infradead.org>
	<20200217184613.19668-6-willy@infradead.org>
	<7691abe7-d0e9-e091-b158-764fb624c2d7@nvidia.com>
Message-ID: <cf7c9f73-ea15-24a5-2b97-388164a581ef@nvidia.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org

On 2/18/20 2:57 PM, John Hubbard wrote:
> On 2/17/20 10:45 AM, Matthew Wilcox wrote:
>> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>>
>> Eliminate the page_offset variable which was just confusing;
>> record the start of each consecutive run of pages in the
> 
> 

Darn it, I incorrectly reviewed the N/16 patch, instead of the N/19, for 
this one. I thought I had deleted all those! Let me try again with the
correct patch, sorry!!

thanks,
-- 
John Hubbard
NVIDIA

> OK...presumably for the benefit of a following patch, since it is not 
> actually consumed in this patch.
> 
>> readahead_control, and move the 'kick off a fresh batch' code to
>> the end of the function for easier use in the next patch.
> 
> 
> That last bit was actually done in the previous patch, rather than this
> one, right?
> 
>>
>> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>> ---
>>  mm/readahead.c | 31 +++++++++++++++++++------------
>>  1 file changed, 19 insertions(+), 12 deletions(-)
>>
>> diff --git a/mm/readahead.c b/mm/readahead.c
>> index 15329309231f..74791b96013f 100644
>> --- a/mm/readahead.c
>> +++ b/mm/readahead.c
>> @@ -154,7 +154,6 @@ void __do_page_cache_readahead(struct address_space *mapping,
>>  		unsigned long lookahead_size)
>>  {
>>  	struct inode *inode = mapping->host;
>> -	struct page *page;
>>  	unsigned long end_index;	/* The last page we want to read */
>>  	LIST_HEAD(page_pool);
>>  	int page_idx;
>> @@ -163,6 +162,7 @@ void __do_page_cache_readahead(struct address_space *mapping,
>>  	struct readahead_control rac = {
>>  		.mapping = mapping,
>>  		.file = filp,
>> +		._start = offset,
>>  		._nr_pages = 0,
>>  	};
>>  
>> @@ -175,32 +175,39 @@ void __do_page_cache_readahead(struct address_space *mapping,
>>  	 * Preallocate as many pages as we will need.
>>  	 */
>>  	for (page_idx = 0; page_idx < nr_to_read; page_idx++) {
>> -		pgoff_t page_offset = offset + page_idx;
> 
> 
> You know...this ends up incrementing offset each time through the
> loop, so yes, the behavior is the same as when using "offset + page_idx".
> However, now it's a little harder to see that.
> 
> IMHO the page_offset variable is not actually a bad thing, here. I'd rather
> keep it, all other things being equal (and I don't see any other benefits
> here: line count is the same, for example).
> 
> What do you think?
> 
> 
> thanks,
> 
