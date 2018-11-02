From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 2 Nov 2018 08:57:54 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: free up write context when direct
 IO failed
In-Reply-To: <f5137f2d-e3af-c718-ac75-219b854d33ac@oracle.com>
References: <20181101211531.21036-1-wen.gang.wang@oracle.com>
	<f5137f2d-e3af-c718-ac75-219b854d33ac@oracle.com>
Message-ID: <dd1709d3-2b85-8d68-e7c6-096e4e8b570b@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 2018/11/1 19:51, Junxiao Bi wrote:
> On 11/02/2018 05:15 AM, Wengang Wang wrote:
>
>> The write context should also be freed even when direct IO failed.
>> Otherwise a memory leak is introduced and entries remain in
>> oi->ip_unwritten_list causing the following BUG later in unlink path:
>>
>> ERROR: bug expression: !list_empty(&oi->ip_unwritten_list)
>> ERROR: Clear inode of 215043, inode has unwritten extents
>> ...
>> Call Trace:
>> ? __set_current_blocked+0x42/0x68
>> ocfs2_evict_inode+0x91/0x6a0 [ocfs2]
>> ? bit_waitqueue+0x40/0x33
>> evict+0xdb/0x1af
>> iput+0x1a2/0x1f7
>> do_unlinkat+0x194/0x28f
>> SyS_unlinkat+0x1b/0x2f
>> do_syscall_64+0x79/0x1ae
>> entry_SYSCALL_64_after_hwframe+0x151/0x0
>>
>> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
>> ---
>> ? fs/ocfs2/aops.c | 11 +++++++++--
>> ? 1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
>> index 302cd7c..a87ca42d 100644
>> --- a/fs/ocfs2/aops.c
>> +++ b/fs/ocfs2/aops.c
>> @@ -2412,8 +2412,15 @@ static int ocfs2_dio_end_io(struct kiocb *iocb,
>> ????? /* this io's submitter should not have unlocked this before we 
>> could */
>> ????? BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
>> ? -??? if (bytes > 0 && private)
>> -??????? ret = ocfs2_dio_end_io_write(inode, private, offset, bytes);
>> +??? if (private) {
>> +??????? if (bytes > 0) {
>> +??????????? ret = ocfs2_dio_end_io_write(inode, private, offset,
>> +???????????????????????????? bytes);
>> +??????? } else {
>> +??????????? mlog(ML_ERROR, "Direct IO failed, free write ctx");
> Is it useful to leave the "bytes" value here? It could be some error 
> code.
>
That would be error come from below file system, but we can log it.
Will send v2 to add "bytes".

thanks,
wengang
> Thanks,
> Junxiao.
>> + ocfs2_dio_free_write_ctx(inode, private);
>> +??????? }
>> +??? }
>> ? ????? ocfs2_iocb_clear_rw_locked(iocb);
>
