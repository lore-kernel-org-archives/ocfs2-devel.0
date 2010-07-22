From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 22 Jul 2010 09:58:17 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: correct the refmap on recovery
 master
In-Reply-To: <20100722105131.GB3486@laptop.jp.oracle.com>
References: <201006101628.o5A0YmQN005612@rcsinet15.oracle.com>
	<20100719100959.GB3623@laptop.jp.oracle.com>
	<4C44E52B.6060704@oracle.com>
	<20100720025948.GB2936@laptop.cn.oracle.com>
	<4C46242D.3060305@oracle.com>
	<20100721122202.GA3291@laptop.jp.oracle.com>
	<4C473A4A.9050500@oracle.com>
	<20100722105131.GB3486@laptop.jp.oracle.com>
Message-ID: <4C4878A9.5060909@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 07/22/2010 03:51 AM, Wengang Wang wrote:
> On 10-07-21 11:19, Sunil Mushran wrote:
>    
>> So I discussed this problem with Srini. Yes, your patch is on the right
>> track. Just that it needs to be rebased atop Srini's patch.
>>
>>      
> It seems that Srini's patch is not committed to mainline yet.
>    

No, it is not as yet. But should be in the queue. Just get the patch from
Srini and rebase your patch atop it.
