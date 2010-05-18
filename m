From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 19 May 2010 07:10:15 +0800
Subject: [Ocfs2-devel] [PATCH 00/17 V2] ocfs2: Support for discontiguous
 block group.
In-Reply-To: <20100518224930.GN3239@mail.oracle.com>
References: <4BCFEF22.7080607@oracle.com>
	<20100517192147.GB22775@mail.oracle.com>
	<4BF1D73F.3030600@oracle.com>
	<20100518224556.GM3239@mail.oracle.com>
	<20100518224930.GN3239@mail.oracle.com>
Message-ID: <4BF31E57.3010401@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Tue, May 18, 2010 at 03:45:56PM -0700, Joel Becker wrote:
>   
>> On Tue, May 18, 2010 at 07:54:39AM +0800, Tao Ma wrote:
>>     
>>>> 	Let me know if/when your discontig-bg branch has the code you
>>>> want to go upstream.  It may already; I'm just confirming before I pull.
>>>>   
>>>>         
>>> It is ok there. please pull
>>>
>>> git://oss.oracle.com/git/tma/linux-2.6.git discontig-bg
>>>       
>> Tao,
>> 	This branch has the bogus orig_value_size fix.  The good one is
>> in the fixes branch, and they conflict.  Also, you have three patches in
>> this branch without descriptions:
>>
>>       patch speedup.fix
>>       patch unwritten.fix
>>       patch DLM.fix
>>
>> Please fix this.
>>     
>
> 	Actually, your discontig-bg branch doesn't look much like this
> patch series at all.
>   
yes, there are 2 changes in this branch against the patch I sent to the 
mailist(you can check the commit time for it).
1. for the patch  "ocfs2_claim_*() don't need an ocfs2_super argument", 
I rebased it since it has conflict with your new merge-window.
2. for the patch  "Add ocfs2_gd_is_discontig", we need 
le16_to_cpu(bg->bg_size).

Regards,
Tao
