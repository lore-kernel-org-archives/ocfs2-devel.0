From: Changwei Ge <ge.changwei@h3c.com>
Date: Thu, 10 Aug 2017 10:49:24 +0000
Subject: [Ocfs2-devel] [PATCH] ocfs2: re-queue AST or BAST if sending is
 failed to improve the reliability
References: <63ADC13FD55D6546B7DECE290D39E373AC2CB721@H3CMLB14-EX.srv.huawei-3com.com>
	<6b282ca9-f7b9-08d6-666d-565098587475@gmail.com>
	<SG2PR0601MB1871B5C9B91D7E6B03FA9FD2D58B0@SG2PR0601MB1871.apcprd06.prod.outlook.com>
	<0c918113-72f5-eda6-acad-1679c6de392f@gmail.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373AC2CBD22@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joseph,


On 2017/8/10 17:53, Joseph Qi wrote:
> Hi Changwei,
>
> On 17/8/9 23:24, ge changwei wrote:
>> Hi
>>
>>
>> On 2017/8/9 ??7:32, Joseph Qi wrote:
>>> Hi,
>>>
>>> On 17/8/7 15:13, Changwei Ge wrote:
>>>> Hi,
>>>>
>>>> In current code, while flushing AST, we don't handle an exception that
>>>> sending AST or BAST is failed.
>>>> But it is indeed possible that AST or BAST is lost due to some kind of
>>>> networks fault.
>>>>
>>> Could you please describe this issue more clearly? It is better analyze
>>> issue along with the error message and the status of related nodes.
>>> IMO, if network is down, one of the two nodes will be fenced. So what's
>>> your case here?
>>>
>>> Thanks,
>>> Joseph
>> I have posted the status of related lock resource in my preceding email. 
>> Please check them out.
>>
>> Moreover, network is not down forever even not longer than threshold  to 
>> be fenced.
>> So no node will be fenced.
>>
>> This issue happens in terrible network environment. Some messages may be 
>> abandoned by switch due to various conditions.
>> And even frequent and fast link up and down will also cause this issue.
>>
>> In a nutshell,  re-queuing AST and BAST is crucial when link between 
>> nodes recover quickly. It prevents cluster from hanging.
>> So you mean the tcp packet is lost due to connection reset? IIRC,
Yes, it's something like that exception which I think is deserved to be
fixed within OCFS2.
> Junxiao has posted a patchset to fix this issue.
> If you are using the way of re-queuing, how to make sure the original
> message is *truly* lost and the same ast/bast won't be sent twice?
With regards to TCP layer, if it returns error to OCFS2, packets must
not be sent successfully. So no node will obtain such an AST or BAST.
With regards to OCFS2, my patch can guarantee that one AST/BAST can't be
queued on pending list twice of which are both sent successfully.

Thanks,
Changwei
>
> Thanks,
> Joseph
>  
>> Thanks,
>> Changwei
>>>> If above exception happens, the requesting node will never obtain an AST
>>>> back, hence, it will never acquire the lock or abort current locking.
>>>>
>>>> With this patch, I'd like to fix this issue by re-queuing the AST or
>>>> BAST if sending is failed due to networks fault.
>>>>
>>>> And the re-queuing AST or BAST will be dropped if the requesting node is
>>>> dead!
>>>>
>>>> It will improve the reliability a lot.
>>>>
>>>>
>>>> Thanks.
>>>>
>>>> Changwei.
>>> _______________________________________________
>>> Ocfs2-devel mailing list
>>> Ocfs2-devel at oss.oracle.com
>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
