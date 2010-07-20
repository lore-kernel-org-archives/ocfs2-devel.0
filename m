From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 20 Jul 2010 15:33:17 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: correct the refmap on recovery
 master
In-Reply-To: <20100720025948.GB2936@laptop.cn.oracle.com>
References: <201006101628.o5A0YmQN005612@rcsinet15.oracle.com>
	<20100719100959.GB3623@laptop.jp.oracle.com>
	<4C44E52B.6060704@oracle.com>
	<20100720025948.GB2936@laptop.cn.oracle.com>
Message-ID: <4C46242D.3060305@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 07/19/2010 07:59 PM, Wengang Wang wrote:
>> Do you have the message sequencing that would lead to this situation?
>> If we migrate the lockres to the reco master, the reco master will send
>> an assert that will make us change the master.
>>      
> So first, the problem is not about the changing owner. It is that
> the bit(in refmap) on behalf of the node in question is not cleared on the new
> master(recovery master). So that the new master will fail at purging the lockres
> due to the incorrect bit in refmap.
>
> Second, I have no messages at hand for the situation. But I think it is simple
> enough.
>
> 1) node A has no interest on lockres A any longer, so it is purging it.
> 2) the owner of lockres A is node B, so node A is sending de-ref message
> to node B.
> 3) at this time, node B crashed. node C becomes the recovery master. it recovers
> lockres A(because the master is the dead node B).
> 4) node A migrated lockres A to node C with a refbit there.
> 5) node A failed to send de-ref message to node B because it crashed. The failure
> is ignored. no other action is done for lockres A any more.
>    

In dlm_do_local_recovery_cleanup(), we expicitly clear the flag...
when the owner is the dead_node. So this should not happen.

Your patch changes the logic to exclude such lockres' from the
recovery list. And that's a change, while possibly workable, needs
to be looked into more thoroughly.

In short, there is a disconnect between your description and your patch.
Or, my understanding.

> So node A means to drop the ref on the master. But in such a situation, node C
> keeps the ref on behalf of node A unexpectedly. Node C finally fails at purging
> lockres A and hang on umount.
>
>    
>> I think your problem is the one race we have concerning reco/migration.
>> If so, this fix is not enough.
>>      
> It's a problem of purging + recovery. no pure migration for umount here.
> So what's your concern?
>    

See above.
