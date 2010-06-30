From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 30 Jun 2010 09:46:30 +0800
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: Add readhead during CoW.
In-Reply-To: <20100629232342.GI4150@mail.oracle.com>
References: <4C29AE6C.1050205@oracle.com>
	<1277800541-6844-3-git-send-email-tao.ma@oracle.com>
	<20100629232342.GI4150@mail.oracle.com>
Message-ID: <4C2AA1F6.7060209@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,

On 06/30/2010 07:23 AM, Joel Becker wrote:
> On Tue, Jun 29, 2010 at 04:35:40PM +0800, Tao Ma wrote:
>> @@ -2953,6 +2957,14 @@ static int ocfs2_duplicate_clusters_by_page(handle_t *handle,
>>   		if (PAGE_CACHE_SIZE<= OCFS2_SB(sb)->s_clustersize)
>>   			BUG_ON(PageDirty(page));
>>
>> +		if (PageReadahead(page)&&  context->file) {
>> +			page_cache_async_readahead(mapping,
>> +						&context->file->f_ra,
>> +						   context->file,
>> +						   page, page_index,
>> +						   readahead_pages);
>> +		}
>
> 	This is merely re-sending the same pages that were already sent,
> right?  In the previous patch, you asked the readahead code to try all
> pages in the hunk.  Now you've discovered a page that isn't yet up to
> date, and you send it (and the 1M next to it) back to readahead.
> 	This is, I assume, because the readahead code doesn't actually
> read your entire request from page_cache_sync_readahead().  It just
> reads some, and this is you hinting that you need the next bit.  Am I
> right?
The first previous patch just let the caller to do the readahead for the 
whole hunk and set PG_readahead to a page as the start of readahead 
window. So when we meet with a page with PG_readahead flag set,  we know 
it's time to move our readahead window so a new readahead is issued here.

Fengguang Wu has a document named "On the Design of a New Linux 
Readahead Framework", you can refer to it and hope I read it clearly.

Regards,
Tao
