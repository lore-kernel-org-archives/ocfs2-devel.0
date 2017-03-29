From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Wed, 29 Mar 2017 14:38:37 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: o2hb: revert hb threshold to keep
 compatible
In-Reply-To: <9ec84184-3e4e-e26b-61eb-e960740d2081@gmail.com>
References: <1490665245-15374-1-git-send-email-junxiao.bi@oracle.com>
	<20170328153146.da60162a5a5d02c34cdd848e@linux-foundation.org>
	<903c2745-edff-09d3-1db7-55996ba87d53@oracle.com>
	<9ec84184-3e4e-e26b-61eb-e960740d2081@gmail.com>
Message-ID: <6d1de026-c9c7-5900-6526-ce7c4140e5ab@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 03/29/2017 12:01 PM, Joseph Qi wrote:
> 
> 
> On 17/3/29 09:07, Junxiao Bi wrote:
>> On 03/29/2017 06:31 AM, Andrew Morton wrote:
>>> On Tue, 28 Mar 2017 09:40:45 +0800 Junxiao Bi <junxiao.bi@oracle.com>
>>> wrote:
>>>
>>>> Configfs is the interface for ocfs2-tools to set configure to
>>>> kernel. Change heartbeat dead threshold name in configfs will
>>>> cause compatible issue, so revert it.
>>>>
>>>> Fixes: 45b997737a80 ("ocfs2/cluster: use per-attribute show and
>>>> store methods")
>>> I don't get it.  45b997737a80 was merged nearly two years ago, so isn't
>>> it a bit late to fix compatibility issues?
>>>
>> This compatibility will not cause ocfs2 down, just some configure (hb
>> dead threshold) lose effect. If someone want to use the new kernel, they
>> should apply this fix.
> The threshold configuration file has default value in kernel, so it will
> only affect changing this value in user space.
Right. Thank you.

> 
> Thanks,
> Joseph
>>
>> Thanks,
>> Junxiao.
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
