From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 7 Jul 2008 13:50:37 -0700
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: Fixes tiny race between
	mount	and recovery
In-Reply-To: <1215462380-12975-4-git-send-email-sunil.mushran@oracle.com>
References: <1215462380-12975-1-git-send-email-sunil.mushran@oracle.com>
	<1215462380-12975-4-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080707205037.GB8651@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jul 07, 2008 at 01:26:19PM -0700, Sunil Mushran wrote:
> This patch fixes a tiny race between recovery and mount that could otherwise
> lead to a hang.

	First off, does this still exist in mainline?

<snip>
 
> The last step of the mount process calls for it to drop the EX on the superblock
> lock. The node holds onto the same lock level on its journal/slot lock.
> 
> The recovery thread then picks up the EX on the superblock lock and then takes
> the same lock for the journal/slot it is recovering.
> 
> This exposes a tiny race as another node mounting the volume could race the
> recovery thread for the EX on the superblock lock.
> 
> If that happens, that node could be assigned a dirty slot which it would recover.
> It too will then drop the EX on the superblock lock but hold onto the same
> lock level on its journal/slot lock.
> 
> Now when the recovery thread on the first node gets back the EX on the superblock
> lock, it will promptly attempt to get the EX on the journal/slot lock of the node
> it thinks is dirty but since has not only been recovered but also locked by
> another node.
> 
> Hang.
> 
> The fix here is to make the journal/slot EX lock request during recovery a trylock
> operation. If the trylock fails, it would indicate that that slot is in use and
> thus recovered.

	How do we distinguish this from a node that hasn't been evicted
yet?  If you recall, we first tried to eliminate the recovery map
completely, having recovery just trylock every journal to find the dead
node.  But if the node hasn't been evicted, the trylock fails.  Isn't
this the same thing?
	Let me try putting it another way.  The recovery thread just
sees entries.  It doesn't know whether they came from mount or from a
dead node event.  So, we have an entry.  Sure, it could be an entry that
was locked during mount, then unlocked, and now we're trying to relock.
The only way the trylock fails is if someone else recovered it.  That's
safe.  If it came from another path, though, we expect to sleep on that
lock - that's how we know the dlm has evicted it, because the lock
blocks until then.  How do we determine this is the case and sleep on
it?  Otherwise, our trylock fails, we skip it, then the dlm evicts it,
and noone has recovered it.  We then continue assuming the journal was
replayed, which it was not.
	I'm missing something, right?

Joel

-- 

"Anything that is too stupid to be spoken is sung."  
        - Voltaire

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
