From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 22 Apr 2009 16:37:53 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: Log -EIO errors just when hit
 them.
In-Reply-To: <49EF4339.4020706@oracle.com>
References: <200904170744.n3H7iJac013765@acsinet15.oracle.com>	<49E8F93B.40300@oracle.com>	<49EF3AC7.9050608@oracle.com>
	<49EF4339.4020706@oracle.com>
Message-ID: <49EED761.6090503@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi wengang,
	I just went through the thread. It looks that Sunil said that "From my 
scan, at least in mainline, all these EIOs are being logged by the 
caller. So this patch is not adding any value. "

I guess his meaning is that since all the callers has already logged the 
-EIO error, your patch does't add any value for it. So you may go in the 
wrong direction.

Regards,
Tao

Wengang Wang wrote:
> Hi,
> 
> I noticed ocfs2_end_buffer_io_sync() is only for 1.2
> need to do something for 1.4
> 
> regards,
> wengang.
> 
> Wengang Wang wrote:
>> Hi Sunil and Joel,
>>
>> For the EIO log problem, ocfs2_end_buffer_io_sync() is used as the 
>> callback function b_end_io
>> for both READ and WRITE.
>> I noticed that in this function,
>>
>> if (!uptodate)
>>     mlog_errno(-EIO);
>>
>> Isn't the 2 lines enough to log EIO errors?
>>
>> regards,
>> wengang.
>>
>> Sunil Mushran wrote:
>>   
>>> I imagine this is for the unlogged EIOs that have been reported.
>>>
>>> From my scan, at least in mainline, all these EIOs are being logged
>>> by the caller. So this patch is not adding any value. Can you double
>>> check that please?
>>>
>>> Now it could be that the reported EIOs are on 1.2/1.4 and that those
>>> trees are missing the mlogs. In that case, the patch should be specific
>>> to the tree.
>>>
>>> BTW, the (u64) should be (unsigned long long). This ensures that
>>> it compiles warning free on all arches.
>>>
>>>     
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>   
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
