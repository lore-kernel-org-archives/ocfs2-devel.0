From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Wed, 06 Jul 2011 23:19:22 -0700
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: fix slow deleting
In-Reply-To: <4E13FE03.5060005@oracle.com>
References: <201107060529.p665TY59014082@acsmt356.oracle.com>
	<4E13FE03.5060005@oracle.com>
Message-ID: <4E154FEA.5030406@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 7/5/2011 11:17 PM, Sunil Mushran wrote:
> 2. All nodes have to scan all slots. Even live slots. I remember we 
> did for
> a reason. And that reason should be in the comment in the patch written
> by Srini.
When a node unlinks a file it inserts an entry into it's own orphan 
slot. If another node is the last one to close the file and dentry got 
flushed then it will not do the cleanup as it doesn't know the file was 
orphaned. The file will remain in the orphan slot  till the node umounts 
and the same slot is reused again. To overcome this problem a node has 
to rescan all slots(including live slots) and try to do the cleanup.
