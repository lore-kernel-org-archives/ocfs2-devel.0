From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 27 Dec 2017 16:56:27 +0800
Subject: [Ocfs2-devel] [PATCH v2] ocfs2: fall back to buffer IO when
 append dio is disabled with file hole existing
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373F2909565@H3CMLB12-EX.srv.huawei-3com.com>
References: <63ADC13FD55D6546B7DECE290D39E373F2908F5C@H3CMLB12-EX.srv.huawei-3com.com>
	<5A42062C.1020804@huawei.com>
	<63ADC13FD55D6546B7DECE290D39E373F2909081@H3CMLB12-EX.srv.huawei-3com.com>
	<94ccc327-90ec-59f5-c75a-eac6755e0eaa@oracle.com>
	<63ADC13FD55D6546B7DECE290D39E373F2909565@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <dabe5b6c-f9db-c4c9-ec4f-1a8a637e76e8@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 12/27/2017 03:46 PM, Changwei Ge wrote:

> Hi Junxiao,
>
> On 2017/12/27 15:35, Junxiao Bi wrote:
>> Hi Changwei,
>>
>> On 12/26/2017 05:20 PM, Changwei Ge wrote:
>>> Hi Alex
>>>
>>> On 2017/12/26 16:20, alex chen wrote:
>>>> Hi Changwei,
>>>>
>>>> On 2017/12/26 15:03, Changwei Ge wrote:
>>>>> The intention of this patch is to provide an option to ocfs2 users whether
>>>>> to allocate disk space while doing dio write.
>>>>>
>>>>> Whether to make ocfs2 fall back to buffer io is up to ocfs2 users through
>>>>> toggling append-dio feature. It rather makes ocfs2 configurable and
>>>>> flexible.
>>>>>
>>>> It is too strange to make ocfs2 fall back to buffer io by toggling append-dio feature.
>>> It might be.
>>> But as my changelog said, I think, append-dio is key to whether to allocate
>>> space with dio writing. So filling hole and appending file should have the same reflection.
>>>
>>> Besides, in the early days, ocfs2 truly falls back to buffer io when append-dio is disabled and file hole is encountered.
>> I think we have discussed a lot in your v1 version. This wasn't fit for
>> mainline, you can keep one off-mainline patch.
> Fine. I agree now.
> I give up trying to push this patch into mainline.
> BTW, could you please help review my another patch (ocfs2: try to reuse extent block in dealloc without meta_alloc) which is used to fix a dio crash issue?
> So without this patch, dio still won't hit such an issue.
> Your comments are very important to me.
Sure,? will look at it.

Thanks,
Junxiao.
>
> Thanks,
> Changwei
>
>> Thanks,
>> Junxiao.
>>
>
