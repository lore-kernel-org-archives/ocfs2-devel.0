From: Joseph Qi <jiangqi903@gmail.com>
Date: Wed, 23 Aug 2017 11:34:35 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: re-queue AST or BAST if sending is
 failed to improve the reliability
In-Reply-To: <b2d93241-cf33-9a31-224d-5cfc983f7ff9@oracle.com>
References: <63ADC13FD55D6546B7DECE290D39E373AC2CB721@H3CMLB14-EX.srv.huawei-3com.com>
	<6b282ca9-f7b9-08d6-666d-565098587475@gmail.com>
	<SG2PR0601MB1871B5C9B91D7E6B03FA9FD2D58B0@SG2PR0601MB1871.apcprd06.prod.outlook.com>
	<0c918113-72f5-eda6-acad-1679c6de392f@gmail.com>
	<63ADC13FD55D6546B7DECE290D39E373AC2CBD22@H3CMLB14-EX.srv.huawei-3com.com>
	<b2d93241-cf33-9a31-224d-5cfc983f7ff9@oracle.com>
Message-ID: <6d0c147b-c4d0-f748-79bb-09f0cd7a399a@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 17/8/23 10:23, Junxiao Bi wrote:
> On 08/10/2017 06:49 PM, Changwei Ge wrote:
>> Hi Joseph,
>>
>>
>> On 2017/8/10 17:53, Joseph Qi wrote:
>>> Hi Changwei,
>>>
>>> On 17/8/9 23:24, ge changwei wrote:
>>>> Hi
>>>>
>>>>
>>>> On 2017/8/9 ??7:32, Joseph Qi wrote:
>>>>> Hi,
>>>>>
>>>>> On 17/8/7 15:13, Changwei Ge wrote:
>>>>>> Hi,
>>>>>>
>>>>>> In current code, while flushing AST, we don't handle an exception that
>>>>>> sending AST or BAST is failed.
>>>>>> But it is indeed possible that AST or BAST is lost due to some kind of
>>>>>> networks fault.
>>>>>>
>>>>> Could you please describe this issue more clearly? It is better analyze
>>>>> issue along with the error message and the status of related nodes.
>>>>> IMO, if network is down, one of the two nodes will be fenced. So what's
>>>>> your case here?
>>>>>
>>>>> Thanks,
>>>>> Joseph
>>>> I have posted the status of related lock resource in my preceding email. 
>>>> Please check them out.
>>>>
>>>> Moreover, network is not down forever even not longer than threshold  to 
>>>> be fenced.
>>>> So no node will be fenced.
>>>>
>>>> This issue happens in terrible network environment. Some messages may be 
>>>> abandoned by switch due to various conditions.
>>>> And even frequent and fast link up and down will also cause this issue.
>>>>
>>>> In a nutshell,  re-queuing AST and BAST is crucial when link between 
>>>> nodes recover quickly. It prevents cluster from hanging.
>>>> So you mean the tcp packet is lost due to connection reset? IIRC,
>> Yes, it's something like that exception which I think is deserved to be
>> fixed within OCFS2.
>>> Junxiao has posted a patchset to fix this issue.
>>> If you are using the way of re-queuing, how to make sure the original
>>> message is *truly* lost and the same ast/bast won't be sent twice?
>> With regards to TCP layer, if it returns error to OCFS2, packets must
>> not be sent successfully. So no node will obtain such an AST or BAST.
> Right, but not only AST/BAST, other messages pending in tcp queue will
> also lost if tcp return error to ocfs2, this can also caused hung.
> Besides, your fix may introduce duplicated ast/bast message Joseph
> mentioned.
> Ocfs2 depends tcp a lot, it can't work well if tcp return error to it.
> To fix it, maybe ocfs2 should maintain its own message queue and ack
> messages while not depend on TCP.>
Agree. Or we can add a sequence to distinguish duplicate message. Under
this, we can simply resend message if fails.

Thanks,
Joseph
 
> Thanks,
> Junxiao.
