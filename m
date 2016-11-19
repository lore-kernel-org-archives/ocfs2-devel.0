From: piaojun <piaojun@huawei.com>
Date: Sat, 19 Nov 2016 11:49:39 +0800
Subject: [Ocfs2-devel] ocfs2: fix sparse file & data ordering issue in
 direct io
In-Reply-To: <582D9B6D.8080205@huawei.com>
References: <20160309102505.GA15030@mwanda> <582D9B6D.8080205@huawei.com>
Message-ID: <582FCBD3.7020708@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

sorry, my analysis is wrong. -EAGAIN will be eaten only when 'type' is
OCFS2_WRITE_MMAP in ocfs2_write_begin_nolock(). so uninitialized 'wc'
will not be dereferenced in ocfs2_dio_get_block() as abnormal branch
can catch error 'ret'.

thanks,
Jun

On 2016-11-17 19:58, piaojun wrote:
> Hi Carpenter,
> 
> I guess this may cause illegal memory access error as follows:
> 
> generic_perform_write
> --a_ops->write_begin(file, mapping, pos, bytes, flags, &page, &fsdata);
>   --ocfs2_write_begin_nolock
>     --ocfs2_grab_pages_for_write
> 	--return -EAGAIN if not enough pages
>     --'fsdata' will be uninitialized
> 
> --a_ops->write_end(file, mapping, pos, bytes, copied, page, fsdata);
>   --ocfs2_write_end_nolock
>     --the access of wc->w_di_bh->b_data will cause error.
> 
> if so, I suggest not eating error code and let upper level to handle
> this problem.
> 
> On 2016-3-9 18:25, Dan Carpenter wrote:
>> Hello Ryan Ding,
>>
>> The patch fbe25fb91af5: "ocfs2: fix sparse file & data ordering issue
>> in direct io" from Feb 25, 2016, leads to the following static
>> checker warning:
>>
>> 	fs/ocfs2/aops.c:2242 ocfs2_dio_get_block()
>> 	error: potentially dereferencing uninitialized 'wc'.
>>
>> fs/ocfs2/aops.c
>>   2235  
>>   2236          ret = ocfs2_write_begin_nolock(inode->i_mapping, pos, len,
>>   2237                                         OCFS2_WRITE_DIRECT, NULL,
>>   2238                                         (void **)&wc, di_bh, NULL);
>>                                                ^^^^^^^^^^^^
>>
>> See commit 5cffff9e2986 ('ocfs2: Fix ocfs2_page_mkwrite()') for an
>> explanation why a zero return here does not imply that "wc" has been
>> initialized.
>>
>>   2239          if (ret) {
>>   2240                  mlog_errno(ret);
>>   2241                  goto unlock;
>>   2242          }
>>   2243  
>>   2244          desc = &wc->w_desc[0];
>>   2245  
>>   2246          p_blkno = ocfs2_clusters_to_blocks(inode->i_sb, desc->c_phys);
>>
>> regards,
>> dan carpenter
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
>>
