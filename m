From: Tao Ma <tm@tao.ma>
Date: Fri, 31 Dec 2010 22:27:35 +0800
Subject: [Ocfs2-devel] [PATCH 05/34] ocfs2: Remove mlog(0) from
	fs/ocfs2/alloc.c
In-Reply-To: <20101231131524.GB27129@lst.de>
References: <4D12F7E7.1090204@tao.ma>
	<1293089477-5019-5-git-send-email-tm@tao.ma>
	<20101231131524.GB27129@lst.de>
Message-ID: <4D1DE857.6070504@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Christoph,
	Thanks for the review.
On 12/31/2010 09:15 PM, Christoph Hellwig wrote:
>> diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
>> index 8d4e49a..2dfc3b0 100644
>> --- a/fs/ocfs2/ocfs2_trace.h
>> +++ b/fs/ocfs2/ocfs2_trace.h
>> @@ -6,6 +6,507 @@
>>
>>   #include<linux/tracepoint.h>
>>
>> +DECLARE_EVENT_CLASS(ocfs2__int,
>> +
>> +	TP_PROTO(int num),
>> +
>> +	TP_ARGS(num),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(	int,	num			)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->num	= 	num;
>> +	),
>> +
>> +	TP_printk("%d", __entry->num)
>> +);
>
> If you'd split the even up into classes depending on the actual meaning
> of num the trace could contain a descriptive name that makes it a lot
> more readable.  And btw, the above would be a lot more readable if
> formatted like normal kernel code:
>
> DECLARE_EVENT_CLASS(ocfs2__int,
> 	TP_PROTO(int num),
> 	TP_ARGS(num),
> 	TP_STRUCT__entry(
> 		__field(int, num)
> 	),
> 	TP_fast_assign(
> 		__entry->num = num;
> 	),
>
> 	TP_printk("%d", __entry->num)
> );
ok, I will change it in the next round.
>
>> +DEFINE_EVENT(ocfs2__truncate_log_ops, ocfs2_truncate_log_append,
>> +
>> +	TP_PROTO(unsigned long long blkno, int index,
>> +		 unsigned int start, unsigned int num),
>> +
>> +	TP_ARGS(blkno, index, start, num)
>> +);
>
> FYI, if you have a lot of instances ofa given even class using a little
> macro makes declaring them a lot simpler, take a look at
> fs/xfs/linux-2.6/xfs_trace.h for examples.
OK, I will look at it and use a macro. thanks.

Regards,
Tao
