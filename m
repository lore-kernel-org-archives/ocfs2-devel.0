From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Tue Jul 20 17:08:40 2004
Subject: [Ocfs2-devel] A patch to improve the metadata reading
	throughput(a gainst svn1267)
Message-ID: <3ACA40606221794F80A5670F0AF15F8404EDD5CE@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

 

>-----Original Message-----
>Another thing that's on the list which you might be interested 
>in looking at
>is not sending all lock release messages. Some of them do 
>basically nothing
>on the other end in process_vote, so there's really no reason 
>to send them
>to the nodes at all. This should help alot when you've batched 
>up a ton of
>locks to release in commit_cache.
Now, in our patch, the release message will notify the other node
to throw away meta data caches, so they are not doing nothing.

>So are you planning to turn off immediate checkpointing for 
>all the other
>journal transactions? This is also on the list :) The only one 
>that *may* be
>troublesome I believe is truncate. Otherwise, the ones that 
>are left are:
>link, symlink, and rename.

Yes, the immediate checkpointing is the main reason for the 
low performance of these operations we found.

>> 4. readdir() may get old data after the data is written back 
>to disk in
>> journal asynchronously. It is not a bug. But which way is 
>better, sync
>> the new data to disk when other nodes notify READONLY message or just
>> let them get old data?
>No, we consider it a bug :)  The other nodes should be getting 
>up to date
>directory contents.
Now, in our patch, the release message is sent in journal
asynchronously,
so before that, we can think the write is not finished. So we think this
is 
accepted and not bug, of cause, resolved it is also ok.

Index: src/journal.c
===================================================================
--- src/journal.c	(revision 1267)
+++ src/journal.c	(working copy)
@@ -148,6 +148,8 @@
 	}
 	spin_unlock(&journal->cmt_lock);
 
+	if (osb->needs_flush)
+		ocfs_sync_blockdev(osb->sb);

>Is this necessary? It seems awfully heavy, and since we journal *all*>
>metadata (so it should be synced up to disk via the journal_flush just
a
>couple lines above that), I don't see the point... I was actually
meaning to
>take the other call to sync_blockdev out as it's never used :)

We added this just because we found that some times we can not see the
new created directory
from another node, but by adding this, we can always see. Seems
some buffer in block device's cache list are not flushed to disk after
journal_flush.
And after the lock release message is sent, the meta data cache on
another node can not be
throw away any more.So we must ensure all data is synced to disk on this
node before sending message.
