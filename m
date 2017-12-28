From: Changwei Ge <ge.changwei@h3c.com>
Date: Thu, 28 Dec 2017 06:30:27 +0000
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: try to reuse extent block in
 dealloc without meta_alloc
References: <63ADC13FD55D6546B7DECE290D39E373F2908FC7@H3CMLB12-EX.srv.huawei-3com.com>
	<5A435E3A.2060501@huawei.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F2909D58@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jun,

On 2017/12/27 16:48, piaojun wrote:
> Hi Changwei,
> 
> On 2017/12/26 15:55, Changwei Ge wrote:
>> A crash issue was reported by John.
>> The call trace follows:

>> without any metadata reserved ahead of time, try to reuse those extents
>> in dealloc in which deleted extents are cached.
>>
>> Also, this patch addresses the issue John reported that ::dw_zero_count is
>> not calculated properly.
> 
> Does you patch solve two different problems? If so, I suggest split it
> in two patch.

It might be considerable.

> 
>>
>> After applying this patch, the issue John reported was gone.
>> Thanks for the reproducer provided by John.
>> And this patch has passed ocfs2-test(29 cases) suite running by New H3C Group.
>>
ta;
>>    	et->et_object = obj;
>> +	et->et_dealloc = NULL;
> 
> I wonder if there is necessity setting NULL here, as we will resign it
> later.

I think it is necessary to evaluate ::et_dealloc to NULL here.
Since there are some other code patch also using this __ocfs2_init_extent_tree.
Besides, we need to use ::et_dealloc to judge if we can find some extent blocks
to reuse or if the dealloc is empty.

Thanks,
Changwei

> 
> thanks,
> Jun
> 
>>    

> 
