From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 2 Feb 2010 20:23:14 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: don't leave free'd
	mle	attached to hb events
In-Reply-To: <4B1DB27F.1020008@oracle.com>
References: <200912071453.nB6Mhdbo021627@rgminet13.oracle.com>
	<4B1D76B1.1020404@oracle.com> <4B1DAF57.5020404@oracle.com>
	<4B1DB27F.1020008@oracle.com>
Message-ID: <20100202122314.GA4610@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Just a reminder:)

On 09-12-07 17:57, Sunil Mushran wrote:
> oops... I read it incorrectly. But that does not sound right.
> Let me think about it.
>
> Wengang Wang wrote:
>> Hi Sunil,
>>
>> Sunil Mushran wrote:
>>> NAK
>>>
>>> wengang wang wrote:
>>>> don't leave free'd mle attached to hb events.
>>>>     in dlm_add_migration_mle() the mle is attched to "heartbeat  
>>>> events" anyway no
>>>> matter there is an existing mle with same name(returns -EEXIST).
>>>> dlm_migrate_lockres() calls dlm_add_migration_mle(). in case the  
>>>> later function
>>>> returning -EEXIST, dlm_migrate_lockres() frees the (new) mle 
>>>> without detaching
>>>> it from "hb events". so that later "hb events" related operations  
>>>> could improperly
>>>> operate against wrong mle objects or against an invalid memory address.
>>>
