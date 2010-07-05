From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 05 Jul 2010 09:38:42 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: No need to zero pages past
 i_size. i_size v2
In-Reply-To: <4C30A4FD.4030900@oracle.com>
References: <20100702224912.GC5800@mail.oracle.com>
	<20100703213219.GB21262@mail.oracle.com>
	<20100703213343.GC21262@mail.oracle.com>
	<4C30A4FD.4030900@oracle.com>
Message-ID: <4C3137A2.8040409@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>

Hi Joel,

On 07/04/2010 11:13 PM, Tao Ma wrote:
> Hi Joel,
>
> On 07/04/2010 05:33 AM, Joel Becker wrote:
>> Here's the second patch, the one that keeps us from zeroing
>> pages past i_size. This should keep ocfs2 and Dave's writeback patch
>> happy.
>>
>> Joel
>>
>> -------------------------------------------------------
>>
>> When ocfs2 fills a hole, it does so by allocating clusters. When a
>> cluster is larger than the write, ocfs2 must zero the portions of the
>> cluster outside of the write. If the clustersize is smaller than a
>> pagecache page, this is handled by the normal pagecache mechanisms, but
>> when the clustersize is larger than a page, ocfs2's write code will zero
>> the pages adjacent to the write. This makes sure the entire cluster is
>> zeroed correctly.
>>
>> Currently ocfs2 behaves exactly the same when writing past i_size.
>> However, this means ocfs2 is writing zeroed pages for portions of a new
>> cluster that are beyond i_size. The page writeback code isn't expecting
>> this. It treats all pages past the one containing i_size as left behind
>> due to a previous truncate operation.
>>
>> Thankfully, ocfs2 calculates the number of pages it will be working on
>> up front. The rest of the write code merely honors the original
>> calculation. We can simply trim the number of pages to only cover the
>> actual file data.
>>
>> Signed-off-by: Joel Becker<joel.becker@oracle.com>
>> ---
>> fs/ocfs2/aops.c | 15 +++++++++++----
>> 1 files changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>> index 96e6aeb..e90ad74 100644
>> --- a/fs/ocfs2/aops.c
>> +++ b/fs/ocfs2/aops.c
> <snip>
>> @@ -1142,11 +1143,17 @@ static int ocfs2_grab_pages_for_write(struct
>> address_space *mapping,
>> /*
>> * Figure out how many pages we'll be manipulating here. For
>> * non allocating write, we just change the one
>> - * page. Otherwise, we'll need a whole clusters worth.
>> + * page. Otherwise, we'll need a whole clusters worth. If we're
>> + * writing past i_size, we only need enough pages to cover the
>> + * last page of the write.
> The comments for the whole function before the function name also needs
> this change accordingly?
>> */
>> if (new) {
>> wc->w_num_pages = ocfs2_pages_per_cluster(inode->i_sb);
>> start = ocfs2_align_clusters_to_page_index(inode->i_sb, cpos);
>> + /* This is the index *past* the write */
>> + end_index = ((user_pos + user_len)>> PAGE_CACHE_SHIFT) + 1;
> should it be
> end_index = ((user_pos + user_len - 1) >> PAGE_CACHE_SHIFT) + 1?
>
>
>> + if ((start + wc->w_num_pages)> end_index)
>> + wc->w_num_pages = end_index - start;
> I just noticed that the below loop in ocfs2_grab_pages_for_write is
> for (i = 0; i < wc->w_num_pages; i++)
>
> I guess w_num_pages should be set to end_index -
> start_page_of_the_cluster so that we can make sure we grab all the pages
> in this cluster until i_size?
oh, start is set to that value, sorry for this bit.
btw, do we ever have a chance that start + wc->w_num_pages > end_index? 
I can't find it.

Regards,
Tao
