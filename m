From: Tao Ma <tao.ma@oracle.com>
Date: Sat, 17 Jul 2010 16:14:46 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: make __ocfs2_page_mkwrite handle
	file end properly.
In-Reply-To: <20100716195137.GA30859@mail.oracle.com>
References: <1279290060-2147-1-git-send-email-tao.ma@oracle.com>
	<20100716195137.GA30859@mail.oracle.com>
Message-ID: <4C416676.4020607@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> On Fri, Jul 16, 2010 at 10:21:00PM +0800, Tao Ma wrote:
>    
>> __ocfs2_page_mkwrite now is broken in handling file end.
>> 1. the last page should be the page contains i_size - 1.
>> 2. the len in the last page is also calculated wrong.
>> So change them accordingly.
>>      
>
> 	How did you determine these broken?  They look correct to me,
> and they passed the mmap testing I ran against the tail zeroing fixes.
> Comments inline.
>
>    
>> diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
>> index af2b8fe..4c18f4a 100644
>> --- a/fs/ocfs2/mmap.c
>> +++ b/fs/ocfs2/mmap.c
>> @@ -74,9 +74,11 @@ static int __ocfs2_page_mkwrite(struct inode *inode, struct buffer_head *di_bh,
>>   	/*
>>   	 * Another node might have truncated while we were waiting on
>>   	 * cluster locks.
>> +	 * We don't check size == 0 before the shift. This is borrowed
>> +	 * from do_generic_file_read.
>>   	 */
>> -	last_index = size>>  PAGE_CACHE_SHIFT;
>> -	if (page->index>  last_index) {
>>      
>
> 	This original check seems correct.  If size is on a page
> boundary, sure the last_index is past the last page of the file.
> That's OK, we're checking that page->index isn't greater than that.
>    
No, it is broken.
so say i_size = 4096. the last valid page index should be 0 not 1.
and if the page that requirs to mk_write has page->index = 1, we should 
fail in this case.
While the old one let us go.
As I said in the comment, this code is borrowed from 
do_generic_file_read. So you can check
that file for detail.
1034                 isize = i_size_read(inode);
1035                 end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
1036                 if (unlikely(!isize || index > end_index)) {
1037                         page_cache_release(page);
1038                         goto out;
1039                 }

>    
>> @@ -107,7 +109,7 @@ static int __ocfs2_page_mkwrite(struct inode *inode, struct buffer_head *di_bh,
>>   	 * because the "write" would invalidate their data.
>>   	 */
>>   	if (page->index == last_index)
>> -		len = size&  ~PAGE_CACHE_MASK;
>> +		len = ((size - 1)&  ~PAGE_CACHE_MASK) + 1;
>>      
>
> 	And the len calculation is only broken because you changed what
> last_index meant.  Originally, if the page equals the last_index, size
> cannot be page aligned, and you are guaranteed a proper len.
> 	You know, if you don't like the way last_index reads, we can
> always steal the ext4 comparison:
>
> 5982         if (page->mapping != mapping || size<= page_offset(page)
> 5983             || !PageUptodate(page)) {
> 5984                 /* page got truncated from under us? */
> 5985                 goto out_unlock;
> 5986         }
>
> <snip>
>
> 5990
> 5991         if (page->index == size>>  PAGE_CACHE_SHIFT)
> 5992                 len = size&  ~PAGE_CACHE_MASK;
> 5993         else
> 5994                 len = PAGE_CACHE_SIZE;
>
> 	This is a direct compare on the page_offset, which doesn't
> confuse anyone about index vs i_size.  Later, they directly check "is
> this page the last in the file" before computing len.
>    
My code is borrowed from do_generic_file_read and I think it looks good. 
See here.
1042                 nr = PAGE_CACHE_SIZE;
1043                 if (index == end_index) {
1044                         nr = ((isize - 1) & ~PAGE_CACHE_MASK) + 1;
1045                         if (nr <= offset) {
1046                                 page_cache_release(page);
1047                                 goto out;
1048                         }
1049                 }

Regards,
Tao

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20100717/b492db37/attachment.html 
