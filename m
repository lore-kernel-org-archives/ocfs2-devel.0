From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 13 Jul 2010 22:25:53 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: Don't duplicate page passes
	i_size during CoW.
In-Reply-To: <20100713081538.GC31479@mail.oracle.com>
References: <20100712091412.GA19583@mail.oracle.com>
	<1278991352-5540-1-git-send-email-tao.ma@oracle.com>
	<20100713081306.GB31479@mail.oracle.com>
	<20100713081538.GC31479@mail.oracle.com>
Message-ID: <4C3C7771.5000103@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Tue, Jul 13, 2010 at 01:13:06AM -0700, Joel Becker wrote:
>   
>> On Tue, Jul 13, 2010 at 11:22:32AM +0800, Tao Ma wrote:
>>     
>>> +	/*
>>> +	 * We only duplicate pages until we reach i_size.
>>> +	 * So trim 'end' to the boundary of that page.
>>> +	 */
>>> +	if (end > i_size_read(context->inode))
>>> +		end = ((i_size_read(context->inode) + PAGE_CACHE_SIZE - 1) >>
>>> +			 PAGE_CACHE_SHIFT) << PAGE_CACHE_SHIFT;
>>>       
>
> 	Why even worry about that?  We only need up to i_size.  If end
> is safe and not page aligned, so is i_size.
>   
i_size isn't safe in ocfs2_duplicate_clusters_by_page. Check the below 
function.

            if (page_has_buffers(page)) {
                        ret = walk_page_buffers(handle, page_buffers(page),
                                                from, to, &partial,
                                                ocfs2_clear_cow_buffer);
                        if (ret) {
                                mlog_errno(ret);
                                goto unlock;
                        }
                }
So 'to' is limited to 'map_end' and then 'end'. If we set 'end' to 
i_size, we may not clear all the buffer heads
since walk_page_buffers will only call ocfs2_clear_cow_buffer within 
from and to.
Maybe we can improve it somehow later, but I would leave it as-is now.

Regards,
Tao
