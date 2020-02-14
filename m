From: John Hubbard <jhubbard@nvidia.com>
Date: Thu, 13 Feb 2020 20:33:23 -0800
Subject: [Ocfs2-devel] [PATCH v5 01/13] mm: Fix the return type of
 __do_page_cache_readahead
In-Reply-To: <20200214042137.GX7778@bombadil.infradead.org>
References: <20200211010348.6872-1-willy@infradead.org>
	<20200211010348.6872-2-willy@infradead.org>
	<e0f459af-bb5d-58b9-78be-5adf687477c0@nvidia.com>
	<20200214042137.GX7778@bombadil.infradead.org>
Message-ID: <ab9d0e43-3fb4-cb14-4974-ad4a8ab57a83@nvidia.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2/13/20 8:21 PM, Matthew Wilcox wrote:
> On Thu, Feb 13, 2020 at 07:19:53PM -0800, John Hubbard wrote:
>> On 2/10/20 5:03 PM, Matthew Wilcox wrote:
>>> @@ -161,7 +161,7 @@ unsigned int __do_page_cache_readahead(struct address_space *mapping,
>>>  	unsigned long end_index;	/* The last page we want to read */
>>>  	LIST_HEAD(page_pool);
>>>  	int page_idx;
>>
>>
>> What about page_idx, too? It should also have the same data type as nr_pages, as long as
>> we're trying to be consistent on this point.
>>
>> Just want to ensure we're ready to handle those 2^33+ page readaheads... :)
> 
> Nah, this is just a type used internally to the function.  Getting the
> API right for the callers is the important part.
> 

Agreed that the real point of this is to match up the API, but why not finish the job
by going all the way through? It's certainly not something we need to lose sleep over,
but it does seem like you don't want to have code like this:

        for (page_idx = 0; page_idx < nr_to_read; page_idx++) {

...with the ability, technically, to overflow page_idx due to it being an int,
while nr_to_read is an unsigned long. (And the new sanitizers and checkers are
apt to complain about it, btw.)

(Apologies if there is some kernel coding idiom that I still haven't learned, about this 
sort of thing.)

thanks,
-- 
John Hubbard
NVIDIA
