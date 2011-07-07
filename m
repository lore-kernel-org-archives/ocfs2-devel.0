From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 07 Jul 2011 13:26:19 -0700
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: fix slow deleting
In-Reply-To: <4E1610C2.7060509@oracle.com>
References: <201107060529.p665TY59014082@acsmt356.oracle.com>	<4E13FE03.5060005@oracle.com>	<4E154FEA.5030406@oracle.com>
	<4E1610C2.7060509@oracle.com>
Message-ID: <4E16166B.3080808@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 07/07/2011 01:02 PM, Sunil Mushran wrote:
> On 07/06/2011 11:19 PM, Srinivas Eeda wrote:
>> On 7/5/2011 11:17 PM, Sunil Mushran wrote:
>>> 2. All nodes have to scan all slots. Even live slots. I remember we
>>> did for
>>> a reason. And that reason should be in the comment in the patch written
>>> by Srini.
>> When a node unlinks a file it inserts an entry into it's own orphan
>> slot. If another node is the last one to close the file and dentry got
>> flushed then it will not do the cleanup as it doesn't know the file was
>> orphaned. The file will remain in the orphan slot  till the node umounts
>> and the same slot is reused again. To overcome this problem a node has
>> to rescan all slots(including live slots) and try to do the cleanup.
> The qs is not why are we scanning all live slots on all nodes. As in,
> why not just recover the local slot. There was a reason for that.
> Yes, we have to recover unused slots for the reason listed previously.

bleh.... let me rephrase.

The qs is why are we scanning all live slots on all nodes. Wengangs
patch limits the scanning to the local (live) slot only. And I remember
we had a reason for it.
