From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 10 Feb 2009 11:43:45 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V2).
In-Reply-To: <20090210032554.GF4341@mail.oracle.com>
References: <200812120900.mBC90imR012722@localhost.localdomain>
	<20090130011115.GF12502@mail.oracle.com>
	<4990D968.1050703@oracle.com>
	<20090210032554.GF4341@mail.oracle.com>
Message-ID: <4990F7F1.9000903@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Tue, Feb 10, 2009 at 09:33:28AM +0800, Wengang Wang wrote:
>> one thing is that, the "nfs_sync_lock" will be one in count or more than 
>> one?
>> I think having lots of this kind of lock(one for each meta block) will 
>> bring us least performance impact for deletions.
>> well so much locks eat memory. for balancing, how about setting up 16(or 
>> 32) such locks? different inode goes to different lock according to its 
>> block number. and 16(or 32) such locks won't take much memory. --just 
>> like the idea in my original patch.
> 
> 	No, we'll have one lock per superblock.  There's no performance
> impact unless you have stale NFS clients.  We take the lock in PR mode
> in delete_inode, and the lock caching mechanism will keep it for us.
> The lock will only be unlocked when a stale NFS client wants to lookup
> its handle.  Otherwise, all nodes will share the PR lock.

yes. I know what EX/PR mean and lock caching.
for NFS backed on OCFS2, I think there could be stale clients according 
to the file accessing mode(create, delete on so on) on ocfs2.
when a EX lock is held for nfs, all delete_inode()s have to wait. that's 
a big lock and could be a performance impact. here, I emphasize ALL. I 
don't think it's simply like rename lock.

is that an abnormal case?

thanks,
wengang.
