From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Sun, 18 Jan 2009 07:17:24 -0800
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: Inode Allocation Strategy
	Improvement.v2
In-Reply-To: <4972EF47.5090202@oracle.com>
References: <1232056719-27716-1-git-send-email-tao.ma@oracle.com>	
	<1232093128.6601.12.camel@tristan-laptop.cn.oracle.com>	
	<49704272.4080000@oracle.com>
	<1232122135.6601.51.camel@tristan-laptop.cn.oracle.com>
	<4972EF47.5090202@oracle.com>
Message-ID: <73490225-F30E-4CF1-ACCE-FBCA845ACBDC@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

How big is this disk? Maybe one kernel tree untar is not be enough to  
expose the original issue. Also, use ls -i and/or debugfs to see if  
the inodes have some locality.

On Jan 18, 2009, at 12:58 AM, Tao Ma <tao.ma@oracle.com> wrote:

>
>
> tristan.ye wrote:
>> On Fri, 2009-01-16 at 16:16 +0800, Tao Ma wrote:
>>
>>> tristan.ye wrote:
>>>
>> Tao,
>>
>> I've done 10 times tests with single-node testcase repeatly,  
>> following
>> is a average statistic reports
>> =============== Tests with 10 times iteration================
>>
>> 1st 'Tar xjvf' result:
>>
>> Average real time with 10 times:
>> Original kernel                            kernel with enhanced  
>> patches
>> 0m 43.578s                                       0m 49.355s
>>
>> 1st 'ls -lR' result:
>> Average real time with 10 times:
>> Original kernel                            kernel with enhanced  
>> patches
>> 0m 23.622s                                        0m 23.508s
>>
>> 1st 'rm -rf' result:
>> Average real time with 10 times:
>> Original kernel                            kernel with enhanced  
>> patches
>> 0m 57.039s                                       0m 58.612s
>>
>> 2rd 'Tar xjvf' result:
>> Average real time with 10 times:
>> Original kernel                            kernel with enhanced  
>> patches
>> 0m 49.550s                                       0m 52.214s
>>
>> 2rd 'ls -lR' result:
>> Average real time with 10 times:
>> Original kernel                            kernel with enhanced  
>> patches
>>
>> 0m 23.591s                                       0m 23.487s
>>
>> ===============Tests end============================
>>
>>
>>> From above tests, we really have had a speed-up performance gain  
>>> when
>> traversing files  by 'ls -lR' against a kernel tree:),but seems also
>> encountered a performance lose when populating the files by 'tar  
>> xvjf'
>> according to the contrast tests.
>>
> I am just a little confused with your test result. Especially the  
> last one.
> from the statistics, it looks that there is almost no performance gain
> comparing 0m23.591s with 0m 23.487s.
> But I see >2mins every time. So are you sure of it?
> anyway, thanks for your test and I will discuss it with you later.
>
> Regards,
> Tao
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
