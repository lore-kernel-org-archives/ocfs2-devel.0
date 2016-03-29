From: jiangyiwen <jiangyiwen@huawei.com>
Date: Tue, 29 Mar 2016 09:08:09 +0800
Subject: [Ocfs2-devel] [patch 19/25] ocfs2: o2hb: add negotiate timer
In-Reply-To: <56F95EF9.5030203@oracle.com>
References: <56f2f8b5.J89ZbuqS9aWdapr3%akpm@linux-foundation.org>
	<56F355F7.2040004@oracle.com> <56F5F9C9.7040105@huawei.com>
	<56F887AB.8050005@oracle.com> <56F92694.20204@huawei.com>
	<56F95EF9.5030203@oracle.com>
Message-ID: <56F9D579.3050000@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2016/3/29 0:42, Srinivas Eeda wrote:
> On 03/28/2016 05:41 AM, jiangyiwen wrote:
>> On 2016/3/28 9:23, Junxiao Bi wrote:
>>> Hi Yiwen,
>>>
>>> On 03/26/2016 10:54 AM, jiangyiwen wrote:
>>>> Hi, Junxiao
>>>> This patch may have a problem. That is journal of every nodes become
>>>> abort when storage down, and then when storage up, because journal
>>>> has become abort, all of operations of metadata will fail. So how to
>>>> restore environment? panic or reset? how to trigger?
>>> Journal aborted means io error was returned by storage, right?
>>> If so, o2hb_thread should also get io error, in this case, nego process
>>> will be bypassed, and nodes will be fenced at last, see "[patch 23/25]
>>> ocfs2: o2hb: don't negotiate if last hb fail".
>>>
>>> Thanks,
>>> Junxiao.
>>>> Thanks,
>>>> Yiwen Jiang.
>>>
>>> .
>>>
>> yes, you are right, sorry I don't see this patch before.
>>
>> But I understand the results of storage down should return IO error
>> rather than getting hang.
> that is upto the driver or storage. If they return I/O error, o2hb i/o's will get i/o errors and will be addressed accordingly. These changes are made for cases where storage is not yet responding due to head failovers/recovery on the storage array.
> 
>>
>> Thanks,
>> Yiwen Jiang.
>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> 
> .
> 
Thank you, I have already understood.
This patch is very useful, looks good to me.
