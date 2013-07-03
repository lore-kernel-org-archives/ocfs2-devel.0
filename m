From: Jeff Liu <jeff.liu@oracle.com>
Date: Wed, 03 Jul 2013 18:07:39 +0800
Subject: [Ocfs2-devel] why oracle give up dlm by disk on ocfs2? because
 performance?
In-Reply-To: <51D3E099.10908@huawei.com>
References: <51CE541B.4070807@huawei.com> <51D22B4E.6020406@huawei.com>
	<CAEeiSHWkiEiJCMjvVkAB+AGM9LUVLqw3de-tdU3K+z5=mfSF5w@mail.gmail.com>
	<51D235F8.1040503@huawei.com>
	<20130702172030.GF32502@wotan.suse.de>
	<51D37DF0.1010704@huawei.com> <51D3B163.4000308@oracle.com>
	<51D3E099.10908@huawei.com>
Message-ID: <51D3F7EB.7010003@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 07/03/2013 04:28 PM, Jensen wrote:

> On 2013/7/3 13:06, Jeff Liu wrote:
> 
>> On 07/03/2013 09:27 AM, Jensen wrote:
>>
>>> On 2013/7/3 1:20, Mark Fasheh wrote:
>>>
>>>> On Tue, Jul 02, 2013 at 10:07:52AM +0800, Jensen wrote:
>>>>> On 2013/7/2 9:35, Sunil Mushran wrote:
>>>>>
>>>>>> A general purpose file system requires one to manage over a million locks concurrently. So performance is the main reason.
>>>>>>
>>>>>
>>>>> Thanks for your comments.
>>>>>
>>>>> Has Oracle compared the performance between ocfs2 and ocfs1?
>>>>
>>>> Firstly, that's implied in the answer you just got. Also, who wouldn't
>>>> compare performance from one version of a file system to the next?
>>>>
>>>> Can you please cut to the chase and either ask what you really want to know
>>>> or make the statement you're trying to make so we can move on?
>>>>
>>>
>>>
>>> Thanks for your answer.
>>> we want to use compare and write scsi command to replace DLM module. it is similar
>>> with vmware vmfs.
>>>
>>
>> I'm not trying to answer this question.
>>
>> I knew that OCFS2 is deployed in HuaWei.com in a large-scale cluster up
>> to 128 nodes, so I'm not very much surprised at something you mentioned
>> below, but...
>>
>>> why we want to replace dlm in ocfs2? because:
>>> 1. The stability of ocfs2 dlm is very poor, we found 100+ bug.
>>
>> That sounds interesting, how to classify those problems?
>> - Fatal error, panic
>> - Result in an interruption in service
>> - Wrong results, but can work around?
>> - Trivial
>>
>> Reporting bugs to bugzilla/OCFS2 would be useful to keep track of them:
>> https://oss.oracle.com/bugzilla/
>>
> 
> 
> Recently, Huawei has send many bug to open source community. which bug exist in
> open source. 

We always appreciating the contributions.

> other change or bug belong to enforce ocfs2 function ,for example, when disk
> timeout, open source code will reboot the machine, we modify it, we set the ocfs2
> invalid(can't read and write), open source may not interesting with those modify.

Why not give a try if those changes are fair enough?

Look at what you mentioned and what I asked above:
">>> 1. The stability of ocfs2 dlm is very poor, we found 100+ bug."

If take away around 10 DLM related patches from HuaWei, so the left several DLM
bugs(might be) are totally can not be fixed in mainline?

This sort of replies can provide nothing useful information to the community and
it is in fact a waste of our(yours and my) time.

I understand that we have a language barrier for the communication to the open
source community, but some of your questions/feedbacks are deserve to spend a few
days to think it over before sending it out to the public, so that someone who is
capable to answer your questions can well understand your opinions. :)

> 
>> Thanks,
>> -Jeff
>>
>>> 2. The Reliability of ocfs2 dlm is very poor, especially in network split, the
>>>    worse case split two domain, the half of node must be reboot.
>>> 3. the maximum number of mounted machine is 32, we want to support more.
>>>
>>> currently we worry about two thing:
>>> 1. The performance lock and unlock. because it use the scsi command and it is similar with IO read and write.
>>> 2. The change is very very large. because it maybe modify the disk layout of ocfs2.
>>>
>>> so anyone interested with this?
>>>
>>>> Thanks,
>>>> 	--Mark
>>>>
>>>> --
>>>> Mark Fasheh
>>>>
>>>>
>>>
>>>
>>>
>>>
>>> _______________________________________________
>>> Ocfs2-devel mailing list
>>> Ocfs2-devel at oss.oracle.com
>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
>>
>>
>>
> 
> 
> 
